<?php
namespace app\modules\api\controllers;

use app\models\Brand;
use app\models\Product;
use Yii;
use yii\filters\AccessControl;
use yii\filters\AccessRule;

/**
 * VendorProfileController implements the API actions for VendorProfile model.
 */
class VendorProfileController extends ApiTxController
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
                            'my-product',
                            'my-brand'
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
     * Lists all VendorProfile models.
     *
     * @return mixed
     */
    public function actionIndex()
    {
        return $this->txindex("app\models\VendorProfile");
    }

    /**
     * Displays a single app\models\VendorProfile model.
     *
     * @return mixed
     */
    public function actionGet($id)
    {
        return $this->txget($id, "app\models\VendorProfile");
    }

    /**
     * Creates a new VendorProfile model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     *
     * @return mixed
     */
    public function actionAdd()
    {
        return $this->txSave("app\models\VendorProfile");
    }

    /**
     * Updates an existing VendorProfile model.
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
     * Deletes an existing VendorProfile model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     *
     * @return mixed
     */
    public function actionDelete($id)
    {
        return $this->txDelete($id, "app\models\VendorProfile");
    }

    public function actionMyBrand($page = null)
    {
        $data = [];
        $query = Brand::my()->orderBy('id desc');
        $data = Brand::sendApiDataInList($page, $query);
        return $this->sendResponse($data);
    }

    public function actionMyProduct($page = null)
    {
        $data = [];
        $query = Product::my()->orderBy('id desc');
        $data = Product::sendApiDataInList($page, $query);
        return $this->sendResponse($data);
    }
}
