<?php
namespace app\components;

use yii\base\Component;
use yii\caching\Cache;
use app\models\Setting;
use yii\helpers\Json;
use yii\base\UnknownPropertyException;

class Settings extends Component
{

    protected $model;

    public $cache = 'cache';

    public $frontCache;

    private $_data = null;

    public $modelClass = 'app\models\Setting';

    public $isConfig = true;

    public function init()
    {
        parent::init();
        $this->model = new $this->modelClass();
        if (is_string($this->cache)) {
            $this->cache = \Yii::$app->get($this->cache, false);
        }
        if (is_string($this->frontCache)) {
            $this->frontCache = \Yii::$app->get($this->frontCache, false);
        }
        $this->createProperty();
    }

    public function __get($key)
    {
        if ($this->_data !== null) {
            if (array_key_exists($key, $this->_data)) {
                return $this->_data[$key];
            } else {
                throw new UnknownPropertyException("Getting unknown property: " . $this::className() . "::" . $key);
            }
        } else
            return false;
    }

    protected function createProperty()
    {
        $configrations = Setting::find()->all();
        $checkIsConfig = true;
        if ($configrations)
            foreach ($configrations as $config) {
                $setConfig = new \stdClass();
                $setConfig->value = (object) (Json::decode($config->value));
                
                $setConfig->id = $config->id;
                $setConfig->key = $config->key;
                $setConfig->title = $config->title;
                $setConfig->asArray = Json::decode($config->value, true);
                
                $keyValue = new \stdClass();
                if ($setConfig->asArray) {
                    foreach ($setConfig->asArray as $key => $val) {
                        $keyValue->{$key} = $val['value'];
                    }
                }
                
                $setConfig->config = $keyValue;
                $this->_data[$config->key] = $setConfig;
            }
    }
}
