<?php
class RouteFixtureDb
{
	public function state(): array
	{
		return json_decode(file_get_contents(getenv('ROUTE_FIXTURE_STATE')), true);
	}
	private function save(array $state): void
	{
		file_put_contents(getenv('ROUTE_FIXTURE_STATE'), json_encode($state));
	}
	public function escape_string($value): string
	{
		return str_replace("'", "''", (string) $value);
	}
	private function record(string $sql): array
	{
		$state = $this->state();
		$state['queries'][] = $sql;
		$this->save($state);
		return $state;
	}
	public function query_first(string $sql)
	{
		$state = $this->record($sql);
		if (strpos($sql, 'FROM logins') !== false) {
			preg_match("/l.pub_key = '([0-9]+)'/", $sql, $match);
			return $state['logins'][$match[1] ?? ''] ?? null;
		}
		if (strpos($sql, 'FROM shipments') !== false) {
			preg_match('/WHERE sh.id = ([0-9]+)/', $sql, $match);
			return $state['shipments'][$match[1] ?? ''] ?? null;
		}
		if (strpos($sql, 'FROM route_rests') !== false) {
			return array_key_exists('route_rest', $state) ? array('route_rest' => $state['route_rest']) : null;
		}
		if (strpos($sql, 'ST_Covers') !== false) {
			return array('inside' => !empty($state['inside_zone']) ? 't' : 'f');
		}
		throw new RuntimeException('Unexpected fixture query: '.$sql);
	}
	public function query(string $sql)
	{
		$state = $this->record($sql);
		if (!empty($state['fail_sql']) && strpos($sql, $state['fail_sql']) !== false) { return false; }
		if (strpos($sql, 'INSERT INTO logins') !== false) {
			preg_match("/VALUES \(now\(\), '[^']*', '([^']*)', '([0-9]+)'/", $sql, $match);
			if (!$match) { throw new RuntimeException('Cannot parse fixture login insert'); }
			$state['logins'][$match[2]] = array('session_id' => $match[1], 'active' => 't', 'expired' => 'f');
			$this->save($state);
		}
		return true;
	}
}
