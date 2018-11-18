<?php

/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
namespace app\controllers;

use Yii;
use app\models\Product;
use app\models\search\Product as ProductSearch;
use app\components\TController;
use yii\web\NotFoundHttpException;
use yii\filters\AccessControl;
use yii\filters\AccessRule;
use app\models\User;
use yii\web\HttpException;
use app\components\TActiveForm;
use app\models\File;
use yii\web\UploadedFile;
use app\models\CartItem;
use app\models\Cart;
use app\models\OrderItem;
use app\models\Order;
use yii\db\ActiveRecord;

/**
 * ProductController implements the CRUD actions for Product model.
 */
class ProductController extends TController {
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
	 * Lists all Product models.
	 *
	 * @return mixed
	 */
	public function actionIndex() {
		$searchModel = new ProductSearch ();
		$dataProvider = $searchModel->search ( Yii::$app->request->queryParams );
		$this->updateMenuItems ();
		return $this->render ( 'index', [ 
				'searchModel' => $searchModel,
				'dataProvider' => $dataProvider 
		] );
	}
	
	/**
	 * Displays a single Product model.
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
	
	public function actionMass($action = 'delete')
	{
	    \Yii::$app->response->format = 'json';
	    $response['status'] = 'NOK';
	    $Ids = Yii::$app->request->post('ids', []);
	    
	    if (! empty($Ids)) {
	        foreach ($Ids as $Id) {
	            $model = Product::findOne($Id);
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
	 * Creates a new Product model.
	 * If creation is successful, the browser will be redirected to the 'view' page.
	 *
	 * @return mixed
	 */
	public function actionAdd() {
		$model = new Product ();
		$file = new File ();
		$model->loadFaker ();
		$model->loadDefaultValues ();
		$model->state_id = Product::STATE_ACTIVE;
		$post = \yii::$app->request->post ();
		if (\yii::$app->request->isAjax && $model->load ( $post )) {
			\yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
			return TActiveForm::validate ( $model );
		}
		if ($model->load ( $post ) && $model->save ()) {
			if ($_FILES) {
				$model->saveFile ( $file );
			}
			\Yii::$app->session->setFlash ( 'success', \Yii::t ( 'app', 'Successfully Added.' ) );
			return $this->redirect ( [ 
					'view',
					'id' => $model->id 
			] );
		}
		$this->updateMenuItems ();
		return $this->render ( 'add', [ 
				'model' => $model,
				'file' => $file 
		] );
	}
	
	/**
	 * Updates an existing Product model.
	 * If update is successful, the browser will be redirected to the 'view' page.
	 *
	 * @param integer $id        	
	 * @return mixed
	 */
	public function actionUpdate($id) {
		$model = $this->findModel ( $id );
		$previous = File::find ()->where ( [ 
				'model_id' => $model->id,
				'model_type' => get_class ( $model ) 
		] )->all ();
		$file = new File ();
		$post = \yii::$app->request->post ();
		if (\yii::$app->request->isAjax && $model->load ( $post )) {
			\yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
			return TActiveForm::validate ( $model );
		}
		if ($model->load ( $post ) && $model->save ()) {
			if ($_FILES) {
				$model->saveFile ( $file );
			}
			return $this->redirect ( [ 
					'view',
					'id' => $model->id 
			] );
		}
		$this->updateMenuItems ( $model );
		return $this->render ( 'update', [ 
				'model' => $model,
				'file' => $file,
				'previous' => $previous 
		] );
	}
	
	/**
	 * Deletes an existing Product model.
	 * If deletion is successful, the browser will be redirected to the 'index' page.
	 *
	 * @param integer $id        	
	 * @return mixed
	 */
	public function actionDelete($id) {
		$model = $this->findModel ( $id );
		
		$cartItems = CartItem::find ()->where ( [ 
				'product_id' => $id 
		] )->all ();
		if (! empty ( $cartItems )) {
			foreach ( $cartItems as $item ) {
				$item->delete ();
				
				$cart = CartItem::find ()->where ( [ 
						'cart_id' => $item->cart_id 
				] )->count ();
				if ($cart == 0) {
					$deleteCart = Cart::findOne ( $item->cart_id );
					if (! empty ( $deleteCart )) {
						$deleteCart->delete ();
					}
				}
			}
		}
		
		$orderItems = OrderItem::find ()->where ( [
				'product_id' => $id
		] )->all ();
		if (! empty ( $orderItems)) {
			foreach ( $orderItems as $item ) {
				$item->delete ();
				
				$order = OrderItem::find ()->where ( [
						'order_id' => $item->order_id
				] )->count ();
				if ($cart == 0) {
					$deleteCart = Order::findOne ( $item->order_id );
					if (! empty ( $deleteCart )) {
						$deleteCart->delete ();
					}
				}
			}
		}
		$model->delete ();
		return $this->redirect ( [ 
				'index' 
		] );
	}
	
	/**
	 * Finds the Product model based on its primary key value.
	 * If the model is not found, a 404 HTTP exception will be thrown.
	 *
	 * @param integer $id        	
	 * @return Product the loaded model
	 * @throws NotFoundHttpException if the model cannot be found
	 */
	protected function findModel($id, $accessCheck = true) {
		if (($model = Product::findOne ( $id )) !== null) {
			
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
			case 'index' :
				{
					$this->menu ['add'] = array (
							'label' => '<span class="glyphicon glyphicon-plus"></span>',
							'title' => Yii::t ( 'app', 'Add' ),
							'url' => [ 
									'add' 
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
					$this->menu ['manage'] = array (
							'label' => '<span class="glyphicon glyphicon-list"></span>',
							'title' => Yii::t ( 'app', 'Manage' ),
							'url' => [ 
									'index' 
							] 
						// 'visible' => User::isAdmin ()
					);
					if ($model != null) {
						$this->menu ['update'] = array (
								'label' => '<span class="glyphicon glyphicon-pencil"></span>',
								'title' => Yii::t ( 'app', 'Update' ),
								'url' => [ 
										'update',
										'id' => $model->id 
								] 
							// 'visible' => User::isAdmin ()
						);
						/* $this->menu ['delete'] = array (
								'label' => '<span class="glyphicon glyphicon-trash"></span>',
								'title' => Yii::t ( 'app', 'Delete' ),
								'url' => [ 
										'delete',
										'id' => $model->id 
								] 
							// 'visible' => User::isAdmin ()
						); */
					}
				}
		}
	}
}
