<?php

/**
 * This is the model class for table "tbl_sale".
 *
 * @property integer $id
 * @property integer $model_id
 * @property string $model_type
 * @property string $title
 * @property string $discount
 * @property string $min_limit
 * @property integer $type_id
 * @property string $comment
 * @property integer $state_id
 * @property string $created_on
 * @property integer $created_by_id
 
 * === Related data ===
 * @property User $createdBy
 */
namespace app\models;

use Yii;
use app\models\User;
use yii\helpers\ArrayHelper;


class Sale extends \app\components\TActiveRecord
{

    public $brand_id;
    
    const BUY_AND_GET = 2;

    const PERCENT_DISCOUNT = 1;

    public function __toString()
    {
        return (string) $this->title;
    }

    public static function getModelOptions()
    {
        return [
            "TYPE1",
            "TYPE2",
            "TYPE3"
        ];
        // return ArrayHelper::Map ( Model::findActive ()->all (), 'id', 'title' );
    }

    public static function getModelTypeOptions()
    {
        $array = [
            Category::className() => 'Category',
            Brand::className() => 'Brand'
        ];
        return $array;
    }

    public static function getModelValueOptions($modelClass)
    {
        if ($modelClass == Category::className()) {
            return ArrayHelper::Map(Category::findActive()->all(), 'id', 'title');
        } elseif ($modelClass == Brand::className()) {
            return ArrayHelper::Map(Brand::findActive()->all(), 'id', 'title');
        } else {
            return [];
        }
    }

    public function getModel()
    {
        $list = self::getModelOptions();
        return isset($list[$this->model_id]) ? $list[$this->model_id] : 'Not Defined';
    }

    public static function getTypeOptions()
    {
        return [
            self::BUY_AND_GET => "Buy & Get",
            self::PERCENT_DISCOUNT => " % Discount"
        ];
        //return ArrayHelper::Map ( Type::findActive ()->all (), 'id', 'title' );
    }

    public function getType()
    {
        $list = self::getTypeOptions();
        return isset($list[$this->type_id]) ? $list[$this->type_id] : 'Not Defined';
    }

    const STATE_INACTIVE = 0;

    const STATE_ACTIVE = 1;

    const STATE_DELETED = 2;

    public static function getStateOptions()
    {
        return [
            self::STATE_INACTIVE => "New",
            self::STATE_ACTIVE => "Active",
            self::STATE_DELETED => "Archived"
        ];
    }

    public function getState()
    {
        $list = self::getStateOptions();
        return isset($list[$this->state_id]) ? $list[$this->state_id] : 'Not Defined';
    }

    public function getStateBadge()
    {
        $list = [
            self::STATE_INACTIVE => "primary",
            self::STATE_ACTIVE => "success",
            self::STATE_DELETED => "danger"
        ];
        return isset($list[$this->state_id]) ? \yii\helpers\Html::tag('span', $this->getState(), [
            'class' => 'label label-' . $list[$this->state_id]
        ]) : 'Not Defined';
    }

    public function beforeValidate()
    {
        if ($this->isNewRecord) {
            if (! isset($this->created_on))
                $this->created_on = date('Y-m-d H:i:s');
            if (! isset($this->created_by_id))
                $this->created_by_id = Yii::$app->user->id;
        } else {}
        return parent::beforeValidate();
    }

    /**
     *
     * @inheritdoc
     */
    public static function tableName()
    {
        return '{{%sale}}';
    }

    /**
     *
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [
                [
                    'model_id',
                    'model_type',
                    'title',
                    'discount'
                ],
                'required'
            ],
            [
                [
                    'model_id',
                    'type_id',
                    'state_id',
                    'created_by_id'
                ],
                'integer'
            ],
            [
                [
                    'comment'
                ],
                'string'
            ],
            [
                [
                    'created_on',
                    'image_file'
                ],
                'safe'
            ],
            [
                [
                    'model_type',
                    'title',
                    'min_limit'
                ],
                'string',
                'max' => 255
            ],
            [
                [
                    'discount'
                ],
                'integer',
                'max' => 100
            ],
            [
                [
                    'min_limit'
                ],
                'integer',
                'min' => 0
            ],
            [
                [
                    'created_by_id'
                ],
                'exist',
                'skipOnError' => true,
                'targetClass' => User::className(),
                'targetAttribute' => [
                    'created_by_id' => 'id'
                ]
            ],
            [
                [
                    'model_type',
                    'title',
                    'min_limit',
                    //'discount'
                ],
                'trim'
            ],
            [
                [
                    'type_id'
                ],
                'in',
                'range' => array_keys(self::getTypeOptions())
            ],
            [
                [
                    'state_id'
                ],
                'in',
                'range' => array_keys(self::getStateOptions())
            ]
        ];
    }

    /**
     *
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'id' => Yii::t('app', 'ID'),
            'model_id' => Yii::t('app', 'Model'),
            'model_type' => Yii::t('app', 'Model Type'),
            'title' => Yii::t('app', 'Title'),
            'discount' => Yii::t('app', 'Discount'),
            'min_limit' => Yii::t('app', 'Min Limit'),
            'type_id' => Yii::t('app', 'Type'),
            'comment' => Yii::t('app', 'Comment'),
            'state_id' => Yii::t('app', 'State'),
            'created_on' => Yii::t('app', 'Created On'),
            'created_by_id' => Yii::t('app', 'Created By'),
            'created_by_id' => Yii::t('app', 'Created By'),
            'image_file' => Yii::t('app', 'Image')
        ];
    }

    /**
     *
     * @return \yii\db\ActiveQuery
     */
    public function getCreatedBy()
    {
        return $this->hasOne(User::className(), [
            'id' => 'created_by_id'
        ]);
    }

    public static function getHasManyRelations()
    {
        $relations = [];
        return $relations;
    }

    public static function getHasOneRelations()
    {
        $relations = [];
        $relations['created_by_id'] = [
            'createdBy',
            'User',
            'id'
        ];
        return $relations;
    }

    public function beforeDelete()
    {
        return parent::beforeDelete();
    }

    public function asJson($with_relations = false)
    {
        $json = [];
        $json['id'] = $this->id;
        $json['model_id'] = $this->model_id;
        $json['model_type'] = $this->model_type;
        $json['product'] = $this->getProduct();
        $json['title'] = $this->title;
        $json['discount'] = $this->discount;
        $json['min_limit'] = $this->min_limit;
        $json['type_id'] = $this->type_id;
        $json['comment'] = $this->comment;
        $json['state_id'] = $this->state_id;
        $json['created_on'] = $this->created_on;
        $json['created_by_id'] = $this->created_by_id;
        if (! empty ( $this->image_file )) {
            
            $json ['image_file'] = \Yii::$app->urlManager->createAbsoluteUrl ( [
                'user/download',
                'profile_file' => $this->image_file
            ] );
        } else {
            $json ['image_file'] = \Yii::$app->urlManager->createAbsoluteUrl ( [
                '/themes/base/img/default.jpeg'
            ] );
        }
        if ($with_relations) {
            // createdBy
            $list = $this->createdBy;
            
            if (is_array($list)) {
                $relationData = [];
                foreach ($list as $item) {
                    $relationData[] = $item->asJson();
                }
                $json['createdBy'] = $relationData;
            } else {
                $json['CreatedBy'] = $list;
            }
        }
        return $json;
    }
    
    public static function getCategoryList()
    {
        $value = [];
        $lists = Category::find()->where([
            'state_id' => Category::STATE_ACTIVE
        ])->all();
        foreach ($lists as $list){
          $value[$list->id] = $list->title;  
        }
        return $value;
    }
    
    public function getproduct()
    {
        $data = [];
      
        if ($this->model_type == Product::className()){
            $model = Product::find()->where([
                'id' => $this->model_id
            ])->one();
            
            if (!empty($model)) {
              return $model->asJson(true);
            } 
        }
        
        return '';
    }
    
}
