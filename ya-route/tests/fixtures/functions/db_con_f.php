<?php
require_once dirname(__DIR__).'/MockDb.php';
function db_con() { return new RouteFixtureDb(); }
