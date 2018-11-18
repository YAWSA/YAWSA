<?php

/**
 * This is the model class for table "tbl_vendor_address".
 *
 * @property integer $id
 * @property string $location
 * @property string $city
 * @property string $area
 * @property string $block
 * @property string $street
 * @property string $house
 * @property string $apartment
 * @property string $office
 * @property integer $state_id
 * @property integer $type_id
 * @property integer $created_on
 * @property integer $updated_on
 * @property integer $created_by_id
 */
namespace app\models;

use Yii;

class VendorAddress extends \app\components\TActiveRecord
{

    public function __toString()
    {
        return (string) $this->location;
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

    public static function getTypeOptions()
    {
        return [
            "TYPE1",
            "TYPE2",
            "TYPE3"
        ];
        // return ArrayHelper::Map ( Type::findActive ()->all (), 'id', 'title' );
    }

    public function getType()
    {
        $list = self::getTypeOptions();
        return isset($list[$this->type_id]) ? $list[$this->type_id] : 'Not Defined';
    }

    public static function getCreatedByOptions()
    {
        return [
            "TYPE1",
            "TYPE2",
            "TYPE3"
        ];
        // return ArrayHelper::Map ( CreatedBy::findActive ()->all (), 'id', 'title' );
    }

    public function getCreatedBy()
    {
        $list = self::getCreatedByOptions();
        return isset($list[$this->created_by_id]) ? $list[$this->created_by_id] : 'Not Defined';
    }

    public function beforeValidate()
    {
        if ($this->isNewRecord) {
            if (! isset($this->created_on))
                $this->created_on = date('Y-m-d H:i:s');
            if (! isset($this->updated_on))
                $this->updated_on = date('Y-m-d H:i:s');
            if (! isset($this->created_by_id))
                $this->created_by_id = Yii::$app->user->id;
        } else {
            $this->updated_on = date('Y-m-d H:i:s');
        }
        return parent::beforeValidate();
    }

    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return '{{%vendor_address}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [
                [
                    'location',
                    'city',
                    'area',
                    'block',
                    'street',
                    'house',
                    'apartment',
                    'office',
                    'created_on',
                    'updated_on',
                    'created_by_id'
                ],
                'required'
            ],
            [
                [
                    'state_id',
                    'type_id',
                    'created_by_id'
                ],
                'integer'
            ],
            [
                [
                    'location',
                    'city',
                    'area',
                    'block',
                    'street',
                    'house',
                    'apartment',
                    'office',
                ],
                'string',
                'max' => 255
            ],
            [
                [
                    'location',
                    'city',
                    'area',
                    'block',
                    'street',
                    'house',
                    'apartment',
                    'office',
                ],
                'trim'
            ],
            [
                [
                    'state_id'
                ],
                'in',
                'range' => array_keys(self::getStateOptions())
            ],
            [
                [
                    'type_id'
                ],
                'in',
                'range' => array_keys(self::getTypeOptions())
            ]
        ];
    }

    /**
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'id' => Yii::t('app', 'ID'),
            'location' => Yii::t('app', 'Location'),
            'city' => Yii::t('app', 'City'),
            'area' => Yii::t('app', 'Area'),
            'block' => Yii::t('app', 'Block'),
            'street' => Yii::t('app', 'Street'),
            'house' => Yii::t('app', 'House'),
            'apartment' => Yii::t('app', 'Apartment'),
            'office' => Yii::t('app', 'Office'),
            'state_id' => Yii::t('app', 'State'),
            'type_id' => Yii::t('app', 'Type'),
            'created_on' => Yii::t('app', 'Created On'),
            'updated_on' => Yii::t('app', 'Updated On'),
            'created_by_id' => Yii::t('app', 'Created By')
        ];
    }

    public static function getHasManyRelations()
    {
        $relations = [];
        return $relations;
    }

    public static function getHasOneRelations()
    {
        $relations = [];
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
        $json['location'] = $this->location;
        $json['city'] = $this->city;
        $json['area'] = $this->area;
        $json['block'] = $this->block;
        $json['street'] = $this->street;
        $json['house'] = $this->house;
        $json['apartment'] = $this->apartment;
        $json['office'] = $this->office;
        $json['state_id'] = $this->state_id;
        $json['type_id'] = $this->type_id;
        $json['created_on'] = $this->created_on;
        $json['created_by_id'] = $this->created_by_id;
        if ($with_relations) {}
        return $json;
    }
}
