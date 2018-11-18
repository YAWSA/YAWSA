<?php
/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
namespace app\modules\comment;

use app\components\TController;
use app\components\TModule;

/**
 * comment module definition class
 */
class Module extends TModule
{

    const NAME = 'comment';

    public $controllerNamespace = 'app\modules\comment\controllers';

    public $defaultRoute = 'comment';

    public static function subNav()
    {
        return TController::addMenu(\Yii::t('app', 'Comments'), '#', 'key ', Module::isAdmin(), [            // TController::addMenu(\Yii::t('app', 'Home'), '//comment', 'lock', Module::isAdmin()),
        ]);
    }

    public static function dbFile()
    {
        return __DIR__ . '/db/install.sql';
    }
}
