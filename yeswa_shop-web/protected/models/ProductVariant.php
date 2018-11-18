<?php

/**
 * This is the model class for table "tbl_product_variant".
 *
 * @property integer $id
 * @property integer $product_id
 * @property integer $color_id
 * @property integer $size_id
 * @property integer $quantity
 * @property string $amount
 * @property integer $state_id
 * @property integer $type_id
 * @property string $created_on
 * @property string $updated_on
 * @property integer $created_by_id
 
 * === Related data ===
 * @property CartItem[] $cartItems
 * @property User $createdBy
 * @property Product $product
 */
namespace app\models;

use Yii;
use app\models\CartItem;
use app\models\User;
use app\models\Product;
use yii\helpers\ArrayHelper;

class ProductVariant extends \app\components\TActiveRecord {
	public function __toString() {
		return ( string ) $this->product_id;
	}
	public static function getProductOptions() {
		return ArrayHelper::Map ( Product::findActive ()->all (), 'id', 'title' );
	}
	public static function getColorOptions() {
		return ArrayHelper::Map ( Color::findActive ()->all (), 'id', 'title' );
	}
	public static function getSizeOptions() {
		return ArrayHelper::Map ( Size::findActive ()->all (), 'id', 'title' );
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
		return '{{%product_variant}}';
	}
	
	/**
	 * @inheritdoc
	 */
	public function rules() {
		return [ 
				[ 
						[ 
								'product_id',
								'quantity',
								'amount',
								'created_on',
								'updated_on',
								'created_by_id' 
						],
						'required' 
				],
				[ 
						[ 
								'product_id',
								'color_id',
								'size_id',
								'quantity',
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
								'product_id' 
						],
						'exist',
						'skipOnError' => true,
						'targetClass' => Product::className (),
						'targetAttribute' => [ 
								'product_id' => 'id' 
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
				'product_id' => Yii::t ( 'app', 'Product' ),
				'color_id' => Yii::t ( 'app', 'Color' ),
				'size_id' => Yii::t ( 'app', 'Size' ),
				'quantity' => Yii::t ( 'app', 'Quantity' ),
				'amount' => Yii::t ( 'app', 'Amount' ),
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
	public function getCartItems() {
		return $this->hasMany ( CartItem::className (), [ 
				'product_variant_id' => 'id' 
		] );
	}
	public function getColor() {
		return $this->hasOne ( Color::className (), [ 
				'id' => 'color_id' 
		] );
	}
	public function getSize() {
		return $this->hasOne ( Size::className (), [ 
				'id' => 'size_id' 
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
	public function getProduct() {
		return $this->hasOne ( Product::className (), [ 
				'id' => 'product_id' 
		] );
	}
	public static function getHasManyRelations() {
		$relations = [ ];
		
		$relations ['CartItems'] = [ 
				'cartItems',
				'CartItem',
				'id',
				'product_variant_id' 
		];
		return $relations;
	}
	public static function getHasOneRelations() {
		$relations = [ ];
		$relations ['color_id'] = [ 
				'color',
				'Color',
				'id' 
		];
		$relations ['size_id'] = [ 
				'size',
				'Size',
				'id' 
		];
		
		$relations ['created_by_id'] = [ 
				'createdBy',
				'User',
				'id' 
		];
		$relations ['product_id'] = [ 
				'product',
				'Product',
				'id' 
		];
		return $relations;
	}
	public function checkValidData($id) {
		$productVariant = self::find ()->where ( [ 
				'product_id' => $id,
				'color_id' => $this->color_id,
				
				'size_id' => $this->size_id 
		] )->one ();
		
		return $productVariant && true;
	}
	public function beforeDelete() {
		CartItem::deleteRelatedAll ( [ 
				'product_variant_id' => $this->id 
		] );
		
		OrderItem::deleteRelatedAll ( [ 
				'product_variant_id' => $this->id 
		] );
		return parent::beforeDelete ();
	}
	public function getProductDetail() {
		$model = Product::find ()->where ( [ 
				'id' => $this->product_id 
		] )->one ();
		if (! empty ( $model ))
			return $model->asJson ();
		return null;
	}
	public function asColorJson($with_relations = false) {
		$json = [ ];
		
		$json ['product_id'] = $this->product_id;
		$json ['color_id'] = $this->color_id;
		$json['current'] =  date('Y-m-d H:i:s');
		$json ['color_title'] = $this->color->title;
		$json ['sizeDetail'] = $this->sizeDetail ();
	
		
		return $json;
	}
	public function asJson($with_relations = false) {
		$json = [ ];
		$json ['id'] = $this->id;
		$json ['description'] = $this->product->description;
		$json ['product_id'] = $this->product_id;
		$json ['size_id'] = $this->size_id;
		$json ['size_title'] = $this->size->title;
		$json ['color_id'] = $this->color_id;
		$json ['color_title'] = $this->color->title;
		$json ['quantity'] = $this->quantity;
		$json ['amount'] = $this->amount;
		$json ['state_id'] = $this->state_id;
		$json ['type_id'] = $this->type_id;
		$json ['created_on'] = $this->created_on;
		$json ['created_by_id'] = $this->created_by_id;
		
		// $json['product_detail'] = $this->getProductDetail();
		
		if ($with_relations) {
			// cartItems
			$list = $this->cartItems;
			
			if (is_array ( $list )) {
				$relationData = [ ];
				foreach ( $list as $item ) {
					$relationData [] = $item->asJson ();
				}
				$json ['cartItems'] = $relationData;
			} else {
				$json ['CartItems'] = $list;
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
			// product
			$list = $this->product;
			
			if (is_array ( $list )) {
				$relationData = [ ];
				foreach ( $list as $item ) {
					$relationData [] = $item->asJson ();
				}
				$json ['product'] = $relationData;
			} else {
				$json ['Product'] = $list;
			}
		}
		return $json;
	}
	public function sizeDetail() {
		$list = [ ];
		$models = ProductVariant::find ()->where ( [ 
				'product_id' => $this->product_id,
				'color_id' => $this->color_id 
		] )->all ();
		if (! empty ( $models )) {
			foreach ( $models as $model ) {
				$list [] = $model->asJson ();
			}
		}
		
		return $list;
	}
	public function loadFaker() {
		if (YII_ENV == 'prod')
			return;
		
		$this->color_id = Color::find ()->one ()->id;
		$this->size_id = Size::find ()->one ()->id;
	}
}
