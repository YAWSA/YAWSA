<?php
namespace app\modules\seo;

use app\components\TModule;

/**
 * manager module definition class
 */
class Module extends TModule
{

    /**
     * @inheritdoc
     */
    public $controllerNamespace = 'app\modules\seo\controllers';

    public $defaultRoute = 'manager';

 
    public static function dbFile()
    {
        return __DIR__ . '/db/install.sql';
    }

}
