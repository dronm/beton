#!/usr/bin/env php
<?php

declare(strict_types=1);

final class ProcessLock
{
	private string $fileName;
	private int $staleAfterSeconds;
	private ?string $warnScript;
	private bool $owned = false;

	public function __construct(string $fileName, int $staleAfterSeconds, ?string $warnScript)
	{
		$this->fileName = $fileName;
		$this->staleAfterSeconds = $staleAfterSeconds;
		$this->warnScript = $warnScript;
	}

	public function acquire(): bool
	{
		$directory = dirname($this->fileName);
		if(!is_dir($directory) && !mkdir($directory, 0770, true) && !is_dir($directory)){
			throw new RuntimeException('Unable to create lock directory: '.$directory);
		}

		if(file_exists($this->fileName)){
			$modifiedAt = filemtime($this->fileName);
			$age = $modifiedAt === false ? 0 : time() - $modifiedAt;

			if($age < $this->staleAfterSeconds){
				echo 'Lock file '.$this->fileName.' exists; exiting.'.PHP_EOL;
				return false;
			}

			$this->terminateStaleProcess();
		}

		$this->writeLock();
		$this->owned = true;

		register_shutdown_function(function(): void {
			$this->release();
		});

		return true;
	}

	public function heartbeat(): void
	{
		if(!$this->owned){
			return;
		}

		$this->writeLock();
	}

	public function release(): void
	{
		if(!$this->owned || !file_exists($this->fileName)){
			return;
		}

		$content = file_get_contents($this->fileName);
		if($content !== false && preg_match('/PID:(\d+)/', $content, $matches)){
			if((int)$matches[1] !== getmypid()){
				return;
			}
		}

		@unlink($this->fileName);
		$this->owned = false;
	}

	private function writeLock(): void
	{
		$result = file_put_contents(
			$this->fileName,
			date('c').' PID:'.getmypid().PHP_EOL,
			LOCK_EX,
		);

		if($result === false){
			throw new RuntimeException('Unable to write lock file: '.$this->fileName);
		}
	}

	private function terminateStaleProcess(): void
	{
		$content = file_get_contents($this->fileName);
		if($content === false || !preg_match('/PID:(\d+)/', $content, $matches)){
			@unlink($this->fileName);
			return;
		}

		$pid = (int)$matches[1];
		if($pid <= 1 || $pid === getmypid() || !function_exists('posix_kill')){
			@unlink($this->fileName);
			return;
		}

		if(!@posix_kill($pid, 0)){
			@unlink($this->fileName);
			return;
		}

		if(!$this->isSameScriptProcess($pid)){
			$message = 'ReglElkon: stale lock references active unrelated process '.$pid;
			$this->notify($message);
			throw new RuntimeException($message);
		}

		@posix_kill($pid, 15);
		for($attempt = 0; $attempt < 20; $attempt++){
			usleep(100000);
			if(!@posix_kill($pid, 0)){
				$message = 'ReglElkon: stale process '.$pid.' terminated successfully';
				$this->notify($message);
				@unlink($this->fileName);
				return;
			}
		}

		@posix_kill($pid, 9);
		$message = 'ReglElkon: stale process '.$pid.' forcefully killed';
		$this->notify($message);
		@unlink($this->fileName);
	}

	private function isSameScriptProcess(int $pid): bool
	{
		$cmdlineFile = '/proc/'.$pid.'/cmdline';
		if(!is_readable($cmdlineFile)){
			return true;
		}

		$cmdline = file_get_contents($cmdlineFile);
		if($cmdline === false){
			return true;
		}

		$cmdline = str_replace("\0", ' ', $cmdline);
		return str_contains($cmdline, basename(__FILE__));
	}

	private function notify(string $message): void
	{
		if($this->warnScript === null || $this->warnScript === '' || !is_executable($this->warnScript)){
			fwrite(STDERR, $message.PHP_EOL);
			return;
		}

		$command = escapeshellarg($this->warnScript)
			.' '.escapeshellarg($message)
			.' > /dev/null 2>&1 &';
		exec($command);
	}
}

final class ElkonImporter
{
	private const LOG_LEVEL_DEBUG = 9;
	private const LOG_LEVEL_NOTE = 3;
	private const LOG_LEVEL_ERROR = 0;

	private PDO $pg;
	private ProcessLock $lock;
	private int $defaultOperatorUserId;
	private int $batchSize;
	private int $sleepMicroseconds;

	/** @var array<int, PDO> */
	private array $elkonConnections = array();

	/** @var array<string, int|null> */
	private array $concreteTypeIds = array();

	/** @var array<string, int|null> */
	private array $siloIds = array();

	/** @var array<string, int|null> */
	private array $materialIds = array();

	public function __construct(array $config, ProcessLock $lock)
	{
		$this->lock = $lock;
		$this->defaultOperatorUserId = (int)($config['default_operator_user_id'] ?? 1);
		$this->batchSize = max(1, (int)($config['batch_size'] ?? 10));
		$this->sleepMicroseconds = max(0, (int)($config['sleep_microseconds'] ?? 100000));

		$postgres = $config['postgres'] ?? null;
		if(!is_array($postgres)){
			throw new InvalidArgumentException('Missing postgres configuration.');
		}

		$this->pg = new PDO(
			(string)($postgres['dsn'] ?? ''),
			(string)($postgres['user'] ?? ''),
			(string)($postgres['password'] ?? ''),
			array(
				PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
				PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
				PDO::ATTR_EMULATE_PREPARES => false,
			),
		);

		$this->configurePostgresSession();
	}

	public function run(): void
	{
		$sites = $this->pg
			->query('SELECT * FROM production_sites_last_production_list')
			->fetchAll();

		foreach($sites as $site){
			$this->lock->heartbeat();

			try{
				$this->processSite($site);
			}
			catch(Throwable $e){
				$siteId = (int)($site['id'] ?? 0);
				$connection = $this->decodeElkonConnection($site['elkon_connection'] ?? null, false);
				$logLevel = (int)($connection['logLevel'] ?? self::LOG_LEVEL_ERROR);
				$this->logAction($siteId, $e->getMessage(), self::LOG_LEVEL_ERROR, $logLevel);
				fwrite(STDERR, 'Site '.$siteId.': '.$e->getMessage().PHP_EOL);
			}
		}
	}

	private function processSite(array $site): void
	{
		$siteId = (int)$site['id'];
		$siteName = (string)($site['name'] ?? '');
		$elkon = $this->decodeElkonConnection($site['elkon_connection'] ?? null, true);
		$logLevel = (int)($elkon['logLevel'] ?? self::LOG_LEVEL_ERROR);

		$this->logAction(
			$siteId,
			'Проверка данных завод: '.$siteName,
			self::LOG_LEVEL_NOTE,
			$logLevel,
		);

		$this->connectToElkon($siteId, $elkon);

		$maxProductionId = isset($site['last_production_id'])
			? (int)$site['last_production_id']
			: 0;

		foreach($this->parsePostgresIntArray($site['production_ids'] ?? null) as $productionId){
			$this->lock->heartbeat();
			$maxProductionId = max($maxProductionId, $productionId);

			$materialData = $this->getClosedProductionMaterials($siteId, $elkon, $productionId);
			if($materialData !== null){
				echo 'Closing production '.$productionId.PHP_EOL;
				$this->closeProduction($site, $elkon, $productionId, $materialData);
			}

			$this->sleepBetweenRequests();
		}

		$newProductions = $this->getProductions($siteId, $elkon, $maxProductionId, '>');
		echo 'Got Elkon data, production count: '.count($newProductions).' for site ID: '.$siteId.PHP_EOL;
		$this->insertProductions($siteId, $newProductions, $logLevel, true);

		foreach($this->parsePostgresIntArray($site['missing_elkon_production_ids'] ?? null) as $missingProductionId){
			$this->lock->heartbeat();
			$productions = $this->getProductions($siteId, $elkon, $missingProductionId, '=');
			$this->insertProductions($siteId, $productions, $logLevel, false);
			$this->sleepBetweenRequests();
		}
	}

	private function connectToElkon(int $siteId, array $elkon): PDO
	{
		if(isset($this->elkonConnections[$siteId])){
			return $this->elkonConnections[$siteId];
		}

		if(!extension_loaded('pdo_dblib')){
			throw new RuntimeException('PDO_DBLIB extension is not loaded.');
		}

		$host = trim((string)($elkon['host'] ?? ''));
		$port = (int)($elkon['port'] ?? 1433);
		$database = trim((string)($elkon['databaseName'] ?? ''));
		$user = (string)($elkon['userName'] ?? '');
		$password = (string)($elkon['userPassword'] ?? '');
		$serverName = trim((string)($elkon['serverName'] ?? ''));

		if($host === '' && $serverName === ''){
			throw new RuntimeException('Elkon host/serverName is empty for site '.$siteId.'.');
		}
		if($database === ''){
			throw new RuntimeException('Elkon databaseName is empty for site '.$siteId.'.');
		}

		$server = $serverName !== '' ? $serverName : $host.':'.$port;
		$dsn = 'dblib:host='.$server.';dbname='.$database.';charset=UTF-8';
		$logLevel = (int)($elkon['logLevel'] ?? self::LOG_LEVEL_ERROR);

		$this->logAction(
			$siteId,
			'Соединение PDO_DBLIB с сервером '.$server,
			self::LOG_LEVEL_DEBUG,
			$logLevel,
		);

		try{
			$connection = new PDO(
				$dsn,
				$user,
				$password,
				array(
					PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
					PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
				),
			);
		}
		catch(PDOException $e){
			throw new RuntimeException(
				'Ошибка соединения PDO_DBLIB с сервером '.$server.': '.$e->getMessage(),
				0,
				$e,
			);
		}

		$this->elkonConnections[$siteId] = $connection;
		return $connection;
	}

	private function getProductions(
		int $siteId,
		array $elkon,
		int $productionId,
		string $sign,
	): array {
		if($sign !== '=' && $sign !== '>'){
			throw new InvalidArgumentException('Unsupported production comparison sign: '.$sign);
		}

		$sql = sprintf(
			"SELECT
				Uretim.Id AS id,
				Uretim.BasTarih AS dt_start,
				Recete.ReceteAdi AS concrete_type_descr,
				Uretim.AracPlaka AS vehicle_descr,
				Uretim.Olusturan AS user_descr
			FROM Uretim
			LEFT JOIN Recete ON Recete.Id = Uretim.ReceteId
			WHERE Uretim.Id %s %d
				AND Uretim.BasTarih IS NOT NULL
				AND Uretim.BasTarih <> ''%s
			ORDER BY Uretim.Id",
			$sign,
			$productionId,
			$sign === '=' ? '' : ' AND (Uretim.Statu = 0 OR Uretim.Statu = 2)',
		);

		$logLevel = (int)($elkon['logLevel'] ?? self::LOG_LEVEL_ERROR);
		$message = $sign === '='
			? 'Получение из Elkon производства по идентификатору '.$productionId
			: 'Получение из Elkon производств больше '.$productionId;
		$this->logAction($siteId, $message, self::LOG_LEVEL_DEBUG, $logLevel);

		$statement = $this->connectToElkon($siteId, $elkon)->query($sql);
		return $statement->fetchAll();
	}

	private function getClosedProductionMaterials(
		int $siteId,
		array $elkon,
		int $productionId,
	): ?array {
		$sql = sprintf(
			"SELECT
				UretimSonuc.BitisTarihi AS production_dt_end,
				UretimSonuc.Miktar AS concrete_quant,
				Recete.ReceteAdi AS concrete_descr,
				Uretim.Olusturan AS user_descr,
				Uretim.AracPlaka AS vehicle_descr,
				NULL AS correction_id,
				NULL AS correction_dt_end,

				'Инертные1' AS mat1_descr,
				UretimSonuc.Agrega1 AS mat1_quant,
				UretimSonuc.Agrega1Istenen AS mat1_quant_req,
				0 AS mat1_cement,
				NULL AS mat1_quant_corrected,

				'Инертные2' AS mat2_descr,
				UretimSonuc.Agrega2 AS mat2_quant,
				UretimSonuc.Agrega2Istenen AS mat2_quant_req,
				0 AS mat2_cement,
				NULL AS mat2_quant_corrected,

				'Инертные3' AS mat3_descr,
				UretimSonuc.Agrega3 AS mat3_quant,
				UretimSonuc.Agrega3Istenen AS mat3_quant_req,
				0 AS mat3_cement,
				NULL AS mat3_quant_corrected,

				'Инертные4' AS mat4_descr,
				UretimSonuc.Agrega4 AS mat4_quant,
				UretimSonuc.Agrega4Istenen AS mat4_quant_req,
				0 AS mat4_cement,
				NULL AS mat4_quant_corrected,

				'Инертные5' AS mat5_descr,
				UretimSonuc.Agrega5 AS mat5_quant,
				UretimSonuc.Agrega5Istenen AS mat5_quant_req,
				0 AS mat5_cement,
				NULL AS mat5_quant_corrected,

				'Инертные6' AS mat6_descr,
				UretimSonuc.Agrega6 AS mat6_quant,
				UretimSonuc.Agrega6Istenen AS mat6_quant_req,
				0 AS mat6_cement,
				0 AS mat6_quant_corrected,

				'Хим. добавки1' AS mat7_descr,
				UretimSonuc.Katki1 AS mat7_quant,
				UretimSonuc.Katki1Istenen AS mat7_quant_req,
				0 AS mat7_cement,
				NULL AS mat7_quant_corrected,

				'Хим. добавки2' AS mat8_descr,
				UretimSonuc.Katki2 AS mat8_quant,
				UretimSonuc.Katki2Istenen AS mat8_quant_req,
				0 AS mat8_cement,
				NULL AS mat8_quant_corrected,

				'Хим. добавки3' AS mat9_descr,
				UretimSonuc.Katki3 AS mat9_quant,
				UretimSonuc.Katki3Istenen AS mat9_quant_req,
				0 AS mat9_cement,
				NULL AS mat9_quant_corrected,

				'Хим. добавки4' AS mat10_descr,
				UretimSonuc.Katki4 AS mat10_quant,
				UretimSonuc.Katki4Istenen AS mat10_quant_req,
				0 AS mat10_cement,
				NULL AS mat10_quant_corrected,

				'Вода1' AS mat11_descr,
				UretimSonuc.Su1 AS mat11_quant,
				UretimSonuc.Su1Istenen AS mat11_quant_req,
				0 AS mat11_cement,
				NULL AS mat11_quant_corrected,

				'Вода2' AS mat12_descr,
				UretimSonuc.Su2 AS mat12_quant,
				UretimSonuc.Su2Istenen AS mat12_quant_req,
				0 AS mat12_cement,
				NULL AS mat12_quant_corrected,

				'Цемент1' AS mat13_descr,
				UretimSonuc.Cimento1 AS mat13_quant,
				UretimSonuc.Cimento1Istenen AS mat13_quant_req,
				1 AS mat13_cement,
				NULL AS mat13_quant_corrected,

				'Цемент2' AS mat14_descr,
				UretimSonuc.Cimento2 AS mat14_quant,
				UretimSonuc.Cimento2Istenen AS mat14_quant_req,
				1 AS mat14_cement,
				NULL AS mat14_quant_corrected,

				'Цемент3' AS mat15_descr,
				UretimSonuc.Cimento3 AS mat15_quant,
				UretimSonuc.Cimento3Istenen AS mat15_quant_req,
				1 AS mat15_cement,
				NULL AS mat15_quant_corrected,

				'Цемент4' AS mat16_descr,
				UretimSonuc.Cimento4 AS mat16_quant,
				UretimSonuc.Cimento4Istenen AS mat16_quant_req,
				1 AS mat16_cement,
				NULL AS mat16_quant_corrected
			FROM Uretim
			LEFT JOIN UretimSonuc ON UretimSonuc.UretimId = Uretim.Id
			LEFT JOIN Recete ON Recete.Id = Uretim.ReceteId
			WHERE Uretim.Id = %d
				AND UretimSonuc.BitisTarihi IS NOT NULL",
			$productionId,
		);

		$logLevel = (int)($elkon['logLevel'] ?? self::LOG_LEVEL_ERROR);
		$this->logAction(
			$siteId,
			'Получение из Elkon списанных материалов по закрытому производству '.$productionId,
			self::LOG_LEVEL_DEBUG,
			$logLevel,
		);

		$statement = $this->connectToElkon($siteId, $elkon)->query($sql);
		$row = $statement->fetch();
		return $row === false ? null : $row;
	}

	private function insertProductions(
		int $siteId,
		array $productions,
		int $logLevel,
		bool $updateLastProduction,
	): void {
		if($productions === array()){
			return;
		}

		foreach(array_chunk($productions, $this->batchSize) as $batch){
			$this->lock->heartbeat();
			$preparedRows = array();
			$maxProductionId = 0;

			foreach($batch as $production){
				$productionId = (int)$production['id'];
				echo 'Working on production ID: '.$productionId.PHP_EOL;

				$concreteTypeDescr = $this->nullableString($production['concrete_type_descr'] ?? null);
				$preparedRows[] = array(
					'production_id' => $productionId,
					'production_dt_start' => $this->normalizeDateTime($production['dt_start'] ?? null),
					'production_user' => $this->nullableString($production['user_descr'] ?? null),
					'production_vehicle_descr' => $this->nullableString($production['vehicle_descr'] ?? null),
					'production_site_id' => $siteId,
					'concrete_type_id' => $this->getOrCreateConcreteTypeId($concreteTypeDescr),
					'production_concrete_type_descr' => $concreteTypeDescr,
				);
				$maxProductionId = max($maxProductionId, $productionId);
			}

			$this->logAction(
				$siteId,
				'Вставка '.count($preparedRows).' новых производств Elkon; max ID '.$maxProductionId,
				self::LOG_LEVEL_DEBUG,
				$logLevel,
			);

			$this->pg->beginTransaction();
			try{
				$delete = $this->pg->prepare(
					'DELETE FROM productions
					WHERE production_site_id = :production_site_id
						AND production_id = :production_id',
				);
				$insert = $this->pg->prepare(
					'INSERT INTO productions (
						production_id,
						production_dt_start,
						production_user,
						production_vehicle_descr,
						production_site_id,
						concrete_type_id,
						production_concrete_type_descr
					) VALUES (
						:production_id,
						:production_dt_start,
						:production_user,
						:production_vehicle_descr,
						:production_site_id,
						:concrete_type_id,
						:production_concrete_type_descr
					)',
				);

				foreach($preparedRows as $row){
					$delete->execute(array(
						'production_site_id' => $siteId,
						'production_id' => $row['production_id'],
					));
					$insert->execute($row);
				}

				if($updateLastProduction){
					$update = $this->pg->prepare(
						'UPDATE production_sites
						SET last_elkon_production_id = :last_production_id
						WHERE id = :site_id',
					);
					$update->execute(array(
						'last_production_id' => $maxProductionId,
						'site_id' => $siteId,
					));
				}

				$this->pg->commit();
			}
			catch(Throwable $e){
				if($this->pg->inTransaction()){
					$this->pg->rollBack();
				}
				throw $e;
			}
		}
	}

	private function closeProduction(
		array $site,
		array $elkon,
		int $productionId,
		array $materialData,
	): void {
		$siteId = (int)$site['id'];
		$logLevel = (int)($elkon['logLevel'] ?? self::LOG_LEVEL_ERROR);
		$productionEnd = $this->normalizeDateTime($materialData['production_dt_end'] ?? null);
		$context = $this->getProductionContext($siteId, $productionId);

		if($context === null){
			$this->logAction(
				$siteId,
				'Нет в таблице productions производства с ID Elkon '.$productionId,
				self::LOG_LEVEL_DEBUG,
				$logLevel,
			);
			return;
		}

		$vehicleId = $this->nullableInt($context['vehicle_id'] ?? null);
		$vehicleScheduleStateId = $this->nullableInt($context['vehicle_schedule_state_id'] ?? null);
		$concreteTypeId = $this->nullableInt($context['concrete_type_id'] ?? null);

		if($vehicleId === null && $vehicleScheduleStateId === null && $concreteTypeId === null){
			$this->logAction(
				$siteId,
				'Производство '.$productionId.' не связано с ТС, состоянием или маркой бетона',
				self::LOG_LEVEL_DEBUG,
				$logLevel,
			);
			return;
		}

		$operatorUserId = $this->nullableInt($context['operator_user_id'] ?? null);
		if($operatorUserId === null || $operatorUserId === 0){
			$operatorUserId = $this->defaultOperatorUserId;
		}

		$concreteDescr = $this->nullableString($materialData['concrete_descr'] ?? null);
		$vehicleDescr = $this->nullableString($materialData['vehicle_descr'] ?? null);
		$concreteQuant = $this->asFloat($materialData['concrete_quant'] ?? null);
		$rows = array();

		for($index = 1; $index <= 16; $index++){
			$prefix = 'mat'.$index;
			$actualQuant = $this->asFloat($materialData[$prefix.'_quant'] ?? null);
			$requiredQuant = $this->asFloat($materialData[$prefix.'_quant_req'] ?? null);
			$correctedQuant = $this->asFloat($materialData[$prefix.'_quant_corrected'] ?? null);

			if($actualQuant == 0.0 && $requiredQuant == 0.0 && $correctedQuant == 0.0){
				continue;
			}

			$materialDescr = (string)($materialData[$prefix.'_descr'] ?? '');
			$isCement = (int)($materialData[$prefix.'_cement'] ?? 0) === 1;
			$siloId = $isCement
				? $this->getSiloId($siteId, $materialDescr)
				: null;
			$materialId = $this->getOrCreateMaterialId(
				$siteId,
				$materialDescr,
				$productionEnd,
			);

			$rows[] = array(
				'production_site_id' => $siteId,
				'upload_user_id' => $operatorUserId,
				'date_time' => $productionEnd,
				'concrete_type_production_descr' => $concreteDescr,
				'concrete_type_id' => $concreteTypeId,
				'raw_material_production_descr' => $materialDescr,
				'raw_material_id' => $materialId,
				'vehicle_production_descr' => $vehicleDescr,
				'vehicle_id' => $vehicleId,
				'vehicle_schedule_state_id' => $vehicleScheduleStateId,
				'concrete_quant' => $concreteQuant,
				'material_quant' => $actualQuant / 1000,
				'material_quant_req' => $requiredQuant / 1000,
				'cement_silo_id' => $siloId,
				'production_id' => $productionId,
			);
		}

		if($rows === array()){
			return;
		}

		$this->logAction(
			$siteId,
			'Списание материалов по закрытому производству '.$productionId,
			self::LOG_LEVEL_DEBUG,
			$logLevel,
		);

		$this->pg->beginTransaction();
		try{
			$delete = $this->pg->prepare(
				'DELETE FROM material_fact_consumptions
				WHERE production_site_id = :site_id
					AND production_id = :production_id',
			);
			$delete->execute(array(
				'site_id' => $siteId,
				'production_id' => $productionId,
			));

			$insert = $this->pg->prepare(
				'INSERT INTO material_fact_consumptions (
					production_site_id,
					upload_date_time,
					upload_user_id,
					date_time,
					concrete_type_production_descr,
					concrete_type_id,
					raw_material_production_descr,
					raw_material_id,
					vehicle_production_descr,
					vehicle_id,
					vehicle_schedule_state_id,
					concrete_quant,
					material_quant,
					material_quant_req,
					cement_silo_id,
					production_id
				) VALUES (
					:production_site_id,
					now(),
					:upload_user_id,
					:date_time,
					:concrete_type_production_descr,
					:concrete_type_id,
					:raw_material_production_descr,
					:raw_material_id,
					:vehicle_production_descr,
					:vehicle_id,
					:vehicle_schedule_state_id,
					:concrete_quant,
					:material_quant,
					:material_quant_req,
					:cement_silo_id,
					:production_id
				)',
			);

			foreach($rows as $row){
				$insert->execute($row);
			}

			$update = $this->pg->prepare(
				'UPDATE productions
				SET production_dt_end = :production_dt_end,
					dt_end_set = now(),
					concrete_quant = :concrete_quant
				WHERE production_id = :production_id
					AND production_site_id = :site_id',
			);
			$update->execute(array(
				'production_dt_end' => $productionEnd,
				'concrete_quant' => $concreteQuant,
				'production_id' => $productionId,
				'site_id' => $siteId,
			));

			$this->pg->commit();
		}
		catch(Throwable $e){
			if($this->pg->inTransaction()){
				$this->pg->rollBack();
			}
			throw $e;
		}
	}

	private function getProductionContext(int $siteId, int $productionId): ?array
	{
		$statement = $this->pg->prepare(
			'SELECT
				p.vehicle_id,
				p.vehicle_schedule_state_id,
				p.concrete_type_id,
				p.shipment_id,
				(
					SELECT user_map.user_id
					FROM user_map_to_production AS user_map
					WHERE user_map.production_site_id = p.production_site_id
						AND user_map.production_descr = p.production_user
					LIMIT 1
				) AS operator_user_id
			FROM productions AS p
			WHERE p.production_site_id = :site_id
				AND p.production_id = :production_id',
		);
		$statement->execute(array(
			'site_id' => $siteId,
			'production_id' => $productionId,
		));

		$row = $statement->fetch();
		return $row === false ? null : $row;
	}

	private function getOrCreateConcreteTypeId(?string $description): ?int
	{
		if($description === null || $description === ''){
			return null;
		}

		if(array_key_exists($description, $this->concreteTypeIds)){
			return $this->concreteTypeIds[$description];
		}

		$statement = $this->pg->prepare(
			'SELECT material_fact_consumptions_add_concrete_type(:description) AS concrete_type_id',
		);
		$statement->execute(array('description' => $description));
		$value = $statement->fetchColumn();
		$id = $this->nullableInt($value);
		$this->concreteTypeIds[$description] = $id;
		return $id;
	}

	private function getSiloId(int $siteId, string $description): ?int
	{
		$key = $siteId.'|'.$description;
		if(array_key_exists($key, $this->siloIds)){
			return $this->siloIds[$key];
		}

		$statement = $this->pg->prepare(
			'SELECT id
			FROM cement_silos
			WHERE production_site_id = :site_id
				AND production_descr = :description
			LIMIT 1',
		);
		$statement->execute(array(
			'site_id' => $siteId,
			'description' => $description,
		));
		$id = $this->nullableInt($statement->fetchColumn());
		$this->siloIds[$key] = $id;
		return $id;
	}

	private function getOrCreateMaterialId(
		int $siteId,
		string $description,
		string $productionEnd,
	): ?int {
		$key = $siteId.'|'.$description.'|'.$productionEnd;
		if(array_key_exists($key, $this->materialIds)){
			return $this->materialIds[$key];
		}

		$statement = $this->pg->prepare(
			'SELECT material_fact_consumptions_add_material(
				:site_id,
				:description,
				:production_end
			) AS material_id',
		);
		$statement->execute(array(
			'site_id' => $siteId,
			'description' => $description,
			'production_end' => $productionEnd,
		));
		$id = $this->nullableInt($statement->fetchColumn());
		$this->materialIds[$key] = $id;
		return $id;
	}

	private function logAction(
		int $siteId,
		string $message,
		int $messageLevel,
		int $serverLevel,
	): void {
		if($serverLevel < $messageLevel){
			return;
		}

		try{
			$statement = $this->pg->prepare(
				'SELECT elkon_log_upsert(
					(NULL, now(), :site_id, :message, :message_level)::elkon_log
				)',
			);
			$statement->execute(array(
				'site_id' => $siteId,
				'message' => $message,
				'message_level' => $messageLevel,
			));
		}
		catch(Throwable $e){
			fwrite(
				STDERR,
				'Unable to write Elkon log: '.$e->getMessage().'; original message: '.$message.PHP_EOL,
			);
		}
	}

	private function configurePostgresSession(): void
	{
		$this->pg->exec("SET work_mem = '16MB'");
		$this->pg->exec('SET cpu_tuple_cost = 0.1');
		$this->pg->exec('SET cpu_index_tuple_cost = 0.1');
		$this->pg->exec("SET statement_timeout = '10min'");
	}

	private function decodeElkonConnection(mixed $value, bool $required): array
	{
		if(is_array($value)){
			return $value;
		}

		if(!is_string($value) || trim($value) === ''){
			if($required){
				throw new RuntimeException('Elkon connection JSON is empty.');
			}
			return array();
		}

		try{
			$decoded = json_decode($value, true, 512, JSON_THROW_ON_ERROR);
		}
		catch(JsonException $e){
			if($required){
				throw new RuntimeException('Invalid Elkon connection JSON: '.$e->getMessage(), 0, $e);
			}
			return array();
		}

		if(!is_array($decoded)){
			if($required){
				throw new RuntimeException('Elkon connection JSON must decode to an object.');
			}
			return array();
		}

		return $decoded;
	}

	private function parsePostgresIntArray(mixed $value): array
	{
		if(is_array($value)){
			return array_values(array_filter(
				array_map('intval', $value),
				static fn(int $item): bool => $item > 0,
			));
		}

		if(!is_string($value)){
			return array();
		}

		$value = trim($value);
		if($value === '' || $value === '{}'){
			return array();
		}

		$value = trim($value, '{}');
		$result = array();
		foreach(str_getcsv($value) as $item){
			$item = trim($item, " \t\n\r\0\x0B\"");
			if($item !== '' && preg_match('/^-?\d+$/', $item)){
				$id = (int)$item;
				if($id > 0){
					$result[] = $id;
				}
			}
		}

		return array_values(array_unique($result));
	}

	private function normalizeDateTime(mixed $value): string
	{
		if($value instanceof DateTimeInterface){
			return $value->format('Y-m-d H:i:s');
		}

		if(!is_string($value) || trim($value) === ''){
			throw new RuntimeException('Elkon returned an empty datetime value.');
		}

		try{
			return (new DateTimeImmutable($value))->format('Y-m-d H:i:s');
		}
		catch(Exception $e){
			throw new RuntimeException('Unable to parse Elkon datetime: '.$value, 0, $e);
		}
	}

	private function nullableString(mixed $value): ?string
	{
		if($value === null){
			return null;
		}

		$value = trim((string)$value);
		return $value === '' ? null : $value;
	}

	private function nullableInt(mixed $value): ?int
	{
		if($value === null || $value === '' || $value === false){
			return null;
		}

		return (int)$value;
	}

	private function asFloat(mixed $value): float
	{
		if($value === null || $value === ''){
			return 0.0;
		}

		return (float)$value;
	}

	private function sleepBetweenRequests(): void
	{
		if($this->sleepMicroseconds > 0){
			usleep($this->sleepMicroseconds);
		}
	}
}

function loadConfig(): array
{
	$configFile = getenv('ELKON_IMPORT_CONFIG');
	if($configFile === false || trim($configFile) === ''){
		$configFile = __DIR__.'/elkon_import.config.php';
	}

	if(!is_file($configFile)){
		throw new RuntimeException(
			'Configuration file not found: '.$configFile
			.'. Copy elkon_import.config.php.example and configure it.',
		);
	}

	$config = require $configFile;
	if(!is_array($config)){
		throw new RuntimeException('Configuration file must return an array.');
	}

	return $config;
}

try{
	$config = loadConfig();
	$lock = new ProcessLock(
		(string)($config['signal_file'] ?? '/tmp/elkon_upload.syg'),
		max(1, (int)($config['stale_after_seconds'] ?? 300)),
		isset($config['warn_script']) ? (string)$config['warn_script'] : null,
	);

	if(!$lock->acquire()){
		exit(0);
	}

	$importer = new ElkonImporter($config, $lock);
	$importer->run();
	$lock->release();
	exit(0);
}
catch(Throwable $e){
	fwrite(STDERR, '['.date('c').'] '.$e->getMessage().PHP_EOL);
	exit(1);
}
