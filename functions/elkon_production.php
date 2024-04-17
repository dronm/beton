<?php
/**
 * Модуль создания заявок в ELKON
 *
 * For php5.6 only!
 * Uses mssql_query to connect to MSSQL database
 *
 * concrete_type_map_to_production Не используется для сопоставления марок!!!
 * используется название из Beton!!!
 * чтобы использовать concrete_type_map_to_production надо добавлять поле production_site_id для разделения по заводам
			,(SELECT
				ct_tp.production_descr
			FROM concrete_type_map_to_production AS ct_tp
			WHERE ct_tp.concrete_type_id = o.concrete_type_id
			LIMIT 1
			) AS concrete_descr
 
 */
 
/**
 * shipment_id ID назначения в Бетоне
 */
function elkon_production_insert(&$dbLinkMaster, $shipment_id){
	//try{
		$ar = $dbLinkMaster->query_first(sprintf(
			"SELECT
				st.elkon_connection AS elkon_connection
				,st.elkon_params->>'firma_id' AS elkon_firma_id
				,(st.elkon_params->>'newVersion')::bool AS elkon_new_version
				
				,(SELECT
					u.production_descr
				FROM user_map_to_production AS u
				WHERE u.production_site_id = sh.production_site_id
					AND (
						SELECT lg.date_time_out IS NULL
						FROM logins AS lg
						WHERE lg.user_id = u.user_id
						ORDER BY lg.date_time_in DESC
						LIMIT 1
					)
				LIMIT 1
				) AS elkon_user_name
				
				,v.plate AS vehicle_plate_full
				,regexp_replace(v.plate, '\D','','g') AS vehicle_plate
				,v.load_capacity AS vehicle_load_capacity
				
				,dr.name AS driver_name_full
				,SUBSTRING(dr.name for POSITION(' ' in dr.name)-1) AS driver_name
				
				,ct.name AS concrete_descr
				
				,sh.date_time
				,sh.quant
				
				,sh.production_site_id
				
			FROM shipments AS sh
			LEFT JOIN production_sites AS st ON st.id = sh.production_site_id
			LEFT JOIN vehicle_schedules AS v_sch ON v_sch.id = sh.vehicle_schedule_id
			LEFT JOIN vehicles AS v ON v.id = v_sch.vehicle_id
			LEFT JOIN drivers AS dr ON dr.id = v_sch.driver_id
			LEFT JOIN orders AS o ON o.id = sh.order_id
			LEFT JOIN concrete_types AS ct ON ct.id = o.concrete_type_id
			WHERE sh.id = %d
				AND st.production_plant_type = 'elkon'
				AND st.elkon_connection IS NOT NULL
				AND st.active
				AND st.elkon_params IS NOT NULL
				AND st.elkon_params->>'firma_id' IS NOT NULL
				AND st.elkon_connection IS NOT NULL"
			,$shipment_id
		));
		
		if(!is_array($ar) || !count($ar)){
			return;
		}
		
		$elkon_connection = json_decode($ar['elkon_connection']);
		$server_name = sprintf('%s:%d',$elkon_connection->host, $elkon_connection->port);
		
		if($ar['elkon_new_version'] == 't'){
			$ms_q_t = "INSERT INTO Uretim
				(ReceteId,
				FirmaId, FirmaAdi,
				SantiyeId, SantiyeAdi,
				AracId, AracPlaka, AracKapasite,
				SurucuId, SurucuAdi,
				Miktar,
				Statu, Statu_SentToProduction,
				IlaveSu1, IlaveSu2,
				Olusturan, OlusturamaTarihi,
				TestKubu, Musteri,
				uretilecek_miktar, iade_beton)
				VALUES (
					(SELECT TOP 1 Recete.Id FROM Recete WHERE Recete.ReceteAdi = '%s'),
					%d,(SELECT TOP 1 Firma.FirmaAdi FROM Firma WHERE Firma.Id = %d),
					(SELECT TOP 1 Santiye.Id FROM Santiye WHERE Santiye.FirmaId = %d),(SELECT TOP 1 Santiye.SantiyeAdi FROM Santiye WHERE Santiye.FirmaId = %d),
					%d, '%s', %f,
					%d, '%s',
					%f,
					0,0,
					0,0,
					'%s','%s',
					0,1,
					%f,0
				)";
		}else{
			//4 last fields are missing
			$ms_q_t = "INSERT INTO Uretim
				(ReceteId,
				FirmaId, FirmaAdi,
				SantiyeId, SantiyeAdi,
				AracId, AracPlaka, AracKapasite,
				SurucuId, SurucuAdi,
				Miktar,
				Statu, Statu_SentToProduction,
				IlaveSu1, IlaveSu2,
				Olusturan, OlusturamaTarihi)
				VALUES (
					(SELECT TOP 1 Recete.Id FROM Recete WHERE Recete.ReceteAdi = '%s'),
					%d,(SELECT TOP 1 Firma.FirmaAdi FROM Firma WHERE Firma.Id = %d),
					(SELECT TOP 1 Santiye.Id FROM Santiye WHERE Santiye.FirmaId = %d),(SELECT TOP 1 Santiye.SantiyeAdi FROM Santiye WHERE Santiye.FirmaId = %d),
					%d, '%s', %f,
					%d, '%s',
					%f,
					0,0,
					0,0,
					'%s','%s'
				)";
		}		
		//syslog(LOG_ERR, 'Test');
		if(function_exists('mssql_select_db')){
			$ms_conn = mssql_connect($server_name, $elkon_connection->userName, $elkon_connection->userPassword);
			if($ms_conn===FALSE){
				throw new Exception('Ошибка соединения с сервером '.$server_name);
			}
			
			mssql_select_db($elkon_connection->databaseName, $ms_conn);
			
			//1) Найдем водителя в ELKON
			$surucu_adi = $ar['driver_name'];
			try{
				$res = mssql_query(
					sprintf(
						"SELECT Id,Aktif FROM Surucu WHERE SurucuAdi = '%s'"
						,$surucu_adi
					)
					,$ms_conn
				);
				
				$row = mssql_fetch_assoc($res);
				if(is_array($row) && count($row) && isset($row['Id'])){
					$surucu_id = $row['Id'];				
				}else{
//throw new Exception('no driver in ELKON - add');
					//no driver in ELKON - add
					$res = mssql_query(
						sprintf(
							"INSERT INTO Surucu
							(SurucuAdi,Aktif,Olusturan,OlusturamaTarihi)
							OUTPUT Inserted.Id
							VALUES('%s',1,'%s','%s')"
						,$surucu_adi
						,$ar['elkon_user_name']
						,$ar['date_time']
						)
					);
					$row = mssql_fetch_assoc($res);
					$surucu_id = $row['Id'];
				}
			}
			finally{
				mssql_free_result($res);
			}
			//******************************************
			
			//2) Найдем авто в ELKON
			$arac_kapasite = $ar['vehicle_load_capacity'];
			$arac_plaka = $ar['vehicle_plate'];
			try{
				$res = mssql_query(
					sprintf(
						"SELECT
							COALESCE(
								(SELECT TOP 1 Id FROM Arac WHERE Plaka = '%s' AND FirmaId=%d)
								,(SELECT TOP 1 Id FROM Arac WHERE Plaka = '%s' AND FirmaId=%d)
							) AS Id
							,COALESCE(
								(SELECT TOP 1 Plaka FROM Arac WHERE Plaka = '%s' AND FirmaId=%d)
								,(SELECT TOP 1 Plaka FROM Arac WHERE Plaka = '%s' AND FirmaId=%d)
							) AS Plaka"
						,$ar['vehicle_plate_full']
						,$ar['elkon_firma_id']
						,$ar['vehicle_plate']
						,$ar['elkon_firma_id']
						,$ar['vehicle_plate_full']
						,$ar['elkon_firma_id']
						,$ar['vehicle_plate']
						,$ar['elkon_firma_id']						
					)
					,$ms_conn
				);
				$row = mssql_fetch_assoc($res);
				if(is_array($row) && count($row) && isset($row['Id'])){
					$arac_id = $row['Id'];
					$arac_plaka = $row['Plaka'];
				}else{
//throw new Exception('no vehicle in ELKON - add');				
					//no vehicle in ELKON - add
					$res = mssql_query(
						sprintf(
							"INSERT INTO Arac
							(Plaka,Kapasite,FirmaId,Aktif,Olusturan,OlusturamaTarihi)
							OUTPUT Inserted.Id
							VALUES('%s',%f,%d,true,'%s','%s')"						
							,$ar['vehicle_plate_full']
							,$arac_kapasite
							,$ar['elkon_firma_id']
							,$ar['elkon_user_name']
							,$ar['date_time']
						)
					);
					$row = mssql_fetch_assoc($res);
					$arac_id = $row['Id'];
					$arac_plaka = $ar['vehicle_plate_full'];
				}
			}
			finally{
				mssql_free_result($res);
			}
			//*******************************************
			
			$ms_dt = substr(str_replace(' ','T',$ar['date_time']) ,0 ,19);
			//3) Добавление производства
			if($ar['elkon_new_version'] == 't'){
				$ms_q = sprintf($ms_q_t		
					,$ar['concrete_descr']
					,$ar['elkon_firma_id'], $ar['elkon_firma_id']
					,$ar['elkon_firma_id'], $ar['elkon_firma_id']
					,$arac_id, $arac_plaka, $arac_kapasite
					,$surucu_id, $surucu_adi
					,$ar['quant']
					,$ar['elkon_user_name'],  $ms_dt
					,$ar['quant']
				);
			}else{
				$ms_q = sprintf($ms_q_t		
					,$ar['concrete_descr']
					,$ar['elkon_firma_id'], $ar['elkon_firma_id']
					,$ar['elkon_firma_id'], $ar['elkon_firma_id']
					,$arac_id, $arac_plaka, $arac_kapasite
					,$surucu_id, $surucu_adi
					,$ar['quant']
					,$ar['elkon_user_name'],  $ms_dt
				);
			}
			//file_put_contents(OUTPUT_PATH.'ms.sql',$ms_q);
			//echo 'Inserting production...';
			mssql_query($ms_q, $ms_conn);
			
		}else{
			throw new Exception('MSSQL driver not installed!');
		}
		
	/*}catch(Exception $e){
		if(isset($ar) && is_array($ar) && isset($ar['production_site_id'])){
			 $dbLinkMaster->query(sprintf(
			 	"SELECT elkon_log_upsert((NULL,now(),%d,%s,%d)::elkon_log)",
			 	$ar['production_site_id'],
			 	$e->getMessage(),
			 	0
			 ));
		}else{
			throw $e;
		}
	}*/
}

?>
