<?php

/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
namespace app\controllers;

use app\components\TController;
use app\models\User;
use yii\filters\AccessControl;
use app\models\Setting;
use app\models\Product;

class DashboardController extends TController
{

    public function behaviors()
    {
        return [
            'access' => [
                'class' => AccessControl::className(),
                'rules' => [
                    [
                        'actions' => [
                            'index',
                            'default-data'
                        ],
                        'allow' => true,
                        'matchCallback' => function () {
                            return User::isAdmin();
                        }
                    ]
                
                ]
            ]
        ];
    }

    public function actionIndex()
    {
        $searchModel = new \app\models\search\User();
        $dataProvider = $searchModel->search(\Yii::$app->request->queryParams);
        $dataProvider->pagination->pageSize = 5;
        
        $this->updateMenuItems();
        $smtpConfig = isset(\Yii::$app->settings) ? \Yii::$app->settings->smtp : null;
        if (empty($smtpConfig)) {
            Setting::setDefaultConfig();
        }
        return $this->render('index', [
            'dataProvider' => $dataProvider,
            'searchModel' => $searchModel
        ]);
    }

    public static function MonthlySignups()
    {
        $date = new \DateTime();
        $date->modify('-12  months');
        $last = $date;
        $dates = array();
        $count = array();
        for ($i = 1; $i <= 12; $i ++) {
            $date->modify('+1 months');
            $month = $date->format('Y-m');
            
            $count[$month] = (int) Product::find()->where([
                'like',
                'created_on',
                $month
            ])->count();
        }
        /* echo "<pre>";
        print_r($count);
        die(); */
        return $count;
    }

    public function actionDefaultData()
    {
        Setting::setDefaultConfig();
        $msg = 'Done !! Setting reset succefully!!!';
        \Yii::$app->session->setFlash('success', $msg);
        return $this->redirect(\Yii::$app->request->referrer);
    }
}
