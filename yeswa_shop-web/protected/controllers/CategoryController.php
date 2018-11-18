<?php

/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
namespace app\controllers;

use Imagine\Image\ManipulatorInterface;
use app\components\TActiveForm;
use app\components\TController;
use app\models\Category;
use app\models\File;
use app\models\User;
use app\models\search\Category as CategorySearch;
use Yii;
use yii\filters\AccessControl;
use yii\filters\AccessRule;
use yii\imagine\Image;
use yii\web\HttpException;
use yii\web\NotFoundHttpException;
use yii\db\ActiveRecord;

/**
 * CategoryController implements the CRUD actions for Category model.
 */
class CategoryController extends TController {
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
												'view',
												'update',
												'delete',
												'ajax',
												'mass',
												'image' 
										],
										'allow' => true,
										'roles' => [ 
												'@' 
										] 
								],
								[ 
										'actions' => [ 
												'image',
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
	 * Lists all Category models.
	 *
	 * @return mixed
	 */
	public function actionIndex() {
		$searchModel = new CategorySearch ();
		$dataProvider = $searchModel->search ( Yii::$app->request->queryParams );
		$this->updateMenuItems ();
		$model = new Category ();
		$file = new File ();
		$model->loadFaker ();
		$model->loadDefaultValues ();
		$model->state_id = Category::STATE_ACTIVE;
		$post = \yii::$app->request->post ();
		if (\yii::$app->request->isAjax && $model->load ( $post )) {
			\yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
			return TActiveForm::validate ( $model );
		}
		if ($model->load ( $post ) && $model->save ()) {
			if ($_FILES)
				$model->saveFile ( $file );
			
			\Yii::$app->session->setFlash ( 'success', \Yii::t ( 'app', 'Successfully Added.' ) );
			return $this->refresh ();
		}
		
		return $this->render ( 'index', [ 
				'searchModel' => $searchModel,
				'dataProvider' => $dataProvider,
				'model' => $model,
				'file' => $file 
		] );
	}
	
	public function actionMass($action = 'delete')
	{
	    \Yii::$app->response->format = 'json';
	    $response['status'] = 'NOK';
	    $Ids = Yii::$app->request->post('ids', []);
	    
	    if (! empty($Ids)) {
	        foreach ($Ids as $Id) {
	            $model = Category::findOne($Id);
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
	 * Displays a single Category model.
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
	 * Updates an existing Category model.
	 * If update is successful, the browser will be redirected to the 'view' page.
	 *
	 * @param integer $id        	
	 * @return mixed
	 */
	public function actionUpdate($id) {
		$model = $this->findModel ( $id );
		$file = File::find ()->where ( [ 
				'model_id' => $model->id,
				'model_type' => get_class ( $model ) 
		] )->one ();
		if (empty ( $file ))
			$file = new File ();
		$post = \yii::$app->request->post ();
		if (\yii::$app->request->isAjax && $model->load ( $post )) {
			\yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
			return TActiveForm::validate ( $model );
		}
		if ($model->load ( $post ) && $model->save ()) {
			if ($_FILES)
				$model->saveFile ( $file, $file );
			return $this->redirect ( [ 
					'view',
					'id' => $model->id 
			] );
		}
		$this->updateMenuItems ( $model );
		return $this->render ( 'update', [ 
				'model' => $model,
				'file' => $file 
		] );
	}
	
	/**
	 * Deletes an existing Category model.
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
	 * Finds the Category model based on its primary key value.
	 * If the model is not found, a 404 HTTP exception will be thrown.
	 *
	 * @param integer $id        	
	 * @return Category the loaded model
	 * @throws NotFoundHttpException if the model cannot be found
	 */
	protected function findModel($id, $accessCheck = true) {
		if (($model = Category::findOne ( $id )) !== null) {
			
			if ($accessCheck && ! ($model->isAllowed ()))
				throw new HttpException ( 403, Yii::t ( 'app', 'You are not allowed to access this page.' ) );
			
			return $model;
		} else {
			throw new NotFoundHttpException ( 'The requested page does not exist.' );
		}
	}
	protected function updateMenuItems($model = null) {
		switch (\Yii::$app->controller->action->id) {
			
			case 'index' :
				{
				}
				break;
			case 'update' :
				{
					
					$this->menu ['manage'] = array (
							'label' => '<span class="glyphicon glyphicon-list"></span>',
							'title' => Yii::t ( 'app', 'Manage' ),
							'url' => [ 
									'index' 
							],
							'visible' => User::isAdmin () 
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
						$this->menu ['delete'] = array (
								'label' => '<span class="glyphicon glyphicon-trash"></span>',
								'title' => Yii::t ( 'app', 'Delete' ),
								'url' => [ 
										'delete',
										'id' => $model->id 
								] 
							// 'visible' => User::isAdmin ()
						);
					}
				}
		}
	}
	public function actionImage($id, $file = null, $thumbnail = false) {
		$model = Category::findOne ( [ 
				'id' => $id 
		] );
		if (! empty ( $model )) {
			$fileModel = File::find ()->where ( [ 
					'model_id' => $model->id,
					'model_type' => get_class ( $model ) 
			] )->one ();
		}
		$file = '';
		if (! empty ( $fileModel ) && isset ( $fileModel ))
			$file = UPLOAD_PATH . $fileModel->title;
		if (! is_file ( $file )) {
			$file = \Yii::$app->view->theme->basePath . '/img/noimage.png';
			$h = is_numeric ( $thumbnail ) ? $thumbnail : 100;
			$thumb_path = UPLOAD_PATH . 'thumbnail_default_default.png';
			$img = Image::thumbnail ( $file, $h, null, ManipulatorInterface::THUMBNAIL_INSET );
			$img->save ( $thumb_path );
			$file = $thumb_path;
			return Yii::$app->response->sendFile ( $file );
		}
		if ($thumbnail) {
			$h = is_numeric ( $thumbnail ) ? $thumbnail : 100;
			$thumb_path = UPLOAD_PATH . 'thumbnail_' . $fileModel->title;
			$img = Image::thumbnail ( $file, $h, null, ManipulatorInterface::THUMBNAIL_INSET );
			$img->save ( $thumb_path );
			$file = $thumb_path;
		}
		return Yii::$app->response->sendFile ( $file );
	}
}
