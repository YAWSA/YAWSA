<?php

namespace app\modules\api\controllers;

use yii\rest\ActiveController;
use yii\filters\AccessControl;
use yii\filters\AccessRule;
use app\models\Order;
use yii\data\ActiveDataProvider;
use app\modules\api\controllers\ApiTxController;
use app\models\SuperOrder;
use app\models\User;
use app\models\Notification;
use app\models\OrderCancel;

/**
 * OrderController implements the API actions for Order model.
 */
class OrderController extends ApiTxController {
    public function behaviors() {
        return [
            'access' => [
                'class' => AccessControl::className (),
                'ruleConfig' => [
                    'class' => AccessRule::className ()
                ],
                'rules' => [
                    [
                        'actions' => [
                            'index',
                            'add',
                            'get',
                            'update',
                            'delete',
                            'order-list',
                            'change-state',
                            'order-cancel'
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
     * Lists all Order models.
     *
     * @return mixed
     */
    public function actionIndex() {
        return $this->txindex ( "app\models\Order" );
    }
    
    /**
     * Displays a single app\models\Order model.
     *
     * @return mixed
     */
    public function actionGet($id) {
        return $this->txget ( $id, "app\models\Order" );
    }
    
    /**
     * Creates a new Order model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     *
     * @return mixed
     */
    public function actionAdd() {
        return $this->txSave ( "app\models\Order" );
    }
    
    /**
     * Updates an existing Order model.
     * If update is successful, the browser will be redirected to the 'view' page.
     *
     * @return mixed
     */
    public function actionUpdate($id) {
        $data = [ ];
        $model = $this->findModel ( $id );
        if ($model->load ( Yii::$app->request->post () )) {
            
            if ($model->save ()) {
                
                $data ['status'] = self::API_OK;
                
                $data ['detail'] = $model;
            } else {
                $data ['error'] = $model->flattenErrors;
            }
        } else {
            $data ['error_post'] = 'No Data Posted';
        }
        
        return $this->sendResponse ( $data );
    }
    
    /**
     * Deletes an existing Order model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     *
     * @return mixed
     */
    public function actionDelete($id) {
        return $this->txDelete ( $id, "app\models\Order" );
    }
    public function actionOrderList($page = null) {
        $data = [ ];
        if(User::isUser()){
            $flag=false;
            $query = SuperOrder::find ()->where ( [
                'created_by_id' => \Yii::$app->user->id
            ] );
        }else{
            $flag=true;
            $query=Order::find()->where(['vendor_id'=>\Yii::$app->user->id]);
        }
        
        /* $query = Order::find ();
        if (User::isUser ()) {
            
            $query->andWhere ( [
                'in',
                'super_order_id',
                $subquery
            ] );
        } else {
            $query->andWhere ( [
                'vendor_id' => \Yii::$app->user->id
            ] );
        } */
        
        $dataProvider = new \yii\data\ActiveDataProvider ( [
            'query' => $query,
            'pagination' => [
                'pageSize' => '20',
                'page' => $page
            ]
        ] );
        if (count ( $dataProvider->models ) > 0) {
            foreach ( $dataProvider->models as $model ) {
                $list [] = $model->asJson ( $flag );
            }
            $data ['status'] = self::API_OK;
            $data ['detail'] = $list;
            $data ['pageCount'] = isset ( $page ) ? $page : '0';
            $data ['totalPage'] = isset ( $dataProvider->pagination->pageCount ) ? $dataProvider->pagination->pageCount : '0';
        } else {
            $data ['error'] = \Yii::t ( 'app', 'No Data Found' );
        }
        return $this->sendResponse ( $data );
    }
    public function actionChangeState($id) {
        $order = Order::findOne ( $id );
        if (! empty ( $order )) {
            $state = \Yii::$app->request->post ( 'state_id' );
            if (empty ( $state )) {
                $data ['error'] = \Yii::t ( 'app', 'No data posted' );
                return $this->sendResponse ( $data );
            }
            $order->state_id = $state;
            if ($order->save ()) {
                
                $data ['status'] = self::API_OK;
                $data ['message'] = \Yii::t ( 'app', 'State Change Successfully' );
                $data ['detail'] = $order->asJson ( true );
            } else {
                $data ['error'] = $order->errorsString;
            }
        } else {
            $data ['error'] = \Yii::t ( 'app', 'No order found' );
        }
        return $this->sendResponse ( $data );
    }
    public function actionOrderCancel($id) {
        $superorder = SuperOrder::findOne ( $id );
        if (! empty ( $superorder )) {
            $cancel = new OrderCancel ();
            if ($cancel->load ( \Yii::$app->request->post () )) {
                $cancel->order_id = $id;
                if (! $cancel->save ()) {
                    $data ['error'] = $cancel->errorsString;
                    return $this->sendResponse ( $data );
                }
                $superorder->state_id = SuperOrder::STATE_CANCELLED;
                if ($superorder->save ()) {
                    Order::updateAll ( [
                        'state_id' => Order::STATE_CANCEL
                    ], [
                        'super_order_id' => $id
                    ] );
                    
                    $data ['status'] = self::API_OK;
                    $data ['message'] = \Yii::t ( 'app', 'Order Change Successfully' );
                    $data ['detail'] = $superorder->asJson ( true );
                } else {
                    $data ['error'] = $superorder->errorsString;
                }
            } else {
                $data ['error'] = \Yii::t ( 'app', 'No data posted' );
            }
        } else {
            $data ['error'] = \Yii::t ( 'app', 'No order found' );
        }
        return $this->sendResponse ( $data );
    }
}
