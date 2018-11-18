<?php

/**
 * This is the model class for table "tbl_super_order".
 *
 * @property integer $id
 * @property integer $shipping_address_id
 * @property integer $state_id
 * @property integer $type_id
 * @property string $created_on
 * @property string $updated_on
 * @property integer $created_by_id
 
 * === Related data ===
 * @property Order[] $orders
 * @property User $createdBy
 * @property ShippingAddress $shippingAddress
 */
namespace app\models;

use Yii;
use yii\helpers\ArrayHelper;

class SuperOrder extends \app\components\TActiveRecord {
	const CASH = 0;
	const CARD = 1;
	public function __toString() {
		return ( string ) $this->shipping_address_id;
	}
	public static function getShippingAddressOptions() {
		return ArrayHelper::Map ( ShippingAddress::findActive ()->all (), 'id', 'title' );
	}
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
		return '{{%super_order}}';
	}
	
	/**
	 * @inheritdoc
	 */
	public function rules() {
		return [ 
				[ 
						[ 
								'shipping_address_id',
								'created_on',
								'created_by_id' 
						],
						'required' 
				],
				[ 
						[ 
								'shipping_address_id',
								'state_id',
								'type_id',
								'created_by_id',
								'payment_mode' 
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
								'shipping_address_id' 
						],
						'exist',
						'skipOnError' => true,
						'targetClass' => ShippingAddress::className (),
						'targetAttribute' => [ 
								'shipping_address_id' => 'id' 
						] 
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
				],
				[ 
						[ 
								'order_number' 
						],
						'string',
						'max' => 255 
				] 
		];
	}
	
	/**
	 * @inheritdoc
	 */
	public function attributeLabels() {
		return [ 
				'id' => Yii::t ( 'app', 'ID' ),
				'shipping_address_id' => Yii::t ( 'app', 'Shipping Address' ),
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
	public function getOrders() {
		return $this->hasMany ( Order::className (), [ 
				'super_order_id' => 'id' 
		] );
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
	public function getShippingAddress() {
		return $this->hasOne ( ShippingAddress::className (), [ 
				'id' => 'shipping_address_id' 
		] );
	}
	public static function getHasManyRelations() {
		$relations = [ ];
		$relations ['Orders'] = [ 
				'orders',
				'Order',
				'id',
				'super_order_id' 
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
		$relations ['shipping_address_id'] = [ 
				'shippingAddress',
				'ShippingAddress',
				'id' 
		];
		return $relations;
	}
	public function beforeDelete() {
		Order::deleteRelatedAll ( [ 
				'super_order_id' => $this->id 
		] );
		return parent::beforeDelete ();
	}
	public function asJson($with_relations = false) {
		$json = [ ];
		$json ['id'] = $this->id;
		
		// $json['order'] = $this->getOrderItem();
		$json ['order_items'] = $this->getOnlyOrderItem ();
		$json ['order_number'] = $this->order_number;
		
		$json ['shipping_address_id'] = $this->shipping_address_id;
		$json ['shipping_address'] = isset ( $this->shippingAddress ) ? $this->shippingAddress->asJson () : "";
		$json ['shipping_charge'] = 2;
		$json ['state_id'] = $this->state_id;
		$json ['type_id'] = $this->type_id;
		$json ['created_on'] = $this->created_on;
		$json ['created_by_id'] = $this->created_by_id;
		if ($with_relations) {
			// orders
			$list = $this->orders;
			
			if (is_array ( $list )) {
				$relationData = [ ];
				foreach ( $list as $item ) {
					$relationData [] = $item->asJson ();
				}
				$json ['orders'] = $relationData;
			} else {
				$json ['Orders'] = $list;
			}
			// createdBy
			$list = $this->createdBy;
			
			if (is_array ( $list )) {
				$relationData = [ ];
				foreach ( $list as $item ) {
					$relationData [] = $item->asJson ();
				}
				$json ['createdBy'] = $relationData;
			} else {
				$json ['CreatedBy'] = $list;
			}
			// shippingAddress
			$list = $this->shippingAddress;
			
			if (is_array ( $list )) {
				$relationData = [ ];
				foreach ( $list as $item ) {
					$relationData [] = $item->asJson ();
				}
				$json ['shippingAddress'] = $relationData;
			} else {
				$json ['ShippingAddress'] = $list;
			}
		}
		return $json;
	}
	public function getCode() {
		return $code = strtoupper ( substr ( md5 ( uniqid ( mt_rand (), true ) ), 0, 4 ) );
	}
	public function getOrderItem() {
		$list = [ ];
		$orders = Order::find ()->where ( [ 
				'super_order_id' => $this->id 
		] )->all ();
		if (! empty ( $orders )) {
			foreach ( $orders as $order ) {
				$list [] = $order->asJson ( true );
			}
		}
		
		return $list;
	}
	public function getOnlyOrderItem() {
		$list = [ ];
		$orderIds = Order::find ()->select('id')->where ( [ 
				'super_order_id' => $this->id 
		] )->column ();
		
		
		if (count ( $orderIds > 0 )) {
			$orderItems = OrderItem::find ()->where ( [ 
					'order_id' => $orderIds 
			] )->orderBy ('id desc')->all ();
			
			if (! empty ( $orderItems )) {
				foreach ( $orderItems as $orderItem ) {
					$list [] = $orderItem->asJson ( true );
				}
			}
		}
		
		// // print_r($orderIds);die;
		// if (! empty($orders)) {
		// foreach ($orders as $order) {
		// $list[] = $order->asJson(true);
		// }
		// }
		
		return $list;
	}
}
