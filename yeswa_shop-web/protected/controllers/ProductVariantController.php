<?php

/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
namespace app\controllers;

use app\components\TActiveForm;
use app\components\TController;
use app\models\Brand;
use app\models\ProductVariant;
use app\models\search\ProductVariant as ProductVariantSearch;
use Yii;
use yii\filters\AccessControl;
use yii\filters\AccessRule;
use yii\web\HttpException;
use yii\web\NotFoundHttpException;
use app\models\File;
use yii\helpers\FileHelper;
use yii\web\UploadedFile;
use yii\helpers\Url;
use yii\db\ActiveRecord;

/**
 * ProductVariantController implements the CRUD actions for ProductVariant model.
 */
class ProductVariantController extends TController {
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
												'mass',
												'get-brand' 
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
	 * Lists all ProductVariant models.
	 *
	 * @return mixed
	 */
	public function actionIndex() {
		$searchModel = new ProductVariantSearch ();
		$dataProvider = $searchModel->search ( Yii::$app->request->queryParams );
		$this->updateMenuItems ();
		return $this->render ( 'index', [ 
				'searchModel' => $searchModel,
				'dataProvider' => $dataProvider 
		] );
	}
	
	/**
	 * Displays a single ProductVariant model.
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
	            $model = ProductVariant::findOne($Id);
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
	 * Creates a new ProductVariant model.
	 * If creation is successful, the browser will be redirected to the 'view' page.
	 *
	 * @return mixed
	 */
	public function actionAdd($id) {
		$model = new ProductVariant ();
		
		$model->loadFaker ();
		$model->product_id = \Yii::$app->request->get ( 'id' ) ?? null;
		$model->loadDefaultValues ();
		$model->state_id = ProductVariant::STATE_ACTIVE;
		$post = \yii::$app->request->post ();
		if (\yii::$app->request->isAjax && $model->load ( $post )) {
			\yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
			return TActiveForm::validate ( $model );
		}
		if ($model->load ( $post )) {
			if ($model->checkValidData ( $model->product_id )) {
				$model->addError ( 'amount', 'This variant already exists' );
				return $this->render ( 'add', [ 
						'model' => $model 
				] );
			}
			if ($model->save ()) {
				\Yii::$app->getSession ()->setFlash ( 'success', \Yii::t ( 'app', 'Successfully Added.' ) );
				return $this->redirect ( [ 
						'product/view',
						'id' => $model->product_id 
				] );
			}
		}
		$this->updateMenuItems ();
		return $this->render ( 'add', [ 
				'model' => $model 
		] );
	}
	
	/**
	 * Updates an existing ProductVariant model.
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
		if ($model->load ( $post )) {
			if ($model->checkValidData ( $model->product_id )) {
				$model->addError ( 'amount', 'This variant already exists' );
				return $this->render ( 'add', [ 
						'model' => $model 
				] );
			}
			if ($model->save ()) {
				return $this->redirect ( [ 
						'product/view',
						'id' => $model->product_id 
				] );
			}
		}
		$this->updateMenuItems ( $model );
		return $this->render ( 'update', [ 
				'model' => $model 
		
		] );
	}
	
	/**
	 * Deletes an existing ProductVariant model.
	 * If deletion is successful, the browser will be redirected to the 'index' page.
	 *
	 * @param integer $id        	
	 * @return mixed
	 */
	public function actionDelete($id) {
		$model = $this->findModel ( $id );
		
		$model->delete ();
		
		return $this->redirect ( \Yii::$app->request->referrer );
	}
	
	/**
	 * Finds the ProductVariant model based on its primary key value.
	 * If the model is not found, a 404 HTTP exception will be thrown.
	 *
	 * @param integer $id        	
	 * @return ProductVariant the loaded model
	 * @throws NotFoundHttpException if the model cannot be found
	 */
	protected function findModel($id, $accessCheck = true) {
		if (($model = ProductVariant::findOne ( $id )) !== null) {
			
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
	public function actionGetBrand() {
		\yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
		$id = \Yii::$app->request->post () ['id'];
		$model = Brand::find ()->where ( [ 
				'category_id' => $id 
		] );
		if (! empty ( $model )) {
			$list = [ ];
			foreach ( $model->each () as $brand ) {
				$list [$brand->id] = $brand->title;
			}
			$data ['status'] = 'OK';
			$data ['data'] = $list;
		}
		return $data;
	}
}
