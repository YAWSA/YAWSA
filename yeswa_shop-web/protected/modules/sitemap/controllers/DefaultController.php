<?php
namespace app\modules\sitemap\controllers;

/**
 * Default controller for the `sitemap` module
 */
use app\components\TController;
use Yii;
use yii\filters\AccessControl;
use app\models\User;

class DefaultController extends TController
{

    public function behaviors()
    {
        return [
            'access' => [
                'class' => AccessControl::className(),
                
                'rules' => [
                    [
                        'actions' => [
                            'index'
                        ],
                        'allow' => true,
                        'roles' => [
                            '*',
                            '?',
                            '@'
                        ]
                    ],
                    [
                        'actions' => [
                            'test'
                        ],
                        'allow' => true,
                        'matchCallback' => function ($rule, $action) {
                            return User::isAdmin();
                        }
                    ]
                ]
            ]
        
        ];
    }

    public function actionIndex()
    {
        $module = $this->module;
        
        $urls = $module->buildSitemap();
        $sitemapData = $this->renderPartial('index', [
            'urls' => $urls
        ]);
        
        Yii::$app->response->format = \yii\web\Response::FORMAT_RAW;
        $headers = Yii::$app->response->headers;
        $headers->add('Content-Type', 'application/xml');
        if ($module->enableGzip) {
            $sitemapData = gzencode($sitemapData);
            $headers->add('Content-Encoding', 'gzip');
            $headers->add('Content-Length', strlen($sitemapData));
        }
        return $sitemapData;
    }

    public function actionTest()
    {
        set_time_limit(0);
        $this->layout = 'guest-main';
        $module = $this->module;
        $urls = $module->buildSitemap();
        
        return $this->render('test', [
            'urls' => $urls
        ]);
    }
}
