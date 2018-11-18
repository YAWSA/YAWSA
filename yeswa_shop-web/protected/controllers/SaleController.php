<?php
/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
namespace app\controllers;

use Yii;
use app\models\Sale;
use app\models\search\Sale as SaleSearch;
use app\components\TController;
use yii\web\NotFoundHttpException;
use yii\filters\AccessControl;
use yii\filters\AccessRule;
use app\models\User;
use yii\web\HttpException;
use app\components\TActiveForm;
use app\models\Brand;
use app\models\Product;
use yii\web\UploadedFile;
use yii\db\ActiveRecord;

/**
 * SaleController implements the CRUD actions for Sale model.
 */
class SaleController extends TController
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
                            'view',
                            'update',
                            'delete',
                            'ajax',
                            'mass',
                            'brand-list',
                            'product-list'
                        ],
                        'allow' => true,
                        'matchCallback' => function () {
                            return User::isAdmin();
                        }
                    ],
                    [
                        'actions' => [
                            
                            'view'
                        ],
                        'allow' => true,
                        'roles' => [
                            '?',
                            '*'
                        ]
                    ]
                ]
            ],
            'verbs' => [
                'class' => \yii\filters\VerbFilter::className(),
                'actions' => [
                    'delete' => [
                        'post'
                    ]
                ]
            ]
        ];
    }

    /**
     * Lists all Sale models.
     *
     * @return mixed
     */
    public function actionIndex()
    {
        $searchModel = new SaleSearch();
        $dataProvider = $searchModel->search(Yii::$app->request->queryParams);
        $this->updateMenuItems();
        return $this->render('index', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider
        ]);
    }
    
    public function actionMass($action = 'delete')
    {
        \Yii::$app->response->format = 'json';
        $response['status'] = 'NOK';
        $Ids = Yii::$app->request->post('ids', []);
        
        if (! empty($Ids)) {
            foreach ($Ids as $Id) {
                $model = Sale::findOne($Id);
                if (! empty($model) && ($model instanceof ActiveRecord)) {
                    if ($action == 'delete') {
                        if (($model instanceof User) && ($model->id == \Yii::$app->user->id)) {
                            $response['status'] = 'NOK';
                        } else {
                            $model->delete();
                        }
                    }
                }
            }
            $response['status'] = 'OK';
        }
        
        return $response;
    }

    /**
     * Displays a single Sale model.
     *
     * @param integer $id
     * @return mixed
     */
    public function actionView($id)
    {
        $model = $this->findModel($id);
        $this->updateMenuItems($model);
        return $this->render('view', [
            'model' => $model
        ]);
    }

    /**
     * Creates a new Sale model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     *
     * @return mixed
     */
    public function actionAdd()
    {
        $model = new Sale();
        $model->loadDefaultValues();
        $model->state_id = Sale::STATE_ACTIVE;
        $post = \yii::$app->request->post();
        if (\yii::$app->request->isAjax && $model->load($post)) {
            \yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
            return TActiveForm::validate($model);
        }
        if ($model->load($post)) {
            $image = UploadedFile::getInstance($model, 'image_file');
            if (! empty($image)) {
                $image->saveAs(UPLOAD_PATH . $image->baseName . '.' . $image->extension);
                $model->image_file = $image->baseName . '.' . $image->extension;
            }
            if ($model->type_id == Sale::PERCENT_DISCOUNT) {
                $model->type_id = Sale::PERCENT_DISCOUNT;
            } else {
                $model->type_id = Sale::BUY_AND_GET;
            }
            $model->model_type = Product::className();
            if ($model->save()) {
                return $this->redirect($model->getUrl());
            }
        }
        $this->updateMenuItems();
        return $this->render('add', [
            'model' => $model
        ]);
    }

    /**
     * Updates an existing Sale model.
     * If update is successful, the browser will be redirected to the 'view' page.
     *
     * @param integer $id
     * @return mixed
     */
    public function actionUpdate($id)
    {
        $model = $this->findModel($id);
        $old_image = $model->image_file;
        $post = \yii::$app->request->post();
        if (\yii::$app->request->isAjax && $model->load($post)) {
            \yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
            return TActiveForm::validate($model);
        }
        if ($model->load($post)) {
            $model->image_file = $old_image;
            $model->saveUploadedFile($model, 'image_file', $old_image);
            if ($model->save()) {
                return $this->redirect($model->getUrl());
            }
        }
        $this->updateMenuItems($model);
        return $this->render('update', [
            'model' => $model
        ]);
    }

    /**
     * Deletes an existing Sale model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     *
     * @param integer $id
     * @return mixed
     */
    public function actionDelete($id)
    {
        $model = $this->findModel($id);
        
        $model->delete();
        return $this->redirect([
            'index'
        ]);
    }

    public function actionBrandList($id)
    {
        $data = [];
        \Yii::$app->response->format = 'json';
        $response['status'] = 'NOK';
        if ($id) {
            $brands = Brand::find()->select([
                'id',
                'title'
            ])
                ->where([
                'category_id' => $id
            ])
                ->all();
            if (! empty($brands)) {
                foreach ($brands as $brand) {
                    
                    $response['status'] = 'OK';
                    $data[$brand->id] = $brand->title;
                }
                
                $response['brand'] = $data;
            }
        }
        return $response;
    }

    public function actionProductList($id)
    {
        $data = [];
        \Yii::$app->response->format = 'json';
        $response['status'] = 'NOK';
        if ($id) {
            $subquery = Sale::find()->select([
                'model_id'
            ])->column();
            $products = Product::find()->select([
                'id',
                'title'
            ])
                ->andWhere([
                'NOT IN',
                'id',
                $subquery
            ])
                ->andWhere([
                'brand_id' => $id
            ])
                ->all();
            if (! empty($products)) {
                foreach ($products as $product) {
                    
                    $response['status'] = 'OK';
                    $data[$product->id] = $product->title;
                }
                
                $response['product'] = $data;
            }
        }
        return $response;
    }

    /**
     * Finds the Sale model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     *
     * @param integer $id
     * @return Sale the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id, $accessCheck = true)
    {
        if (($model = Sale::findOne($id)) !== null) {
            
            if ($accessCheck && ! ($model->isAllowed()))
                throw new HttpException(403, Yii::t('app', 'You are not allowed to access this page.'));
            
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }

    protected function updateMenuItems($model = null)
    {
        switch (\Yii::$app->controller->action->id) {
            
            case 'add':
                {
                    $this->menu['manage'] = [
                        'label' => '<span class="glyphicon glyphicon-list"></span>',
                        'title' => Yii::t('app', 'Manage'),
                        'url' => [
                            'index'
                        ]
                        // 'visible' => User::isAdmin ()
                    ];
                }
                break;
            case 'index':
                {
                    $this->menu['add'] = [
                        'label' => '<span class="glyphicon glyphicon-plus"></span>',
                        'title' => Yii::t('app', 'Add'),
                        'url' => [
                            'add'
                        ]
                        // 'visible' => User::isAdmin ()
                    ];
                }
                break;
            case 'update':
                {
                    $this->menu['add'] = [
                        'label' => '<span class="glyphicon glyphicon-plus"></span>',
                        'title' => Yii::t('app', 'add'),
                        'url' => [
                            'add'
                        ]
                        // 'visible' => User::isAdmin ()
                    ];
                    $this->menu['manage'] = [
                        'label' => '<span class="glyphicon glyphicon-list"></span>',
                        'title' => Yii::t('app', 'Manage'),
                        'url' => [
                            'index'
                        ]
                        // 'visible' => User::isAdmin ()
                    ];
                }
                break;
            default:
            case 'view':
                {
                    $this->menu['manage'] = [
                        'label' => '<span class="glyphicon glyphicon-list"></span>',
                        'title' => Yii::t('app', 'Manage'),
                        'url' => [
                            'index'
                        ]
                        // 'visible' => User::isAdmin ()
                    ];
                    if ($model != null) {
                        $this->menu['update'] = [
                            'label' => '<span class="glyphicon glyphicon-pencil"></span>',
                            'title' => Yii::t('app', 'Update'),
                            'url' => $model->getUrl()
                            // 'visible' => User::isAdmin ()
                        ];
                        $this->menu['delete'] = [
                            'label' => '<span class="glyphicon glyphicon-trash"></span>',
                            'title' => Yii::t('app', 'Delete'),
                            'url' => $model->getUrl()
                            // 'visible' => User::isAdmin ()
                        ];
                    }
                }
        }
    }
}
