<?php

/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
namespace app\controllers;

use Yii;
use app\models\File;
use app\models\search\File as FileSearch;
use app\components\TController;
use yii\web\NotFoundHttpException;
use yii\filters\AccessControl;
use yii\filters\AccessRule;
use app\models\User;
use yii\web\HttpException;
use app\components\TActiveForm;
use yii\imagine\Image;
use Imagine\Image\ManipulatorInterface;
use yii\web\UploadedFile;

/**
 * FileController implements the CRUD actions for File model.
 */
class FileController extends TController {
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
												// 'add',
												'view',
												'update',
												'delete',
												'ajax',
												'mass',
												'delete-image',
												'upload' 
										],
										'allow' => true,
										'matchCallback' => function () {
											return User::isAdmin ();
										} 
								],
								[ 
										'actions' => [ 
												'crop',
												'files',
												'image',
												'thumbnail' 
										],
										'allow' => true,
										'roles' => [ 
												'*',
												'?',
												'@' 
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
	public function actionImage($id, $file = null, $thumbnail = false) {
		$model = $this->findModel ( $id, false );
		$file = UPLOAD_PATH . $model->title;
		
		if (! is_file ( $file )) {
			throw new NotFoundHttpException ( Yii::t ( 'app', "File not found" ) );
		}
		if ($thumbnail) {
			$h = is_numeric ( $thumbnail ) ? $thumbnail : 100;
			$thumb_path = UPLOAD_PATH . 'thumbnail_' . $model->title;
			if (! file_exists ( $thumb_path )) {
				$img = Image::thumbnail ( $file, $h, $h, ManipulatorInterface::THUMBNAIL_INSET );
				$img->save ( $thumb_path );
			}
			$file = $thumb_path;
		}
		return Yii::$app->response->sendFile ( $file );
	}
	public function actionFiles($file) {
		$image_path = UPLOAD_PATH . 'files/' . basename ( $file );
		if (! file_exists ( $image_path ))
			throw new NotFoundHttpException ( \Yii::t ( 'app', "File not found" ) );
		return \yii::$app->response->sendFile ( $image_path, $file );
	}
	public function actionCrop($filename, $width, $height, $crop = true, $start = [0, 0]) {
		$file = UPLOAD_PATH . $filename;
		
		if (file_exists ( $file ) && ! is_dir ( $file )) {
			if ($crop == true) {
				return Image::crop ( $file, $width, $height, $start );
			} else {
				\Yii::$app->response->sendFile ( $file );
			}
		}
	}
	
	/*
	 * const THUMBNAIL_INSET = 'inset';
	 * const THUMBNAIL_OUTBOUND = 'outbound';
	 *
	 */
	public function actionThumbnail($filename, $width = 150, $height = 150, $mode = ManipulatorInterface::THUMBNAIL_OUTBOUND) {
		$file = UPLOAD_PATH . $filename;
		if (file_exists ( $file ) && ! is_dir ( $file )) {
			return Image::thumbnail ( $file, $width, $height, $mode );
		}
	}
	
	/**
	 * Lists all File models.
	 *
	 * @return mixed
	 */
	public function actionIndex() {
		$searchModel = new FileSearch ();
		$dataProvider = $searchModel->search ( Yii::$app->request->queryParams );
		// $this->updateMenuItems();
		return $this->render ( 'index', [ 
				'searchModel' => $searchModel,
				'dataProvider' => $dataProvider 
		] );
	}
	
	/**
	 * Displays a single File model.
	 *
	 * @param integer $id        	
	 * @return mixed
	 */
	public function actionView($id) {
		$model = $this->findModel ( $id, false );
		$file = UPLOAD_PATH . $model->title;
		
		if (file_exists ( $file ))
			return Yii::$app->response->sendFile ( $file );
		throw new NotFoundHttpException ( Yii::t ( 'app', "File not found" ) );
	}
	
	/**
	 * Creates a new File model.
	 * If creation is successful, the browser will be redirected to the 'view' page.
	 *
	 * @return mixed
	 */
	public function actionAdd() {
		$model = new File ();
		$model->loadDefaultValues ();
		$model->state_id = File::STATE_ACTIVE;
		$post = \yii::$app->request->post ();
		if (\yii::$app->request->isAjax && $model->load ( $post )) {
			\yii::$app->response->format = \yii\web\Response::FORMAT_JSON;
			return TActiveForm::validate ( $model );
		}
		if ($model->load ( $post )) {
			if ($model->save ()) {
				\Yii::$app->getSession ()->setFlash ( 'success', \Yii::t ( 'app', 'File Added Successfully.' ) );
				return $this->redirect ( [ 
						'view',
						'id' => $model->id 
				] );
			} else {
				\Yii::$app->getSession ()->setFlash ( 'error', "Error !!" . $model->getErrorsString () );
			}
		}
		// $this->updateMenuItems();
		return $this->render ( 'add', [ 
				'model' => $model 
		] );
	}
	
	/**
	 * Updates an existing File model.
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
			if ($model->save ()) {
				\Yii::$app->getSession ()->setFlash ( 'success', \Yii::t ( 'app', 'File Updated Successfully.' ) );
				return $this->redirect ( [ 
						'view',
						'id' => $model->id 
				] );
			} else {
				\Yii::$app->getSession ()->setFlash ( 'error', "Error !!" . $model->getErrorsString () );
			}
		}
		// $this->updateMenuItems($model);
		return $this->render ( 'update', [ 
				'model' => $model 
		] );
	}
	
	/**
	 * Deletes an existing File model.
	 * If deletion is successful, the browser will be redirected to the 'index' page.
	 *
	 * @param integer $id        	
	 * @return mixed
	 */
	public function actionDelete($id) {
		$model = $this->findModel ( $id );
		$model->delete ();
		if (\Yii::$app->request->isAjax) {
			return true;
		}
		\Yii::$app->getSession ()->setFlash ( 'success', \Yii::t ( 'app', 'File Deleted Successfully.' ) );
		return $this->redirect ( [ 
				'index' 
		] );
	}
	public function actionDeleteImage() {
		\Yii::$app->response->format = 'json';
		$id = \yii::$app->request->post ( 'id', '0' );
		$model = $this->findModel ( $id );
		$response = [ ];
		$response ['status'] = 'NOK';
		
		if (! ($model->isAllowed ()))
			throw new HttpException ( 403, Yii::t ( 'app', 'You are not allowed to access this page.' ) );
		if ($model->delete ()) {
			$response ['status'] = 'OK';
		}
		return $response;
	}
	public function actionUpload() {
		\Yii::$app->response->format = 'json';
		$response = [ ];
		$response ['status'] = 'NOK';
		
		$model = new File ();
		
		if ($model->load ( \Yii::$app->request->post () )) {
			
			$image = UploadedFile::getInstance ( $model, 'title' );
			
			if (! empty ( $image )) {
				$image->saveAs ( UPLOAD_PATH . $image->baseName . '_' . time () . '.' . $image->extension );
				$model->file = $image->baseName;
				$model->title = $image->baseName . '_' . time () . '.' . $image->extension;
				$model->size = ( string ) $image->size;
				$model->extension = $image->extension;
				$model->type_id = 0;
				$model->state_id=File::STATE_ACTIVE;
				
				if ($model->save ()) {
					$response ['image'] = \Yii::$app->urlManager->createAbsoluteUrl ( [ 
							'user/download',
							'profile_file' => $model->title 
					] );
					$response ['id'] = $model->id;
					$response ['status'] = 'OK';
				}else{
					print_r($model->getErrorsString());exit;
				}
			}
		}else{
			die('ddh');
		}
		
		return $response;
	}
	
	/**
	 * Finds the File model based on its primary key value.
	 * If the model is not found, a 404 HTTP exception will be thrown.
	 *
	 * @param integer $id        	
	 * @return File the loaded model
	 * @throws NotFoundHttpException if the model cannot be found
	 */
	protected function findModel($id, $accessCheck = true) {
		if (($model = File::findOne ( $id )) !== null) {
			
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
					$this->menu ['manage'] = [ 
							'label' => '<span class="glyphicon glyphicon-list"></span>',
							'title' => Yii::t ( 'app', 'Manage' ),
							'url' => [ 
									'index' 
							] 
						// 'visible' => User::isAdmin ()
					];
				}
				break;
			case 'index' :
				{
					$this->menu ['add'] = [ 
							'label' => '<span class="glyphicon glyphicon-plus"></span>',
							'title' => Yii::t ( 'app', 'Add' ),
							'url' => [ 
									'add' 
							] 
						// 'visible' => User::isAdmin ()
					];
				}
				break;
			case 'update' :
				{
					$this->menu ['add'] = [ 
							'label' => '<span class="glyphicon glyphicon-plus"></span>',
							'title' => Yii::t ( 'app', 'add' ),
							'url' => [ 
									'add' 
							] 
						// 'visible' => User::isAdmin ()
					];
					$this->menu ['manage'] = [ 
							'label' => '<span class="glyphicon glyphicon-list"></span>',
							'title' => Yii::t ( 'app', 'Manage' ),
							'url' => [ 
									'index' 
							] 
						// 'visible' => User::isAdmin ()
					];
				}
				break;
			default :
			case 'view' :
				{
					$this->menu ['manage'] = [ 
							'label' => '<span class="glyphicon glyphicon-list"></span>',
							'title' => Yii::t ( 'app', 'Manage' ),
							'url' => [ 
									'index' 
							] 
						// 'visible' => User::isAdmin ()
					];
					if ($model != null) {
						$this->menu ['update'] = [ 
								'label' => '<span class="glyphicon glyphicon-pencil"></span>',
								'title' => Yii::t ( 'app', 'Update' ),
								'url' => [ 
										'update',
										'id' => $model->id 
								] 
							// 'visible' => User::isAdmin ()
						];
						$this->menu ['delete'] = [ 
								'label' => '<span class="glyphicon glyphicon-trash"></span>',
								'title' => Yii::t ( 'app', 'Delete' ),
								'url' => [ 
										'delete',
										'id' => $model->id 
								] 
							// 'visible' => User::isAdmin ()
						];
					}
				}
		}
	}
}
