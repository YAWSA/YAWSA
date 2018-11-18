<?php
namespace app\modules\api\controllers;

use Yii;
use yii\filters\AccessControl;
use yii\filters\AccessRule;

/**
 * CartController implements the API actions for Cart model.
 */
class CartController extends ApiTxController
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
     * Lists all Cart models.
     *
     * @return mixed
     */
    public function actionIndex()
    {
        return $this->txindex("app\models\Cart");
    }

    /**
     * Displays a single app\models\Cart model.
     *
     * @return mixed
     */
    public function actionGet($id)
    {
        return $this->txget($id, "app\models\Cart");
    }

    /**
     * Creates a new Cart model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     *
     * @return mixed
     */
    public function actionAdd()
    {
        return $this->txSave("app\models\Cart");
    }

    /**
     * Updates an existing Cart model.
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
     * Deletes an existing Cart model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     *
     * @return mixed
     */
    public function actionDelete($id)
    {
        return $this->txDelete($id, "app\models\Cart");
    }
}
