<?php

/**
 * This is the model class for table "tbl_shadow".
 *
 * @property integer $id
 * @property integer $to_id
 * @property integer $state_id
 * @property string $created_on
 * @property integer $created_by_id
 */
namespace app\modules\shadow\models;

use Yii;
use app\models\User;

class Shadow extends \app\components\TActiveRecord
{

    public function __toString()
    {
        return (string) $this->to_id;
    }

    public static function getToOptions()
    {
        return [
            "TYPE1",
            "TYPE2",
            "TYPE3"
        ];
        // return ArrayHelper::Map ( To::findActive ()->all (), 'id', 'title' );
    }

    public function getTo()
    {
        $list = self::getToOptions();
        return isset($list[$this->to_id]) ? $list[$this->to_id] : 'Not Defined';
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
            if (! isset($this->created_by_id))
                $this->created_by_id = Yii::$app->user->id;
        } else {}
        return parent::beforeValidate();
    }

    /**
     * @inheritdoc
     */
    public static function tableName()
    {
        return '{{%shadow}}';
    }

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [
                [
                    'to_id'
                ],
                'required'
            ],
            [
                [
                    'to_id',
                    'state_id',
                    'created_by_id'
                ],
                'integer'
            ],
            [
                [
                    'created_on'
                ],
                'safe'
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
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'id' => Yii::t('app', 'ID'),
            'to_id' => Yii::t('app', 'To'),
            'state_id' => Yii::t('app', 'State'),
            'created_on' => Yii::t('app', 'Created On'),
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
        $json['to_id'] = $this->to_id;
        $json['state_id'] = $this->state_id;
        $json['created_on'] = $this->created_on;
        $json['created_by_id'] = $this->created_by_id;
        if ($with_relations) {}
        return $json;
    }
    public function getCreateUser()
    {
        return $this->hasOne(User::className(), ['id' => 'created_by_id']);
    }
}
