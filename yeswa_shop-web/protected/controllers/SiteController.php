<?php

/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
namespace app\controllers;

use app\components\TActiveForm;
use app\components\TController;
use app\models\ContactForm;
use app\models\EmailQueue;
use app\models\User;
use Yii;
use yii\filters\AccessControl;
use yii\web\Response;

class SiteController extends TController
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
                            'contact',
                            'about',
                            'policy',
                            'terms',
                            'error'
                        ],
                        'allow' => true,
                        'roles' => [
                            '*',
                            '@',
                            '?'
                        ]
                    ]
                ]
            ]
        ];
    }

    public function actions()
    {
        return [
            'error' => [
                'class' => 'yii\web\ErrorAction'
            ],
            'captcha' => [
                'class' => 'yii\captcha\CaptchaAction',
                'fixedVerifyCode' => YII_ENV_TEST ? 'testme' : null
            ]
        ];
    }

    public function actionError()
    {
        $exception = \Yii::$app->errorHandler->exception;
        return $this->render('error', [
            'message' => $exception->getMessage(),
            'name' => 'Error'
        ]);
    }

    public function actionIndex()
    {
        if (! \Yii::$app->user->isGuest) {
            if (User::isAdmin()) {
                $this->layout = 'main';
                return $this->redirect([
                    '/dashboard/index'
                ]);
            } else {
                $this->layout = 'guest-main';
                return $this->redirect([
                    'dashboard/index'
                ]);
            }
        } else {
            $this->layout = 'guest-main';
            return $this->render('index');
        }
    }

    public function actionContact()
    {
        $model = new ContactForm();
        if (Yii::$app->request->isAjax && $model->load(Yii::$app->request->post())) {
            Yii::$app->response->format = Response::FORMAT_JSON;
            return TActiveForm::validate($model);
        }
        if ($model->load(Yii::$app->request->post())) {
            $sub = 'New Contact: ' . $model->subject;
            $from = $model->email;
            $message = \yii::$app->view->renderFile('@app/mail/contact.php', [
                'user' => $model
            ]);
            EmailQueue::sendEmailToAdmins([
                'from' => $from,
                'subject' => $sub,
                'html' => $message
            ], true);
            \Yii::$app->getSession()->setFlash('success', \Yii::t('app', 'Warm Greetings!! Thank you for contacting us. We have received your request. Our representative will contact you soon.'));
            return $this->refresh();
        }
        
        return $this->render('contact', [
            'model' => $model
        ]);
    }

    public function actionAbout()
    {
        $this->layout = 'guest-main';
        return $this->render('about');
    }

    public function actionPolicy()
    {
        $this->layout = 'guest-main';
        return $this->render('policy');
    }

    public function actionTerms()
    {
        $this->layout = 'guest-main';
        return $this->render('term');
    }
}
