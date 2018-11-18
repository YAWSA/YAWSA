<?php
namespace app\modules\api\controllers;

use app\models\Cart;
use app\models\CartItem;
use yii\filters\AccessControl;
use yii\filters\AccessRule;
use app\models\ProductVariant;
use app\models\Brand;
use app\models\Category;
use app\models\Product;
use app\models\Color;
use app\models\Size;
use yii\web\HttpException;
use Yii;
use yii\web\NotFoundHttpException;
use yii\helpers\Json;
use yii\web\UploadedFile;
use app\models\File;
use app\models\ShippingAddress;
use app\models\User;
use app\models\Country;
use app\models\State;
use app\models\Sale;

/**
 * ProductController implements the API actions for Product model.
 */
class ProductController extends ApiTxController
{

    public function behaviors()
    {
        return [
            'access' => [
                'class' => AccessControl::className(),
                'ruleConfig' => [
                    'class' => AccessRule::className()
                ],
                'rules' => [
                    [
                        'actions' => [
                            'index',
                            'add',
                            'get',
                            'update',
                            'delete',
                            'add-product-variant',
                            'add-brand',
                            'update-brand',
                            'delete-brand',
                            'add-to-cart',
                            'add-to-order',
                            'send-mail',
                            'category-list',
                            'get-brand-list',
                            'get-myproduct-list',
                            'color-list',
                            'size-list',
                            'get-country',
                            'get-state',
                            'get-all-brand-list',
                            'delete-product-image',
                            'delete-variant',
                            'update-variant',
                            'add-product-image',
                            'cart-item-list',
                            'delete-cart-item',
                            'update-cart-item',
                            'brand-search',
                            'category-search',
                            'home-search',
                            'filter',
                            'get-new-products'
                        ],
                        'allow' => true,
                        'roles' => [
                            '@'
                        ]
                    ],
                    [
                        'actions' => [
                            'index',
                            'get-all-brand-list',
                            'color-list',
                            'size-list',
                            'get',
                            'brand-search',
                            'category-search',
                            'update',
                            'get-new-products'
                        ],
                        'allow' => true,
                        'roles' => [
                            '?',
                            '*'
                        ]
                    ],
                    [
                        'actions' => [
                            'category-list',
                            'get-all-brand-list',
                            'get-product-list',
                            'get-brand-list',
                            'category-list',
                            'filter',
                            'vendor-product-list'
                        ],
                        'allow' => true,
                        'roles' => [
                            '?',
                            '*',
                            '@'
                        ]
                    ]
                ],
                'denyCallback' => function ($rule, $action) {
                    throw new HttpException(403, Yii::t('app', 'Valid authcode required !!'));
                    
                    exit();
                }
            ]
        ];
    }

    /**
     * Lists all Product models.
     *
     * @return mixed
     */
    public function actionIndex()
    {
        return $this->txindex("app\models\search\Product");
    }

    /**
     * Displays a single app\models\Product model.
     *
     * @return mixed
     */
    public function actionGet($id)
    {
        return $this->txget($id, "app\models\Product", true);
    }

    /**
     * Creates a new Product model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     *
     * @return mixed
     */
    public function actionAdd()
    {
        $data = [];
        $model = new Product();
        $file = new File();
        $model->state_id = Product::STATE_INACTIVE;
        if ($model->load(\Yii::$app->request->post())) {
            if ($model->save()) {
                if ($_FILES) {
                    $model->saveFile($file);
                }
            }
            $data = $model->getIsSaveStatus();
        }
        return $this->sendResponse($data);
    }

    public function actionAddProductVariant($id)
    {
        $data = [];
        $product = $this->findModel($id);
        $model = new ProductVariant();
        $model->product_id = $product->id;
        $post = \Yii::$app->request->post();
        
        if ($model->load($post)) {
            $flag = true;
            $db = \Yii::$app->db;
            $transaction = $db->beginTransaction();
            $items = Json::decode($post['ProductVariant']['items']);
            // print_r($items);
            // exit();
            if (! empty($items)) {
                foreach ($items as $item) {
                    foreach ($item['detail'] as $detail) {
                        $variant = new ProductVariant();
                        $variant->product_id = $id;
                        $variant->color_id = $item['color_id'];
                        $variant->amount = $item['amount'];
                        $variant->created_by_id = \Yii::$app->user->id;
                        $variant->size_id = $detail['size_id'];
                        $variant->quantity = $detail['quantity'];
                        if ($variant->checkValidData($id)) {
                            $data['error'] = self::API_NOK;
                            $data['error'] = \Yii::t('app', 'Already Exist');
                            return $this->sendResponse($data);
                        } else {
                            if (! $variant->save()) {
                                $data['error'] = $variant->errorsString;
                                $flag = false;
                                break;
                            }
                        }
                    }
                }
                if ($flag == true) {
                    $product->state_id = Product::STATE_ACTIVE;
                    if ($product->save(false)) {
                        $transaction->commit();
                        $data['status'] = self::API_OK;
                        $data['detail'] = $product->asJson(true);
                    }
                } else {
                    $transaction->rollBack();
                }
            } else {
                $data['error'] = \Yii::t('app', 'Data Not Posted');
            }
        }
        return $this->sendResponse($data);
    }

    /**
     * Updates an existing Product model.
     * If update is successful, the browser will be redirected to the 'view' page.
     *
     * @return mixed
     */
    /**
     *
     * @param ProductVariant $id
     * @return string[]|array
     */
    public function actionUpdate($id)
    {
        $data = [];
        
        $productVariant = ProductVariant::findOne([
            'id' => $id
        ]);
        $post = \Yii::$app->request->post();
        if (! empty($productVariant)) {
            $product = Product::findOne([
                'id' => $productVariant->product_id
            ]);
            $file = File::find()->where([
                'model_id' => $product->id,
                'model_type' => get_class($product)
            ])->all();
            if (empty($file)) {
                $file = new File();
            }
            if (($product->load($post)) || ($productVariant->load($post))) {
                if (($product->save())) {
                    if ($_FILES) {
                        $model->saveFile($file);
                    }
                    $data['status'] = self::API_OK;
                    $data['detail'] = $product;
                } else {
                    $data['error'] = $product->flattenErrors;
                }
                $items = Json::decode($post['ProductVariant']['items']);
                if (! empty($items)) {
                    foreach ($items as $item) {
                        $productVariant->color_id = $item['color_id'];
                        $productVariant->size_id = $item['size_id'];
                        $productVariant->quantity = $item['quantity'];
                        $productVariant->amount = $item['amount'];
                        if ($productVariant->checkValidData()) {
                            $data['error'] = self::API_NOK;
                            $data['message'] = \Yii::t('app', 'Already Exist');
                            return $this->sendResponse($data);
                        }
                        $result = $productVariant->getIsSaveStatus();
                        $data = array_merge($data, $result);
                    }
                } else {
                    $data['error'] = \Yii::t('app', 'Data Not Posted');
                }
            } else {
                $data['error_post'] = 'No Data Posted';
            }
        }
        
        return $this->sendResponse($data);
    }

    /**
     * Deletes an existing Product model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     *
     * @return mixed
     */
    public function actionDelete($id)
    {
        $data = [];
        $model = Product::findOne([
            'id' => $id
        ]);
        if (empty($model))
            throw new NotFoundHttpException('The requested page does not exist.');
        
        $data = $model->getIsDeleteStatus();
        return $this->sendResponse($data);
    }

    /*
     * public function actionDelete($id)
     * {
     * return $this->txDelete($id, "app\models\Product");
     * }
     */
    public function actionAddToCart()
    {
        $data = [];
        $params = \Yii::$app->request->bodyParams;
        $model = Cart::find()->where([
            'created_by_id' => \Yii::$app->user->id
        ])->one();
        if (empty($model))
            $model = (new Cart())->createNewCart();
        
        if ($model->isProductInStock($params['CartItem']['product_variant_id'])) {
            $cartitem = new CartItem();
            $cartitem->cart_id = $model->id;
            $cartitem->vendor_id = $model->getVendorId($params['CartItem']['product_variant_id']);
            
            $cartitem->product_variant_id = $params['CartItem']['product_variant_id'];
            $cartitem->product_id = $params['CartItem']['product_id'];
            $cartitem->quantity = $params['CartItem']['quantity'];
            $cartitem->amount = $params['CartItem']['amount'];
            
            $data = $cartitem->getIsSaveStatus(true);
        } else {
            $data['status'] = self::API_NOK;
            $data['message'] = \Yii::t('app', 'Sorry, Product Out Of Stock');
        }
        return $this->sendResponse($data);
    }

    public function actionCartItemList($page = null)
    {
        $data = [];
        $limit = [];
        $query = CartItem::find()->where([
            'created_by_id' => \Yii::$app->user->id
        ]);
        
        $dataProvider = new \yii\data\ActiveDataProvider([
            'query' => $query,
            'pagination' => [
                'pageSize' => '20',
                'page' => $page
            ]
        ]);
        if (count($dataProvider->models) > 0) {
            foreach ($dataProvider->models as $model) {
                $list[] = $model->asJson();
               
            }
            $data['status'] = self::API_OK;
            $data['detail'] = $list;
            
            $data['pageCount'] = isset($page) ? $page : '0';
            $data['totalPage'] = isset($dataProvider->pagination->pageCount) ? $dataProvider->pagination->pageCount : '0';
        } else {
            $data['error'] = \Yii::t('app', 'No Item in your cart list');
        }
        return $this->sendResponse($data);
    }

    public function actionGetNewProducts($page = null)
    {
        $data = [];
        $query = Product::find()->where([
            'state_id' => Product::STATE_INACTIVE
        ])->orderBy('id desc');
        
        $data = Product::sendApiDataInList($page, $query, true);
        return $this->sendResponse($data);
    }

    public function actionAddToOrder()
    {
        $data = [];
        $params = \Yii::$app->request->bodyParams;
        $model = new ShippingAddress();
        $user = new User();
        if ($model->load(\Yii::$app->request->post())) {
            
            $paymentMode = isset($_POST['ShippingAddress']['payment_mode']) ? $_POST['ShippingAddress']['payment_mode'] : 0;
            
            if ($model->save()) {
                $cart = Cart::find()->where([
                    'created_by_id' => \Yii::$app->user->id
                ])->one();
                
                if (! empty($cart)) {
                    
                    $super_order_id = $cart->addToSuperOrder($model->id, $paymentMode);
                    
                    $cartitems = CartItem::find()->where([
                        'cart_id' => $cart->id
                    ]);
                    // print_R($cart->id);die;
                    foreach ($cartitems->each() as $cartitem) {
                        
                        $cartitem->addToOrder($super_order_id);
                    }
                    
                    // $user->sendMail();
                    // $model->SendMail($user);
                    $data['status'] = ApiTxController::API_OK;
                    $data['message'] = \Yii::t('app', 'Order Successfully!!');
                }
            } else {
                $data['error'] = $model->errorsString;
            }
        } else {
            $data['error'] = \Yii::t('app', 'No data posted');
        }
        
        return $this->sendResponse($data);
    }

    public function actionAddBrand()
    {
        $data = [];
        $model = new Brand();
        $file = new File();
        $model->state_id = Product::STATE_ACTIVE;
        if ($model->load(\Yii::$app->request->post())) {
            $data = $model->getIsSaveStatus();
            if ($_FILES) {
                $fileInstance = UploadedFile::getInstances($file, 'filename');
                if (! is_array($fileInstance)) {
                    $fileInstance = [
                        $fileInstance
                    ];
                }
                if ($fileInstance) {
                    foreach ($fileInstance as $instance) {
                        
                        File::add($model, $instance);
                    }
                }
            }
        }
        return $this->sendResponse($data);
    }

    public function actionUpdateBrand($id)
    {
        $data = [];
        $model = Brand::findOne([
            'id' => $id,
            'created_by_id' => \Yii::$app->user->id
        ]);
        if (! empty($model)) {
            $file = File::find()->where([
                'model_id' => $model->id,
                'model_type' => get_class($model)
            ])->one();
            if (empty($file))
                $file = new File();
            
            if ($model->load(\Yii::$app->request->post())) {
                $data = $model->getIsSaveStatus();
                if ($_FILES)
                    $model->saveFile($file, $file);
            } else {
                $data['status'] = self::API_NOK;
                $data['error_post'] = 'No Data Posted';
            }
        } else {
            $data['status'] = self::API_NOK;
            $data['error_post'] = 'You are not allowed to perform this action';
        }
        
        return $this->sendResponse($data);
    }

    public function actionDeleteBrand($id)
    {
        $data = [];
        $model = Brand::findOne([
            'id' => $id
        ]);
        if (empty($model))
            throw new NotFoundHttpException('The requested page does not exist.');
        
        $data = $model->getIsDeleteStatus();
        return $this->sendResponse($data);
    }

    public function actionCategoryList($page = null)
    {
        $data = [];
        $query = Category::find()->orderBy('id desc');
        $data = Category::sendApiDataInList($page, $query);
        return $this->sendResponse($data);
    }

    public function actionFilter($page = 0, $size = [], $color = [], $brand = [], $start_price = null, $end_price = null)
    {
        $data = [];
        $query = Product::find()->alias('p')
            ->joinWith('productVariants as pv')
            ->andFilterWhere([
            'AND',
            [
                'pv.size_id' => $size
            ],
            [
                'p.brand_id' => $brand
            ],
            [
                'pv.color_id' => $color
            ],
            [
                'between',
                'pv.amount',
                $start_price,
                $end_price
            ]
        ]);
        
        $data = Product::sendApiDataInList($page, $query, true);
        return $this->sendResponse($data);
    }

    public function actionGetBrandList($catid, $page = null)
    {
        $data = [];
        $query = Brand::find()->where([
            'category_id' => $catid
        ])->orderBy('id desc');
        
        if (User::isVendor()) {
            $query->andWhere([
                'created_by_id' => \Yii::$app->user->id
            ]);
        }
        $data = Brand::sendApiDataInList($page, $query, true);
        return $this->sendResponse($data);
    }

    public function actionColorList($page = null)
    {
        $data = [];
        $query = Color::find()->orderBy('id desc');
        $data = Color::sendApiDataInList($page, $query);
        return $this->sendResponse($data);
    }

    public function actionSizeList($page = null)
    {
        $data = [];
        $query = Size::find()->orderBy('id desc');
        $data = Size::sendApiDataInList($page, $query);
        return $this->sendResponse($data);
    }

    public function actionGetAllBrandList($page = null)
    {
        $data = [];
        $query = Brand::find()->orderBy('id desc');
        $data = Brand::sendApiDataInList($page, $query);
        
        return $this->sendResponse($data);
    }

    public function actionGetCountry($page = null)
    {
        $data = [];
        $query = Country::find();
        $data = Country::sendApiDataInList($page, $query, true);
        return $this->sendResponse($data);
    }

    public function actionGetState($page = null, $countryId)
    {
        $data = [];
        $query = State::find()->where([
            'country_id' => $countryId
        ]);
        
        $data = Country::sendApiDataInList($page, $query, true);
        return $this->sendResponse($data);
    }

    public function actionGetProductList($page = null, $brand_id = null, $category_id = null)
    {
        $data = [];
        $query = Product::find();
        if (! is_null($brand_id)) {
            $query->andWhere([
                'brand_id' => $brand_id
            ]);
        }
        if (! is_null($category_id)) {
            $query->andWhere([
                'category_id' => $category_id
            ]);
        }
        $data = Product::sendApiDataInList($page, $query, true);
        return $this->sendResponse($data);
    }

    /**
     * get product list from variant table
     *
     * @param integer $brandid
     * @param integer $page
     * @return Product
     */
    public function actionGetMyproductList($brandid, $page = null)
    {
        $data = [];
        $query = Product::my()->where([
            'brand_id' => $brandid
        ]);
        $data = Product::sendApiDataInList($page, $query, true);
        return $this->sendResponse($data);
    }

    public function actionDeleteProductImage($id)
    {
        $data = [];
        $file = File::findOne([
            'id' => $id
        ]);
        if (! empty($file)) {
            $product = Product::find()->where([
                'id' => $file->model_id,
                'created_by_id' => \Yii::$app->user->id
            ]);
            if (! empty($product)) {
                $data = $file->getIsDeleteStatus();
            } else {
                $data['file'] = \Yii::t('app', 'Not Authorized');
            }
        } else {
            $data['file'] = \Yii::t('app', 'File Not Found');
        }
        return $this->sendResponse($data);
    }

    public function actionDeleteVariant($id)
    {
        $data = [];
        $variant = ProductVariant::findOne($id);
        if (! empty($variant)) {
            if ($variant->delete()) {
                $data['status'] = self::API_OK;
                $data['message'] = \Yii::t('app', 'Variant Deleted Successfully');
                $data['detail'] = isset($variant->product) ? $variant->product->asJson(true) : "";
            }
        } else {
            $data['error'] = \Yii::t('app', 'No data Found');
        }
        return $this->sendResponse($data);
    }

    public function actionUpdateVariant($id)
    {
        $data = [];
        $variant = ProductVariant::findOne($id);
        if (! empty($variant)) {
            if ($variant->load(\Yii::$app->request->post())) {
                if ($variant->checkValidData($id)) {
                    $data['error'] = self::API_NOK;
                    $data['message'] = \Yii::t('app', 'Already Exist');
                    return $this->sendResponse($data);
                }
                if ($variant->save()) {
                    $data['status'] = self::API_OK;
                    $data['detail'] = isset($variant->product) ? $variant->product->asJson(true) : "";
                } else {
                    $data['error'] = $variant->errorsString;
                }
            } else {
                $data['error'] = \Yii::t('app', 'No data posted');
            }
        } else {
            $data['error'] = \Yii::t('app', 'No data found');
        }
        return $this->sendResponse($data);
    }

    public function actionAddProductImage($id)
    {
        $data = [];
        $product = Product::findOne($id);
        $file = new File();
        if (! empty($product)) {
            if ($_FILES) {
                $product->saveFile($file);
                
                $data['status'] = self::API_OK;
                $data['message'] = \Yii::t('app', 'Image added successfully');
                $data['detail'] = $product->asJson(true);
            } else {
                $data['error'] = \Yii::t('app', 'No data posted');
            }
        } else {
            $data['error'] = \Yii::t('app', 'No data found');
        }
        
        return $this->sendResponse($data);
    }

    public function actionDeleteCartItem($id)
    {
        $data = [];
        $item = CartItem::findOne($id);
        if (! empty($item)) {
            if ($item->delete()) {
                $data['status'] = self::API_OK;
                $data['message'] = \Yii::t('app', 'Item Deleted Successfully');
                $data['detail'] = $item->asJson();
            }
        } else {
            $data['error'] = \Yii::t('app', 'No data Found');
        }
        return $this->sendResponse($data);
    }

    public function actionUpdateCartItem($id)
    {
        $data = [];
        
        $item = CartItem::findOne($id);
        if (! empty($item)) {
            if ($item->load(\Yii::$app->request->post())) {
                
                if ($item->save()) {
                    $carts = CartItem::find()->where([
                        'created_by_id' => \Yii::$app->user->id
                    ])->all();
                    if (! empty($carts)) {
                        foreach ($carts as $cart) {
                            $list[] = $cart->asJson(true);
                        }
                        $data['status'] = self::API_OK;
                        $data['detail'] = $list;
                    } else {
                        $data['error'] = \Yii::t('app', 'No data found');
                    }
                } else {
                    $data['error'] = $item->errorsString;
                }
            } else {
                $data['error'] = \Yii::t('app', 'No data posted');
            }
        } else {
            $data['error'] = \Yii::t('app', 'No data Found');
        }
        return $this->sendResponse($data);
    }

    public function actionBrandSearch($page = null)
    {
        $list = [];
        $data = [];
        $params = Yii::$app->request->bodyParams;
        
        $model = new \app\models\search\Brand();
        $dataProvider = $model->searchFilter(\Yii::$app->request->post(), $page);
        
        if (count($dataProvider->models) > 0) {
            
            foreach ($dataProvider->models as $mod) {
                $list[] = $mod->asJson(false);
            }
            $data['status'] = self::API_OK;
            $data['details'] = $list;
            $data['pageCount'] = isset($page) ? $page : '0';
            $data['pageSize'] = $dataProvider->pagination->pageSize;
            $data['totalPage'] = isset($dataProvider->pagination->pageCount) ? $dataProvider->pagination->pageCount : '0';
        } else {
            $data['error'] = \yii::t('app', 'No User Found');
        }
        return $this->sendResponse($data);
    }

    public function actionCategorySearch($page = null)
    {
        $list = [];
        $data = [];
        $params = Yii::$app->request->bodyParams;
        
        $model = new \app\models\search\Category();
        $dataProvider = $model->searchFilter(\Yii::$app->request->post(), $page);
        
        if (count($dataProvider->models) > 0) {
            
            foreach ($dataProvider->models as $mod) {
                $list[] = $mod->asJson(false);
            }
            $data['status'] = self::API_OK;
            $data['details'] = $list;
            $data['pageCount'] = isset($page) ? $page : '0';
            $data['pageSize'] = $dataProvider->pagination->pageSize;
            $data['totalPage'] = isset($dataProvider->pagination->pageCount) ? $dataProvider->pagination->pageCount : '0';
        } else {
            $data['error'] = \yii::t('app', 'No User Found');
        }
        return $this->sendResponse($data);
    }

    public function actionCountry()
    {
        $list = [];
        $data = [];
        $params = Yii::$app->request->bodyParams;
        $model = Country::find()->all();
        print_r($model);
        die();
    }

    public function actionHomeSearch($page = null)
    {
        $list = [];
        $data = [];
        $list1 = [];
        $title = \Yii::$app->request->post('title');
        if (empty($title)) {
            $data['error'] = \Yii::t('app', 'Please enter any value');
            return $this->sendResponse($data);
        }
        $query = Category::find()->where([
            'like',
            'title',
            $title . '%',
            false
        ]);
        $dataProvider = new \yii\data\ActiveDataProvider([
            'query' => $query,
            'pagination' => [
                'pageSize' => '20',
                'page' => $page
            ]
        ]);
        
        if (! empty($dataprovider->getCount() > 0)) {
            foreach ($dataprovider->models as $model) {
                $list[] = $model->asJson();
            }
        }
        
        $query1 = Brand::find()->where([
            'like',
            'title',
            $title . '%',
            false
        ]);
        $dataProvider1 = new \yii\data\ActiveDataProvider([
            'query' => $query1,
            'pagination' => [
                'pageSize' => '20',
                'page' => $page
            ]
        ]);
        
        if (! empty($dataprovider1->getCount() > 0)) {
            foreach ($dataprovider1->models as $model1) {
                $list1[] = $model1->asJson();
            }
        }
        
        if (! empty($list) || ! empty($list1)) {
            $data['pageSize'] = $dataprovider->pagination->pageSize;
            $data['pageCount'] = $dataprovider->pagination->pageCount;
            $data['status'] = self::API_OK;
            $data['detail'] = array_merge($list, $list1);
        } else {
            $data['error'] = \yii::t('app', 'No Data Found');
        }
        
        return $this->sendResponse($data);
    }

    public function actionVendorProductList($id, $page = null)
    {
        $data = [];
        $subquery = User::findOne($id);
        if (! empty($subquery)) {
            
            $query = Product::find()->where([
                'created_by_id' => $id
            ]);
            $dataProvider = new \yii\data\ActiveDataProvider([
                'query' => $query,
                'pagination' => [
                    'pageSize' => '20',
                    'page' => $page
                ]
            ]);
            if (count($dataProvider->models) > 0) {
                foreach ($dataProvider->models as $model) {
                    $list[] = $model->asJson(true);
                }
                $data['status'] = self::API_OK;
                $data['detail'] = $list;
                $data['pageCount'] = isset($page) ? $page : '0';
                $data['totalPage'] = isset($dataProvider->pagination->pageCount) ? $dataProvider->pagination->pageCount : '0';
            } else {
                $data['error'] = \Yii::t('app', 'No product found');
            }
        } else {
            $data['error'] = \Yii::t('app', 'No user found');
        }
        
        return $this->sendResponse($data);
    }
}
