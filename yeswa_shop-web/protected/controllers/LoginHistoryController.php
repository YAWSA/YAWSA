<?php

/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
namespace app\controllers;

use app\components\TActiveForm;
use app\components\TController;
use app\models\LoginHistory;
use app\models\User;
use app\models\search\LoginHistory as LoginHistorySearch;
use Yii;
use yii\filters\AccessControl;
use yii\filters\AccessRule;
use yii\web\HttpException;
use yii\web\NotFoundHttpException;
use yii\db\ActiveRecord;

/**
 * LoginHistoryController implements the CRUD actions for LoginHistory model.
 */
class LoginHistoryController extends TController
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
                            'view',
                            'delete',
                            'ajax',
                            'mass',
                            'clear'
                        ],
                        'allow' => true,
                        'matchCallback' => function () {
                            return User::isAdmin();
                        }
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
     * Lists all LoginHistory models.
     *
     * @return mixed
     */
    public function actionIndex()
    {
        $searchModel = new LoginHistorySearch();
        $dataProvider = $searchModel->search(Yii::$app->request->queryParams);
        $this->updateMenuItems();
        return $this->render('index', [
            'searchModel' => $searchModel,
            'dataProvider' => $dataProvider
        ]);
    }

    /**
     * Displays a single LoginHistory model.
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
    public function actionMass($action = 'delete')
    {
        \Yii::$app->response->format = 'json';
        $response['status'] = 'NOK';
        $Ids = Yii::$app->request->post('ids', []);
        
        if (! empty($Ids)) {
            foreach ($Ids as $Id) {
                $model = LoginHistory::findOne($Id);
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
     * Deletes an existing LoginHistory model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     *
     * @param integer $id
     * @return mixed
     */
    public function actionDelete($id)
    {
        $model = $this->findModel($id);
        $model->delete();
        if (\Yii::$app->request->isAjax) {
            return true;
        }
        \Yii::$app->getSession()->setFlash('success', \Yii::t('app', 'Login History Deleted Successfully.'));
        return $this->redirect([
            'index'
        ]);
    }

    public function actionClear($truncate = false)
    {
        if ($truncate) {
            LoginHistory::truncate();
        } else {
            $query = LoginHistory::find();
            
            foreach ($query->batch() as $models) {
                foreach ($models as $model) {
                    $model->delete();
                }
            }
        }
        return $this->redirect([
            'index'
        ]);
    }

    /**
     * Finds the LoginHistory model based on its primary key value.
     * If the model is not found, a 404 HTTP exception will be thrown.
     *
     * @param integer $id
     * @return LoginHistory the loaded model
     * @throws NotFoundHttpException if the model cannot be found
     */
    protected function findModel($id)
    {
        if (($model = LoginHistory::findOne($id)) !== null) {
            
            if (! ($model->isAllowed()))
                throw new HttpException(403, Yii::t('app', 'You are not allowed to access this page.'));
            
            return $model;
        } else {
            throw new NotFoundHttpException('The requested page does not exist.');
        }
    }

    protected function updateMenuItems($model = null)
    {
        switch (\Yii::$app->controller->action->id) {
            case 'index':
                {
                    $this->menu['clear'] = [
                        'label' => '<span class=" glyphicon glyphicon-remove"></span>',
                        'title' => Yii::t('app', 'Clear'),
                        'url' => [
                            'clear'
                        ],
                        'visible' => User::isAdmin()
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
                }
        }
    }
}
