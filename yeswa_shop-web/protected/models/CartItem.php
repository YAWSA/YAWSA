<?php

/**
 * This is the model class for table "tbl_cart_item".
 *
 * @property integer $id
 * @property integer $cart_id
 * @property integer $vendor_id
 * @property integer $product_variant_id
 * @property integer $quantity
 * @property string $amount
 * @property integer $state_id
 * @property integer $type_id
 * @property string $created_on
 * @property string $updated_on
 * @property integer $created_by_id
 
 * === Related data ===
 * @property User $createdBy
 * @property ProductVariant $productVariant
 */
namespace app\models;

use Yii;
use app\models\User;
use app\models\ProductVariant;
use yii\helpers\ArrayHelper;

class CartItem extends \app\components\TActiveRecord
{

    public function __toString()
    {
        return (string) $this->vendor_id;
    }

    public static function getVendorOptions()
    {
        return ArrayHelper::Map(User::findActive()->all(), 'id', 'full_name');
    }

    public function getVendor()
    {
        $list = self::getVendorOptions();
        return isset($list[$this->vendor_id]) ? $list[$this->vendor_id] : 'Not Defined';
    }

    public static function getProductVariantOptions()
    {
        return ArrayHelper::Map(ProductVariant::findActive()->all(), 'id', 'title');
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
     *
     * @inheritdoc
     */
    public static function tableName()
    {
        return '{{%cart_item}}';
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
                    'vendor_id',
                    'product_variant_id',
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
                    'cart_id',
                    'vendor_id',
                    'product_variant_id',
                    'quantity',
                    'state_id',
                    'type_id',
                    'created_by_id',
                    'product_id'
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
                'targetClass' => User::className(),
                'targetAttribute' => [
                    'created_by_id' => 'id'
                ]
            ],
            [
                [
                    'product_variant_id'
                ],
                'exist',
                'skipOnError' => true,
                'targetClass' => ProductVariant::className(),
                'targetAttribute' => [
                    'product_variant_id' => 'id'
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
            'cart_id' => Yii::t('app', 'Cart'),
            'vendor_id' => Yii::t('app', 'Vendor'),
            'product_variant_id' => Yii::t('app', 'Product Variant'),
            'quantity' => Yii::t('app', 'Quantity'),
            'amount' => Yii::t('app', 'Amount'),
            'state_id' => Yii::t('app', 'State'),
            'type_id' => Yii::t('app', 'Type'),
            'created_on' => Yii::t('app', 'Created On'),
            'updated_on' => Yii::t('app', 'Updated On'),
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
    public function getProductVariant()
    {
        return $this->hasOne(ProductVariant::className(), [
            'id' => 'product_variant_id'
        ]);
    }

    public function getProduct()
    {
        return $this->hasOne(Product::className(), [
            'id' => 'product_id'
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
        $relations['product_variant_id'] = [
            'productVariant',
            'ProductVariant',
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
        $json['cart_id'] = $this->cart_id;
        $json['vendor_id'] = $this->vendor_id;
        $json['product_variant_id'] = $this->product_variant_id;
        $json['quantity'] = $this->quantity;
        $json['amount'] = $this->amount;
        $json['state_id'] = $this->state_id;
        $json['type_id'] = $this->type_id;
        $json['created_on'] = $this->created_on;
        $json['min_limit'] = $this->getSaleLimit();
        $json['created_by_id'] = $this->created_by_id;
        $json['product'] = isset($this->product) ? $this->product->asJson() : "";
        $json['productVariant'] = isset($this->productVariant) ? $this->productVariant->asJson() : "";
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
            // productVariant
            $list = $this->productVariant;
            
            if (is_array($list)) {
                $relationData = [];
                foreach ($list as $item) {
                    $relationData[] = $item->asJson();
                }
                $json['productVariant'] = $relationData;
            } else {
                $json['ProductVariant'] = $list;
            }
            
            $list = $this->product;
            
            if (is_array($list)) {
                $relationData = [];
                foreach ($list as $item) {
                    $relationData[] = $item->asJson();
                }
                $json['product'] = $relationData;
            } else {
                $json['Product'] = $list;
            }
        }
        return $json;
    }

    public function addToOrder($super_order_id)
    {
        $model = new Order();
        
        $model->super_order_id = $super_order_id;
        $model->vendor_id = $this->vendor_id;
        // $model->shipping_charge = $this->getShippingCharge ();
        $model->state_id = Order::STATE_NEW;
        if (! $model->save()) {
            return false;
        } else {
            $message = 'New Order Recieved';
            Notification::saveNotification($model, $message, $model->vendor_id, $model->created_by_id);
            $this->addOrderItem($model->id);
        }
    }

    public function getSaleLimit()
    {
        $sale = Sale::find()->where([
            'model_id' => $this->product_id
        ])->one();
        if (! empty($sale)) {
            if ($sale['type_id'] == Sale::BUY_AND_GET) {
                return $sale->min_limit;
            } else {
                return '';
            }
        }
    }

    public function addOrderItem($id)
    {
        $model = new OrderItem();
        $model->order_id = $id;
        $model->product_variant_id = $this->product_variant_id;
        $model->product_id = $this->product_id;
        
        $sale = Sale::find()->where([
            'model_id' => $this->product_id
        ])->one();
        
        if (! empty($sale)) {
            if ($sale->type_id == Sale::BUY_AND_GET) {
                $discount = $sale->discount;
                $min_limit = $sale->min_limit;
                $quantity = $discount + $min_limit;
                $model->quantity = $quantity;
            }
        } else {
            $model->quantity = $this->quantity;
            $model->amount = $this->amount;
        }
        if ($model->save()) {
            $cart = Cart::find()->where([
                'created_by_id' => \Yii::$app->user->id
            ])->one();
            if (! empty($cart)) {
                $cart->delete();
            }
        }
    }

    function getShippingCharge()
    {
        return 99;
    }
}
