<?php

/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
namespace app\controllers;

use Yii;
use app\models\Order;
use app\models\search\Order as OrderSearch;
use app\components\TController;
use yii\web\NotFoundHttpException;
use yii\filters\AccessControl;
use yii\filters\AccessRule;
use app\models\User;
use yii\web\HttpException;
use app\components\TActiveForm;
use yii\db\ActiveRecord;

/**
 * OrderController implements the CRUD actions for Order model.
 */
class OrderController extends TController {
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
												'view',
												'update',
												'delete',
												'ajax',
												'mass' 
										],
										'allow' => true,
										'roles' => [ 
												'@' 
										] 
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
						'class' => \yii\filters\VerbFilter::className (),
						'actions' => [ 
								'delete' => [ 
										'post' 
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
		$searchModel = new OrderSearch ();
		$dataProvider = $searchModel->search ( Yii::$app->request->queryParams );
		$this->updateMenuItems ();
		return $this->render ( 'index', [ 
				'searchModel' => $searchModel,
				'dataProvider' => $dataProvider 
		] );
	}
	
	public function actionMass($action = 'delete')
	{
	    \Yii::$app->response->format = 'json';
	    $response['status'] = 'NOK';
	    $Ids = Yii::$app->request->post('ids', []);
	    
	    if (! empty($Ids)) {
	        foreach ($Ids as $Id) {
	            $model = Order::findOne($Id);
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
	 * Displays a single Order model.
	 *
	 * @param integer $id        	
	 * @return mixed
	 */
	public function actionView($id) {
		$model = $this->findModel ( $id );
		$this->updateMenuItems ( $model );
		return $this->render ( 'view', [ 
				'model' => $model 
		] );
	}
	
	/**
	 * Creates a new Order model.
	 * If creation is successful, the browser will be redirected to the 'view' page.
	 *
	 * @return mixed
	 */
	/*
	 * public function actionAdd() {
	 * $model = new Order ();
	 * $model->loadDefaultValues ();
	 * $model->state_id = Order::STATE_ACTIVE;
	 * $post = \yii::$app->request->post ();
	 * if (\yii::$app->request->isAjax && $model->load ( $post )) {
	 * \yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
	 * return TActiveForm::validate ( $model );
	 * }
	 * if ($model->load ( $post ) && $model->save ()) {
	 * return $this->redirect ( [
	 * 'view',
	 * 'id' => $model->id
	 * ] );
	 * }
	 * $this->updateMenuItems ();
	 * return $this->render ( 'add', [
	 * 'model' => $model
	 * ] );
	 * }
	 */
	
	/**
	 * Updates an existing Order model.
	 * If update is successful, the browser will be redirected to the 'view' page.
	 *
	 * @param integer $id        	
	 * @return mixed
	 */
	public function actionUpdate($id) {
		$model = $this->findModel ( $id );
		
		$post = \yii::$app->request->post ();
		if (\yii::$app->request->isAjax && $model->load ( $post )) {
			\yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
			return TActiveForm::validate ( $model );
		}
		if ($model->load ( $post ) && $model->save ()) {
			return $this->redirect ( [ 
					'view',
					'id' => $model->id 
			] );
		}
		$this->updateMenuItems ( $model );
		return $this->render ( 'update', [ 
				'model' => $model 
		] );
	}
	
	/**
	 * Deletes an existing Order model.
	 * If deletion is successful, the browser will be redirected to the 'index' page.
	 *
	 * @param integer $id        	
	 * @return mixed
	 */
	public function actionDelete($id) {
		$model = $this->findModel ( $id );
		
		$model->delete ();
		return $this->redirect ( [ 
				'index' 
		] );
	}
	
	/**
	 * Finds the Order model based on its primary key value.
	 * If the model is not found, a 404 HTTP exception will be thrown.
	 *
	 * @param integer $id        	
	 * @return Order the loaded model
	 * @throws NotFoundHttpException if the model cannot be found
	 */
	protected function findModel($id, $accessCheck = true) {
		if (($model = Order::findOne ( $id )) !== null) {
			
			if ($accessCheck && ! ($model->isAllowed ()))
				throw new HttpException ( 403, Yii::t ( 'app', 'You are not allowed to access this page.' ) );
			
			return $model;
		} else {
			throw new NotFoundHttpException ( 'The requested page does not exist.' );
		}
	}
	protected function updateMenuItems($model = null) {
		switch (\Yii::$app->controller->action->id) {
			
			case 'add' :
				{
					$this->menu ['manage'] = array (
							'label' => '<span class="glyphicon glyphicon-list"></span>',
							'title' => Yii::t ( 'app', 'Manage' ),
							'url' => [ 
									'index' 
							] 
						// 'visible' => User::isAdmin ()
					);
				}
				break;
			
			case 'update' :
				{
					$this->menu ['add'] = array (
							'label' => '<span class="glyphicon glyphicon-plus"></span>',
							'title' => Yii::t ( 'app', 'add' ),
							'url' => [ 
									'add' 
							] 
						// 'visible' => User::isAdmin ()
					);
					$this->menu ['manage'] = array (
							'label' => '<span class="glyphicon glyphicon-list"></span>',
							'title' => Yii::t ( 'app', 'Manage' ),
							'url' => [ 
									'index' 
							] 
						// 'visible' => User::isAdmin ()
					);
				}
				break;
			default :
			case 'view' :
				{
					
					if ($model != null) {
						/*
						 * $this->menu ['update'] = array (
						 * 'label' => '<span class="glyphicon glyphicon-pencil"></span>',
						 * 'title' => Yii::t ( 'app', 'Update' ),
						 * 'url' => [
						 * 'update',
						 * 'id' => $model->id
						 * ],
						 * // 'visible' => User::isAdmin ()
						 * );
						 * $this->menu ['delete'] = array (
						 * 'label' => '<span class="glyphicon glyphicon-trash"></span>',
						 * 'title' => Yii::t ( 'app', 'Delete' ),
						 * 'url' => [
						 * 'delete',
						 * 'id' => $model->id
						 * ]
						 * // 'visible' => User::isAdmin ()
						 * );
						 */
					}
				}
		}
	}
}
