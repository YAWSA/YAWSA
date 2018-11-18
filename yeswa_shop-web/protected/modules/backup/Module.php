<?php
namespace app\modules\backup;

use app\components\TModule;

class Module extends TModule
{

    public $controllerNamespace = 'app\modules\backup\controllers';

    public $path;

    public $fileList;

    public function init()
    {
        parent::init();
        if (\Yii::$app instanceof \yii\console\Application) {
            $this->controllerNamespace = 'app\modules\backup\commands';
        }
        // custom initialization code goes here
    }

    public function getFileList()
    {
        return $this->fileList;
    }
}
