<?php

/**
 * This is the model class for table "tbl_notification".
 *
 * @property integer $id
 * @property integer $to_user_id
 * @property integer $model_id
 * @property string $model_type
 * @property string $message
 * @property integer $state_id
 * @property integer $type_id
 * @property string $created_on
 * @property integer $created_by_id
 
 * === Related data ===
 * @property User $createdBy
 * @property User $toUser
 */
namespace app\models;

use Yii;
use yii\components;
use app\models\User;
use yii\helpers\ArrayHelper;
use app\modules\api\models\AuthSession;
use app\components\FirebaseNotifications;

class Notification extends \app\components\TActiveRecord
{

    public function __toString()
    {
        return (string) $this->to_user_id;
    }

    const TYPE_ANDROID = 1;

    const TYPE_IPHONE = 2;

    public static function getToUserOptions()
    {
        return [
            "TYPE1",
            "TYPE2",
            "TYPE3"
        ];
        // return ArrayHelper::Map ( ToUser::findActive ()->all (), 'id', 'title' );
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

    public function getModel()
    {
        $list = self::getModelOptions();
        return isset($list[$this->model_id]) ? $list[$this->model_id] : 'Not Defined';
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

    public function beforeValidate()
    {
        if ($this->isNewRecord) {
            if (! isset($this->to_user_id))
                $this->to_user_id = Yii::$app->user->id;
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
        return '{{%notification}}';
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
                    'to_user_id',
                    'model_id',
                    'model_type',
                    'message',
                    'created_by_id'
                ],
                'required'
            ],
            [
                [
                    'to_user_id',
                    'model_id',
                    'state_id',
                    'type_id',
                    'created_by_id'
                ],
                'integer'
            ],
            [
                [
                    'message'
                ],
                'string'
            ],
            [
                [
                    'created_on'
                ],
                'safe'
            ],
            [
                [
                    'model_type'
                ],
                'string',
                'max' => 32
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
                    'to_user_id'
                ],
                'exist',
                'skipOnError' => true,
                'targetClass' => User::className(),
                'targetAttribute' => [
                    'to_user_id' => 'id'
                ]
            ],
            [
                [
                    'model_type'
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
     *
     * @inheritdoc
     */
    public function attributeLabels()
    {
        return [
            'id' => Yii::t('app', 'ID'),
            'to_user_id' => Yii::t('app', 'To User'),
            'model_id' => Yii::t('app', 'Model'),
            'model_type' => Yii::t('app', 'Model Type'),
            'message' => Yii::t('app', 'Message'),
            'state_id' => Yii::t('app', 'State'),
            'type_id' => Yii::t('app', 'Type'),
            'created_on' => Yii::t('app', 'Created On'),
            'created_by_id' => Yii::t('app', 'Created By')
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

    /**
     *
     * @return \yii\db\ActiveQuery
     */
    public function getToUser()
    {
        return $this->hasOne(User::className(), [
            'id' => 'to_user_id'
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
        $relations['to_user_id'] = [
            'toUser',
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
        $json['to_user_id'] = $this->to_user_id;
        $json['model_id'] = $this->model_id;
        $json['model_type'] = $this->model_type;
        $json['message'] = $this->message;
        $json['state_id'] = $this->state_id;
        $json['type_id'] = $this->type_id;
        $json['created_on'] = $this->created_on;
        $json['created_by_id'] = $this->created_by_id;
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
            // toUser
            $list = $this->toUser;
            
            if (is_array($list)) {
                $relationData = [];
                foreach ($list as $item) {
                    $relationData[] = $item->asJson();
                }
                $json['toUser'] = $relationData;
            } else {
                $json['ToUser'] = $list;
            }
        }
        return $json;
    }

    public static function saveNotification($model, $message, $to, $from)
    {
        $notification = new Notification();
        $notification->message = $message;
        $notification->model_id = $model->id;
        $notification->model_type = get_class($model);
        $notification->to_user_id = $to;
        $notification->created_by_id = $from;
        $notification->type_id = $model->type_id;
        $notification->state_id = $model->state_id;
        if ($notification->save()) {
          
            Notification::sendNotification($notification->to_user_id, $message, $notification->created_by_id, $notification->state_id, $notification->model_id);
            // send notification
        } else {
            // print_r($notification->getErrorsString());exit;
            return false;
        }
    }

    public static function sendNotification($id, $message, $from, $state_id, $model_id)
    {
        $user = User::find()->where([
            'id' => $id
        ])->one();
      
        $notification = new FirebaseNotifications();
        $androidtoken = [];
        $iostoken = [];
        $tokens = "";
        $data = [];
        $data['controller'] = \yii::$app->controller->id;
        $data['action'] = \yii::$app->controller->action->id;
        $data['message'] = $message;
        
        if (! empty($user)) {
            $data['to_user_id'] = $id;
            $data['from_id'] = $from;
            $data['role_id'] = $user->role_id;
            $data['state_id'] = $state_id;
            $data['task_id'] = $model_id;
            $tokens = $user->authSessions;
            if (count($tokens) > 0) {
                foreach ($tokens as $token) {
                   
                    if ($token->type_id == Notification::TYPE_ANDROID) {
                        $androidtoken[] = $token->device_token;
                    }
                    if ($token->type_id == Notification::TYPE_IPHONE)
                        $iostoken[] = $token->device_token;
                }
                
                \yii::error($data);
                if (! empty($androidtoken)) {
                    try {
                        \Yii::error(\yii\helpers\VarDumper::dumpAsString('android NOTIFICATION SEND'));
                        \Yii::error(\yii\helpers\VarDumper::dumpAsString($data));
                        $notification->sendDataMessage($androidtoken, $data);
                    } catch (\Exception $e) {
                        \Yii::error(\yii\helpers\VarDumper::dumpAsString('android NOTIFICATION SEND ERRROR'));
                        \Yii::error(\yii\helpers\VarDumper::dumpAsString($e->getMessage()));
                    }
                }
                
                if (! empty($iostoken)) {
                    \yii::error("IOS TOKENS");
                    \yii::error(\yii\helpers\VarDumper::dumpAsString($iostoken));
                    $apns = \Yii::$app->apns;
                    foreach ($iostoken as $tokn) {
                        try {
                            $out = $apns->send($tokn, $data['message'], $data, [
                                'sound' => 'default',
                                'badge' => 1
                            ]);
                       
                        } catch (\Exception $e) {
                            \Yii::error(\yii\helpers\VarDumper::dumpAsString('IOS NOTIFICATION SEND ERRROR'));
                            \Yii::error(\yii\helpers\VarDumper::dumpAsString($e->getMessage()));
                            // \yii::error ( \yii\helpers\VarDumper::dumpAsString ( $out ) );
                        }
                    }
                }
            }
        }
    }
}
