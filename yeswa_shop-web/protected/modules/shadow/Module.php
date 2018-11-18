<?php
namespace app\modules\shadow;

use app\components\TController;
use app\components\TModule;

/**
 * shadow module definition class
 */
class Module extends TModule
{

    /**
     * @inheritdoc
     */
    public $controllerNamespace = 'app\modules\shadow\controllers';

    public $defaultRoute = 'session';

    public static function subNav()
    {
        return TController::addMenu(\Yii::t('app', 'Shadows'), '#', 'key ', Module::isAdmin(), [
            TController::addMenu(\Yii::t('app', 'Session'), '//session', 'lock', Module::isAdmin())
        ]);
    }

    public static function dbFile()
    {
        return __DIR__ . '/db/install.sql';
    }
}
