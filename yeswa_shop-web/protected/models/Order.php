<?php

/**
 * This is the model class for table "tbl_order".
 *
 * @property integer $id
 * @property integer $super_order_id
 * @property integer $vendor_id
 * @property string $shipping_charge
 * @property integer $state_id
 * @property integer $type_id
 * @property string $created_on
 * @property string $updated_on
 * @property integer $created_by_id
 
 * === Related data ===
 * @property User $createdBy
 * @property SuperOrder $superOrder
 * @property OrderCancel[] $orderCancels
 * @property OrderItem[] $orderItems
 */
namespace app\models;

use Yii;
use app\models\User;
use app\models\SuperOrder;
use app\models\OrderCancel;
use app\models\OrderItem;
use yii\helpers\ArrayHelper;

class Order extends \app\components\TActiveRecord {
	public function __toString() {
		return ( string ) $this->super_order_id;
	}
	public static function getSuperOrderOptions() {
		return ArrayHelper::Map ( SuperOrder::findActive ()->all (), 'id', 'title' );
	}
	/*
	 * public static function getVendorOptions() {
	 * return ArrayHelper::Map ( User::findActive ()->all (), 'id', 'title' );
	 * }
	 * public function getVendor() {
	 * $list = self::getVendorOptions ();
	 * return isset ( $list [$this->vendor_id] ) ? $list [$this->vendor_id] : 'Not Defined';
	 * }
	 */
	const STATE_NEW = 1;
	const STATE_ACCEPTED = 2;
	const STATE_REJECTED = 3;
	const STATE_CANCELLED = 4;
	const STATE_STARTED = 5;
	const STATE_COMPLETED = 6;
	public static function getStateOptions() {
		return [ 
				self::STATE_NEW => "New",
				self::STATE_ACCEPTED => "Accepted",
				self::STATE_REJECTED => "Rejected",
				self::STATE_CANCELLED => "Cancelled",
				self::STATE_STARTED => "Started",
				self::STATE_COMPLETED => "Completed" 
		];
	}
	public function getState() {
		$list = self::getStateOptions ();
		return isset ( $list [$this->state_id] ) ? $list [$this->state_id] : 'Not Defined';
	}
	public function getStateBadge() {
		$list = [ 
				self::STATE_NEW => "primary",
				self::STATE_ACCEPTED => "success",
				self::STATE_REJECTED => "danger",
				self::STATE_CANCELLED => "danger",
				self::STATE_STARTED => "primary",
				self::STATE_COMPLETED => "success" 
		];
		return isset ( $list [$this->state_id] ) ? \yii\helpers\Html::tag ( 'span', $this->getState (), [ 
				'class' => 'label label-' . $list [$this->state_id] 
		] ) : 'Not Defined';
	}
	public static function getTypeOptions() {
		return [ 
				"TYPE1",
				"TYPE2",
				"TYPE3" 
		];
		// return ArrayHelper::Map ( Type::findActive ()->all (), 'id', 'title' );
	}
	public function getType() {
		$list = self::getTypeOptions ();
		return isset ( $list [$this->type_id] ) ? $list [$this->type_id] : 'Not Defined';
	}
	public function beforeValidate() {
		if ($this->isNewRecord) {
			if (! isset ( $this->created_on ))
				$this->created_on = date ( 'Y-m-d H:i:s' );
			if (! isset ( $this->updated_on ))
				$this->updated_on = date ( 'Y-m-d H:i:s' );
			if (! isset ( $this->created_by_id ))
				$this->created_by_id = Yii::$app->user->id;
		} else {
			$this->updated_on = date ( 'Y-m-d H:i:s' );
		}
		return parent::beforeValidate ();
	}
	
	/**
	 * @inheritdoc
	 */
	public static function tableName() {
		return '{{%order}}';
	}
	
	/**
	 * @inheritdoc
	 */
	public function rules() {
		return [ 
				[ 
						[ 
								'super_order_id',
								'vendor_id',
								
								'created_on',
								'created_by_id' 
						],
						'required' 
				],
				[ 
						[ 
								'super_order_id',
								'vendor_id',
								'state_id',
								'type_id',
								'created_by_id' 
						],
						'integer' 
				],
				[ 
						[ 
								'created_on',
								'updated_on' 
						],
						'safe' 
				],
				[ 
						[ 
								'created_by_id' 
						],
						'exist',
						'skipOnError' => true,
						'targetClass' => User::className (),
						'targetAttribute' => [ 
								'created_by_id' => 'id' 
						] 
				],
				[ 
						[ 
								'super_order_id' 
						],
						'exist',
						'skipOnError' => true,
						'targetClass' => SuperOrder::className (),
						'targetAttribute' => [ 
								'super_order_id' => 'id' 
						] 
				],
				[ 
						[ 
								'shipping_charge' 
						],
						'trim' 
				],
				[ 
						[ 
								'state_id' 
						],
						'in',
						'range' => array_keys ( self::getStateOptions () ) 
				],
				[ 
						[ 
								'type_id' 
						],
						'in',
						'range' => array_keys ( self::getTypeOptions () ) 
				] 
		];
	}
	
	/**
	 * @inheritdoc
	 */
	public function attributeLabels() {
		return [ 
				'id' => Yii::t ( 'app', 'ID' ),
				'super_order_id' => Yii::t ( 'app', 'Super Order' ),
				'vendor_id' => Yii::t ( 'app', 'Vendor' ),
				'shipping_charge' => Yii::t ( 'app', 'Shipping Charge' ),
				'state_id' => Yii::t ( 'app', 'State' ),
				'type_id' => Yii::t ( 'app', 'Type' ),
				'created_on' => Yii::t ( 'app', 'Created On' ),
				'updated_on' => Yii::t ( 'app', 'Updated On' ),
				'created_by_id' => Yii::t ( 'app', 'Created By' ) 
		];
	}
	
	/**
	 *
	 * @return \yii\db\ActiveQuery
	 */
	public function getCreatedBy() {
		return $this->hasOne ( User::className (), [ 
				'id' => 'created_by_id' 
		] );
	}
	
	/**
	 *
	 * @return \yii\db\ActiveQuery
	 */
	public function getSuperOrder() {
		return $this->hasOne ( SuperOrder::className (), [ 
				'id' => 'super_order_id' 
		] );
	}
	public function getVendor() {
		return $this->hasOne ( User::className (), [ 
				'id' => 'vendor_id' 
		] );
	}
	
	/**
	 *
	 * @return \yii\db\ActiveQuery
	 */
	public function getOrderCancels() {
		return $this->hasMany ( OrderCancel::className (), [ 
				'order_id' => 'id' 
		] );
	}
	
	/**
	 *
	 * @return \yii\db\ActiveQuery
	 */
	public function getOrderItems() {
		return $this->hasMany ( OrderItem::className (), [ 
				'order_id' => 'id' 
		] );
	}
	public static function getHasManyRelations() {
		$relations = [ ];
		$relations ['OrderCancels'] = [ 
				'orderCancels',
				'OrderCancel',
				'id',
				'order_id' 
		];
		$relations ['OrderItems'] = [ 
				'orderItems',
				'OrderItem',
				'id',
				'order_id' 
		];
		return $relations;
	}
	public static function getHasOneRelations() {
		$relations = [ ];
		$relations ['created_by_id'] = [ 
				'createdBy',
				'User',
				'id' 
		];
		$relations ['super_order_id'] = [ 
				'superOrder',
				'SuperOrder',
				'id' 
		];
		return $relations;
	}
	public function beforeDelete() {
		OrderCancel::deleteRelatedAll ( [ 
				'order_id' => $this->id 
		] );
		OrderItem::deleteRelatedAll ( [ 
				'order_id' => $this->id 
		] );
		return parent::beforeDelete ();
	}
	public function asJson($with_relations = false) {
		$json = [ ];
		$json ['id'] = $this->id;
		$json ['super_order_id'] = $this->super_order_id;
		$json ['order_number'] = isset ( $this->superOrder ) ? $this->superOrder->order_number : "";
		$json ['amount'] = $this->calculateAmount ();
		$json ['shipping_address'] = isset ( $this->superOrder->shippingAddress ) ? $this->superOrder->shippingAddress->asJson () : "";
		$json ['vendor_id'] = $this->vendor_id;
		// $json ['shipping_charge'] = $this->shipping_charge;
		$json ['state_id'] = $this->state_id;
		$json ['type_id'] = $this->type_id;
		$json ['created_on'] = $this->created_on;
		$json ['created_by_id'] = $this->created_by_id;
		if ($with_relations) {
			// createdBy
			/*
			 * $list = $this->createdBy;
			 *
			 * if (is_array ( $list )) {
			 * $relationData = [ ];
			 * foreach ( $list as $item ) {
			 * $relationData [] = $item->asJson ();
			 * }
			 * $json ['createdBy'] = $relationData;
			 * } else {
			 * $json ['CreatedBy'] = $list;
			 * }
			 * // superOrder
			 * $list = $this->superOrder;
			 *
			 * if (is_array ( $list )) {
			 * $relationData = [ ];
			 * foreach ( $list as $item ) {
			 * $relationData [] = $item->asJson ();
			 * }
			 * $json ['superOrder'] = $relationData;
			 * } else {
			 * $json ['SuperOrder'] = $list;
			 * }
			 * // orderCancels
			 * $list = $this->orderCancels;
			 *
			 * if (is_array ( $list )) {
			 * $relationData = [ ];
			 * foreach ( $list as $item ) {
			 * $relationData [] = $item->asJson ();
			 * }
			 * $json ['orderCancels'] = $relationData;
			 * } else {
			 * $json ['OrderCancels'] = $list;
			 * }
			 */
			// orderItems
			$list = $this->orderItems;
			
			if (is_array ( $list )) {
				$relationData = [ ];
				foreach ( $list as $item ) {
					$relationData [] = $item->asJson ();
				}
				$json ['order'] = $relationData;
			} else {
				$json ['order'] = $list;
			}
		}
		return $json;
	}
	public function calculateAmount() {
		$amount = OrderItem::find ()->where ( [ 
				'order_id' => $this->id 
		] )->sum ( 'amount' );
		return (!empty($this->shipping_charge) ? $this->shipping_charge + $amount : $amount);
	}
}
