<?php
$fp = fopen(__DIR__ . '/timer.lock', 'w+');
if (! flock($fp, LOCK_EX | LOCK_NB)) {
	exit();
}


require __DIR__ . '/common.php';

$config = require (DB_CONFIG_PATH . '/console.php');

require (VENDOR_PATH . 'autoload.php');
require (VENDOR_PATH . 'yiisoft/yii2/Yii.php');

$application = new yii\console\Application ( $config );
function dlog($str) {
	echo $str . PHP_EOL;
}
function cmd($application, $cmd) {
	try {
		ob_start ();
		$application->runAction ( $cmd );
		dlog ( ob_get_clean () );
	} catch ( \Exception $ex ) {
		echo $ex->getMessage ();
	}
	echo htmlentities ( ob_get_clean (), null, Yii::$app->charset );
}

try {
	cmd ( $application, 'timer/email' );
} catch ( \Exception $ex ) {
	echo $ex->getMessage ();
}


try {
	cmd ( $application, 'timer/backup' );
} catch ( \Exception $ex ) {
	echo $ex->getMessage ();
}
flock ( $fp, LOCK_UN );

fclose ( $fp );