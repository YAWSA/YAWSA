<?php
namespace app\modules\api\controllers;

use Yii;
use yii\rest\ActiveController;
use yii\filters\AccessControl;
use yii\filters\AccessRule;
use app\models\ProductFavourite;
use yii\data\ActiveDataProvider;
use app\modules\api\controllers\ApiTxController;

/**
 * ProductFavouriteController implements the API actions for ProductFavourite model.
 */
class ProductFavouriteController extends ApiTxController
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
                            'get-list',
                            'update',
                            'delete'
                        ],
                        'allow' => true,
                        'roles' => [
                            '@'
                        ]
                    ],
                    [
                        'actions' => [
                            'index',
                            'get',
                            'get-list',
                            'update'
                        ],
                        'allow' => true,
                        'roles' => [
                            '?',
                            '*'
                        ]
                    ]
                ]
            ]
        ];
    }

    /**
     * Lists all ProductFavourite models.
     *
     * @return mixed
     */
    public function actionIndex()
    {
        return $this->txindex("app\models\ProductFavourite");
    }

    /**
     * Displays a single app\models\ProductFavourite model.
     *
     * @return mixed
     */
    public function actionGet()
    {
        $id = \Yii::$app->user->id;
        
        $model = ProductFavourite::find()->where([
            'created_by_id' => $id
        ])->all();
        
        if ($model) {
            $data['status'] = self::API_OK;
            $data['detail'] = $model;
        } else {
            $data['status'] = self::API_OK;
            $data['message'] = ' No Product Found';
        }
        return $this->sendResponse($data);
    }
    
    
    
    public function actionGetList($page = 0) {
        $data = [ ];
        $query = ProductFavourite::find ()->where(['created_by_id' => \Yii::$app->user->id]);
        
        $data = ProductFavourite::sendApiDataInList ( $page, $query, true );
            
       
        
        return $this->sendResponse ( $data );
    }

    /**
     * Creates a new ProductFavourite model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     *
     * @return mixed
     */
    public function actionAdd($product_id)
    {
        $data = [];
        
        $model = ProductFavourite::find()->where([
            'product_id' => $product_id,
            'created_by_id' => Yii::$app->user->id
        ])->one();
        
        if ($model) {
            
            $model->delete();
            $data['status'] = self::API_OK;
            $data['message'] = 'Product Unfavourited Succesfully';
        } else {
            
            $model = new ProductFavourite();
            $model->state_id = ProductFavourite::STATE_ACTIVE;
            $model->created_by_id = \Yii::$app->user->id;
            $model->product_id = $product_id;
            
            if ($model->save(false, [
                'state_id',
                'created_by_id',
                'product_id'
            ])) {
                
                $data['status'] = self::API_OK;
                
                $data['detail'] = $model->asJson(true);
                $data['message'] = 'Product favourited Succesfully';
            } else {
                $data['status'] = self::API_OK;
                $data['message'] = $model->getErrorsString();
            }
        }
        return $this->sendResponse($data);
        // return $this->txSave("app\models\ProductFavourite");
    }

    /**
     * Updates an existing ProductFavourite model.
     * If update is successful, the browser will be redirected to the 'view' page.
     *
     * @return mixed
     */
    public function actionUpdate($id)
    {
        $data = [];
        $model = $this->findModel($id);
        if ($model->load(Yii::$app->request->post())) {
            
            if ($model->save()) {
                
                $data['status'] = self::API_OK;
                
                $data['detail'] = $model;
            } else {
                $data['error'] = $model->flattenErrors;
            }
        } else {
            $data['error_post'] = 'No Data Posted';
        }
        
        return $this->sendResponse($data);
    }

    /**
     * Deletes an existing ProductFavourite model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     *
     * @return mixed
     */
    public function actionDelete($id)
    {
        return $this->txDelete($id, "app\models\ProductFavourite");
    }
}
