<?php
class VehicleRoute
{
	public static function getRoute($vehicle, $db, &$distance)
	{
		$state = $db->state();
		if (!empty($state['route_error'])) { throw new RuntimeException('Private route service failure'); }
		$distance = $state['distance'] ?? null;
		return $state['initial_route'] ?? '';
	}
}
