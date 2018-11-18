<?php

/**
 * This is the model class for table "tbl_cart".
 *
 * @property integer $id
 * @property integer $state_id
 * @property integer $type_id
 * @property string $created_on
 * @property string $updated_on
 * @property integer $created_by_id
 
 * === Related data ===
 * @property User $createdBy
 */
namespace app\models;

use Yii;
use app\models\User;
use yii\helpers\ArrayHelper;

class Cart extends \app\components\TActiveRecord {
	public function __toString() {
		return ( string ) $this->state_id;
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
		return '{{%cart}}';
	}
	
	/**
	 * @inheritdoc
	 */
	public function rules() {
		return [ 
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
								'created_on',
								'updated_on',
								'created_by_id' 
						],
						'required' 
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
		return $relations;
	}
	public function beforeDelete() {
		CartItem::deleteRelatedAll ( [ 
				'cart_id' => $this->id 
		] );
		
		return parent::beforeDelete ();
	}
	public function createNewCart() {
		$this->created_by_id = \Yii::$app->user->id;
		$this->save ();
		return $this;
	}
	public function getTotalCartAmount() {
		return CartItem::find ()->select ( [ 
				'amount' 
		] )->where ( [ 
				'cart_id' => $this->id 
		] )->sum ( 'amount' );
	}
	public function asJson($with_relations = false) {
		$json = [ ];
		$json ['id'] = $this->id;
		$json ['cart_amount'] = $this->getTotalCartAmount ();
		$json ['state_id'] = $this->state_id;
		$json ['type_id'] = $this->type_id;
		$json ['created_on'] = $this->created_on;
		$json ['created_by_id'] = $this->created_by_id;
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
		}
		return $json;
	}
	public function addToCartItem($param) {
	}
	public function getVendorId($product) {
		$model = ProductVariant::find ()->where ( [ 
				'id' => $product 
		] )->one ();
		if (! empty ( $model ))
			return $model->created_by_id;
	}
	public function isProductInStock($product_id) {
		$product = ProductVariant::find ()->select ( [ 
				'quantity' 
		] )->where ( [ 
				'id' => $product_id 
		] )->one();
		if (! empty ( $product )) {
			return ($product->quantity > 0) && true;
		}
		return false;
	}
	public function addToSuperOrder($shipping_id, $payment_mode) {
// 		$model = SuperOrder::find ()->where ( [ 
// 				'shipping_address_id' => $shipping_id,
// 				'created_by_id' => $this->created_by_id 
		
// 		] )->one ();
	
		$model = new SuperOrder ();
		$model->shipping_address_id = $shipping_id;
		$model->payment_mode = $payment_mode;
		$model->order_number = $model->getCode ();
		
		if ($model->save ()) {
			return $model->id;
		} else {
			return false;
		}
	}
}