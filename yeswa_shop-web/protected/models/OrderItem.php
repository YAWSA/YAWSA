<?php

/**
 * This is the model class for table "tbl_order_item".
 *
 * @property integer $id
 * @property integer $order_id
 * @property integer $product_variant_id
 * @property integer $quantity
 * @property string $amount
 * @property string $expected_delivery_date
 * @property integer $type_id
 * @property integer $state_id
 * @property string $created_on
 * @property string $updated_on
 * @property integer $created_by_id
 
 * === Related data ===
 * @property User $createdBy
 * @property Order $order
 */
namespace app\models;

use Yii;
use yii\helpers\ArrayHelper;

class OrderItem extends \app\components\TActiveRecord {
	public function __toString() {
		return ( string ) $this->order_id;
	}
	public static function getOrderOptions() {
		return ArrayHelper::Map ( Order::findActive ()->all (), 'id', 'title' );
	}
	public static function getProductVariantOptions() {
		return ArrayHelper::Map ( ProductVariant::findActive ()->all (), 'id', 'id' );
	}
	
	/*
	 * public function getProductVariant()
	 * {
	 * $list = self::getProductVariantOptions();
	 * return isset($list[$this->product_variant_id]) ? $list[$this->product_variant_id] : 'Not Defined';
	 * }
	 */
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
	const STATE_INACTIVE = 0;
	const STATE_ACTIVE = 1;
	const STATE_DELETED = 2;
	public static function getStateOptions() {
		return [ 
				self::STATE_INACTIVE => "New",
				self::STATE_ACTIVE => "Active",
				self::STATE_DELETED => "Archived" 
		];
	}
	public function getState() {
		$list = self::getStateOptions ();
		return isset ( $list [$this->state_id] ) ? $list [$this->state_id] : 'Not Defined';
	}
	public function getStateBadge() {
		$list = [ 
				self::STATE_INACTIVE => "primary",
				self::STATE_ACTIVE => "success",
				self::STATE_DELETED => "danger" 
		];
		return isset ( $list [$this->state_id] ) ? \yii\helpers\Html::tag ( 'span', $this->getState (), [ 
				'class' => 'label label-' . $list [$this->state_id] 
		] ) : 'Not Defined';
	}
	public function beforeValidate() {
		if ($this->isNewRecord) {
			if (! isset ( $this->expected_delivery_date ))
				$this->expected_delivery_date = date ( 'Y-m-d' );
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
		return '{{%order_item}}';
	}
	
	/**
	 * @inheritdoc
	 */
	public function rules() {
		return [ 
				[ 
						[ 
								'order_id',
								'product_variant_id',
								'quantity',
								'amount',
								'created_on',
								'created_by_id' 
						],
						'required' 
				],
				[ 
						[ 
								'order_id',
								'product_variant_id',
								'quantity',
								'type_id',
								'state_id',
								'created_by_id',
								'product_id' 
						],
						'integer' 
				],
				[ 
						[ 
								'expected_delivery_date',
								'created_on',
								'updated_on' 
						],
						'safe' 
				],
				[ 
						[ 
								'amount' 
						],
						'string',
						'max' => 255 
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
								'order_id' 
						],
						'exist',
						'skipOnError' => true,
						'targetClass' => Order::className (),
						'targetAttribute' => [ 
								'order_id' => 'id' 
						] 
				],
				[ 
						[ 
								'amount' 
						],
						'trim' 
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
								'state_id' 
						],
						'in',
						'range' => array_keys ( self::getStateOptions () ) 
				] 
		];
	}
	
	/**
	 * @inheritdoc
	 */
	public function attributeLabels() {
		return [ 
				'id' => Yii::t ( 'app', 'ID' ),
				'order_id' => Yii::t ( 'app', 'Order' ),
				'product_variant_id' => Yii::t ( 'app', 'Product Variant' ),
				'quantity' => Yii::t ( 'app', 'Quantity' ),
				'amount' => Yii::t ( 'app', 'Amount' ),
				'expected_delivery_date' => Yii::t ( 'app', 'Expected Delivery Date' ),
				'type_id' => Yii::t ( 'app', 'Type' ),
				'state_id' => Yii::t ( 'app', 'State' ),
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
	public function getOrder() {
		return $this->hasOne ( Order::className (), [ 
				'id' => 'order_id' 
		] );
	}
	public function getProductVariant() {
		return $this->hasOne ( ProductVariant::className (), [ 
				'id' => 'product_variant_id' 
		] );
	}
	public function getProduct() {
		return $this->hasOne ( Product::className (), [ 
				'id' => 'product_id' 
		] );
	}
	public static function getHasManyRelations() {
		$relations = [ ];
		return $relations;
	}
	public static function getHasOneRelations() {
		$relations = [ ];
		$relations ['created_by_id'] = [ 
				'createdBy',
				'User',
				'id' 
		];
		$relations ['order_id'] = [ 
				'order',
				'Order',
				'id' 
		];
		$relations ['product_variant_id'] = [ 
				'productVariant',
				'ProductVariant',
				'id' 
		];
		
		$relations ['product_id'] = [ 
				'product',
				'Product',
				'id' 
		];
		return $relations;
	}
	public function beforeDelete() {
		return parent::beforeDelete ();
	}
	public function asJson($with_relations = false) {
		$json = [ ];
		$json ['id'] = $this->id;
		$json ['order_id'] = $this->order_id;
		$json ['product_variant_id'] = $this->product_variant_id;
		$json ['quantity'] = $this->quantity;
		$json ['amount'] = $this->amount;
		$json ['expected_delivery_date'] = $this->expected_delivery_date;
		$json ['type_id'] = $this->type_id;
		$json ['state_id'] = $this->state_id;
		$json ['created_on'] = $this->created_on;
		$json ['created_by_id'] = $this->created_by_id;
		$json ['product'] = isset ( $this->product ) ? $this->product->asJson () : "";
		$json ['productVariant'] = isset ( $this->productVariant ) ? $this->productVariant->asJson () : "";
		if ($with_relations) {
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
			// order
			$list = $this->order;
			
			if (is_array ( $list )) {
				$relationData = [ ];
				foreach ( $list as $item ) {
					$relationData [] = $item->asJson ();
				}
				$json ['order'] = $relationData;
			} else {
				$json ['Order'] = $list;
			}
		}
		return $json;
	}
}
