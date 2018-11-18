<?php

/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
namespace app\modules\api\controllers;

use app\models\EmailQueue;
use app\models\Log;
use app\models\LoginForm;
use app\models\User;
use app\modules\api\models\AuthSession;
use Yii;
use yii\filters\AccessControl;
use yii\filters\AccessRule;
use yii\helpers\ArrayHelper;
use app\models\VendorAddress;
use app\models\VendorProfile;
use app\models\VendorLocation;
use app\models\File;
use app\models\Product;
use yii\db\Expression;
use app\models\Category;
use app\models\ContactUs;
use app\models\Page;
use app\models\Sale;

/**
 * UserController implements the API actions for User model.
 */
class UserController extends ApiTxController
{

    public function behaviors()
    {
        return ArrayHelper::merge(parent::behaviors(), [
            'access' => [
                'class' => AccessControl::className(),
                'ruleConfig' => [
                    'class' => AccessRule::className()
                ],
                'rules' => [
                    [
                        'actions' => [
                            'index',
                            'check',
                            'get',
                            'update',
                            'delete',
                            'view',
                            'add',
                            'logout',
                            'change-password',
                            'logout',
                            'add-log',
                            'switch-role',
                            'update-profile',
                            'update-profile-image',
                            'update-vendor-logo',
                            'slider',
                            'contact-us',
                            'switch-role',
                            'update-customer',
                            'vendor-update',
                            'on-off-location'
                        ],
                        'allow' => true,
                        'roles' => [
                            '@'
                        ]
                    ],
                    [
                        'actions' => [
                            
                            'login',
                            'recover',
                            'check',
                            'mode',
                            'beat',
                            'get',
                            'instagram',
                            'add-log',
                            'signup',
                            'vendor-signup',
                            'pages',
                            'geo-vendor',
                            'slider',
                            'send-mail',
                            'sale'
                        ],
                        'allow' => true,
                        'roles' => [
                            '?',
                            '*',
                            '@'
                        ]
                    ]
                ]
            ]
        ]);
    }

    /**
     * Lists all User models.
     *
     * @return mixed
     */
    public function actionIndex()
    {
        return $this->txIndex("\app\models\search\User");
    }

    /**
     * Displays a single User model.
     *
     * @return mixed
     */
    public function actionGet($id)
    {
        return $this->txget($id, "app\models\User");
    }

    /**
     * Creates a new User model.
     * If creation is successful, the browser will be redirected to the 'view' page.
     *
     * @return mixed
     */
    public function actionAdd()
    {
        return $this->txSave("app\models\User");
    }

    /**
     * Updates an existing User model.
     * If update is successful, the browser will be redirected to the 'view' page.
     *
     * @return mixed
     */
    public function actionUpdate($id)
    {
        $data = [];
        $model = $this->findModel($id);
        if ($model->load(Yii::$app->request->post())) {
            
            if ($model->save()) {
                $data['status'] = self::API_OK;
                $data['detail'] = $model;
            } else {
                $data['error'] = $model->flattenErrors;
            }
        } else {
            $data['error_post'] = 'No Data Posted';
        }
        
        return $this->sendResponse($data);
    }

    public function actionOnOffLocation()
    {
        $data = [];
        $model = $this->findModel(Yii::$app->user->id);
        if ($model->location_tracking == User::LOCATION_TRACKING_OFF) {
            $model->location_tracking = User::LOCATION_TRACKING_ON;
            $msg = "Location On";
        } elseif ($model->location_tracking == User::LOCATION_TRACKING_ON) {
            $model->location_tracking = User::LOCATION_TRACKING_OFF;
            $msg = "Location Off";
        } else {
            $data['error'] = "Wrong State ID";
        }
        
        if ($model->save(false, [
            'location_tracking'
        ])) {
            $data['status'] = self::API_OK;
            $data['message'] = $msg;
            $data['detail'] = $model;
        } else {
            $data['error'] = "Something Went Wrong, Try Again";
        }
        return $this->sendResponse($data);
    }

    public function actionCheck()
    {
        $data = [];
        $flag = false;
        
        if (! \Yii::$app->user->isGuest) {
            $user = \Yii::$app->user->identity;
            $data['status'] = self::API_OK;
            if ($user->role_id == User::ROLE_VENDOR) {
                $flag = true;
            }
            $data['detail'] = $user->asJson($flag);
        } else {
            
            $headers = getallheaders();
            $auth_code = isset($headers['auth_code']) ? $headers['auth_code'] : null;
            if ($auth_code == null)
                $auth_code = \Yii::$app->request->getQueryString('auth_code');
            if ($auth_code) {
                $auth_session = AuthSession::find()->where([
                    'auth_code' => $auth_code
                ])->one();
                if ($auth_session) {
                    $data['status'] = self::API_OK;
                    if (isset($_POST['AuthSession'])) {
                        $auth_session->device_token = $_POST['AuthSession']['device_token'];
                        if ($auth_session->save()) {
                            $data['auth_session'] = 'Auth Session updated';
                        } else {
                            
                            $data['error'] = $auth_session->flattenErrors;
                        }
                    }
                } else
                    $data['error'] = 'session not found';
            } else {
                $data['error'] = 'Auth code not found';
                $data['auth'] = isset($auth_code) ? $auth_code : '';
            }
        }
        
        return $this->sendResponse($data);
    }

    public function actionVendorSignup()
    {
        $data = [];
        $model = new User();
        $vendorAddressModel = new VendorAddress();
        $vendorProfileModel = new VendorProfile();
        $vendorLocation = new VendorLocation();
        $params = Yii::$app->request->bodyParams;
        if ($model->load(Yii::$app->request->post()) && $vendorAddressModel->load(Yii::$app->request->post()) && $vendorProfileModel->load(Yii::$app->request->post()) && $vendorLocation->load(Yii::$app->request->post())) {
            $email_identify = User::findByUsername($model->email);
            if (empty($email_identify)) {
                $model->setPassword($model->password);
                $model->role_id = $params['User']['role_id'];
                $model->state_id = User::STATE_ACTIVE;
                $model->full_name = $params['VendorProfile']['first_name'] . ' ' . $params['VendorProfile']['last_name'];
                $model->is_vendor = User::IS_VENDOR;
                $db = \Yii::$app->db;
                $transaction = $db->beginTransaction();
                try {
                    if ($model->save()) {
                        $user_id = $model->id;
                        $vendorAddressModel->created_by_id = $user_id;
                        $vendorProfileModel->created_by_id = $user_id;
                        $vendorLocation->created_by_id = $user_id;
                        $vendorProfileModel->saveUploadedFile($vendorProfileModel, 'shop_logo');
                        $vendorProfileModel->title = $model->full_name;
                        if ($vendorProfileModel->save() && $vendorAddressModel->save()) {
                            $vendorLocation->vendor_id = $model->id;
                            $vendorLocation->location = $vendorAddressModel->location;
                            if ($vendorLocation->save()) {
                                $transaction->commit();
                                $data['status'] = self::API_OK;
                                $data['detail'] = $model->asJson(true);
                            } else {
                                $data['error-loc'] = $vendorLocation->errorsString;
                            }
                        } else {
                            $data['error-pro'] = $vendorProfileModel->getErrorsString();
                            $data['error-ven'] = $vendorAddressModel->getErrorsString();
                        }
                    } else {
                        $data['error-mod'] = $model->getErrorsString();
                    }
                } catch (\Exception $e) {
                    $data['error'] = $e->getMessage();
                    $transaction->rollBack();
                }
            } else {
                $data['error'] = "Email already exists.";
            }
        }
        return $this->sendResponse($data);
    }

    public function actionVendorUpdate()
    {
        $data = [];
        $user = \Yii::$app->user->identity;
        $flag = false;
        $db = \Yii::$app->db;
        $transaction = $db->beginTransaction();
        if (! empty($user)) {
            
            if ($user->load(\Yii::$app->request->post())) {
                
                $vendorProfile = VendorProfile::find()->where([
                    'created_by_id' => \Yii::$app->user->id
                ])->one();
                if (! empty($vendorProfile)) {
                    if ($vendorProfile->load(\Yii::$app->request->post())) {
                        $logo = $vendorProfile->shop_logo;
                        $vendorProfile->shop_logo = $logo;
                        $vendorProfile->saveUploadedFile($vendorProfile, 'shop_logo');
                        if ($vendorProfile->save()) {
                            $user->full_name = $vendorProfile->first_name . ' ' . $vendorProfile->last_name;
                            if ($user->save()) {
                                $vendorAddress = VendorAddress::find()->where([
                                    'created_by_id' => \Yii::$app->user->id
                                ])->one();
                                if (! empty($vendorAddress)) {
                                    if ($vendorAddress->load(\Yii::$app->request->post())) {
                                        if ($vendorAddress->save()) {
                                            $vendorLocation = VendorLocation::find()->where([
                                                'created_by_id' => \Yii::$app->user->id
                                            ])->one();
                                            if (! empty($vendorLocation)) {
                                                if ($vendorLocation->load(\Yii::$app->request->post())) {
                                                    $vendorLocation->location = $vendorAddress->location;
                                                    if ($vendorLocation->save()) {
                                                        $flag = true;
                                                    } else {
                                                        $data['error'] = $vendorLocation->errorsString;
                                                    }
                                                }
                                            } else {
                                                $data['error'] = \Yii::t('app', 'No data posted');
                                            }
                                        } else {
                                            $data['error'] = $vendorAddress->errorsString;
                                        }
                                    } else {
                                        $data['error'] = \Yii::t('app', 'No data posted');
                                    }
                                }
                            } else {
                                $data['error'] = $user->errorsString;
                            }
                        } else {
                            $data['error'] = $vendorProfile->errorsString;
                        }
                    }
                } else {
                    $data['error'] = \Yii::t('app', 'No data posted');
                }
            } else {
                $data['error'] = \Yii::t('app', 'No data posted');
            }
        } else {
            $data['error'] = \Yii::t('app', 'No user found');
        }
        
        if ($flag == true) {
            $transaction->commit();
            $data['status'] = self::API_OK;
            $data['detail'] = $user->asJson(true);
            $data['message'] = \Yii::t('app', 'Updated Successfully');
        } else {
            $transaction->rollBack();
        }
        return $this->sendResponse($data);
    }

    public function actionSignup()
    {
        $data = [];
        $model = new User();
        $params = Yii::$app->request->bodyParams;
        
        if ($model->load(Yii::$app->request->post())) {
            $email_identify = User::findByUsername($model->email);
            if (empty($email_identify)) {
                $model->is_customer = User::IS_CUSTOMER;
                $model->full_name = $model->first_name . ' ' . $model->last_name;
                $model->setPassword($model->password);
                $model->role_id = $params['User']['role_id'];
                $model->state_id = User::STATE_ACTIVE;
                if ($model->save()) {
                    $data['status'] = self::API_OK;
                    $data['detail'] = $model->asJson();
                } else {
                    $data['error'] = $model->errorsString;
                }
            } else {
                $data['error'] = "Email already exists.";
            }
        }
        return $this->sendResponse($data);
    }

    /**
     *
     * @return string|string[]|NULL[]
     */
    public function actionLogin()
    {
        $data = [];
        $model = new LoginForm();
        $flag = false;
        $param = \Yii::$app->request->bodyParams;
        if ($model->load(Yii::$app->request->post())) {
            $user = User::findByUsername($model->username);
            if ($user) {
                $role = $param['User']['role_id'];
                if ($role != $user->role_id) {
                    if (($user->role_id == User::ROLE_VENDOR && $user->is_customer != User::IS_CUSTOMER) || ($user->role_id == User::ROLE_VENDOR && $user->is_vendor != User::IS_VENDOR)) {
                        $data['error'] = "You are not a " . $user->getRoleOptions($role);
                        return $this->sendResponse($data);
                    }
                }
                
                if ($model->login()) {
                    $user->role_id = $param['User']['role_id'];
                    if ($user->save(false)) {
                        $data['status'] = self::API_OK;
                        $data['auth_code'] = AuthSession::newSession($model)->auth_code;
                        if ($user->role_id == User::ROLE_VENDOR) {
                            $flag = true;
                        }
                        $data['detail'] = $user->asJson($flag);
                    }
                } else {
                    $data['error'] = 'Incorrect Password';
                }
            } else {
                $data['error'] = ' Incorrect Username';
            }
        } else {
            $data['error'] = "No data posted.";
        }
        
        return $this->sendResponse($data);
    }

    public function actionLogout()
    {
        $data = [];
        if (Yii::$app->user->logout())
            $data['status'] = self::API_OK;
        
        return $this->sendResponse($data);
    }

    public function actionChangePassword()
    {
        $data = [];
        $data['post'] = $_POST;
        $model = User::findOne([
            'id' => \Yii::$app->user->identity->id
        ]);
        
        $newModel = new User([
            'scenario' => 'changepassword'
        ]);
        if ($newModel->load(Yii::$app->request->post()) && $newModel->validate()) {
            $model->setPassword($newModel->newPassword);
            if ($model->save()) {
                
                $data['status'] = self::API_OK;
            } else {
                $data['error'] = 'Incorrect Password';
            }
        }
        return $this->sendResponse($data);
    }

    public function actionAddLog()
    {
        $data = [];
        $model = new Log();
        if ($model->load(Yii::$app->request->post()) && $model->validate()) {
            if ($model->save()) {
                $email = $model->email;
                $view = 'errorlog';
                $sub = "An Error/Crash was reported : " . \Yii::$app->params['company'];
                Yii::$app->mailer->compose([
                    'html' => 'errorlog'
                ], [
                    'user' => $model
                ])
                    ->setTo(\Yii::$app->params['adminEmail'])
                    ->setFrom(\Yii::$app->params['logEmail'])
                    ->setSubject($sub)
                    ->send();
            }
        }
        $data['status'] = self::API_OK;
        return $this->sendResponse($data);
    }

    /**
     * Deletes an existing User model.
     * If deletion is successful, the browser will be redirected to the 'index' page.
     *
     * @return mixed
     */
    public function actionDelete($id)
    {
        return $this->txDelete($id, "User");
    }

    public function actionRecover()
    {
        $data = [];
        $param = \Yii::$app->request->bodyParams;
        $model = new User();
        $emailQueue = new EmailQueue();
        if (isset($param['User']['email'])) {
            $email = trim($param['User']['email']);
            $user = User::findOne([
                'email' => $email
            ]);
            if ($user) {
                $user->generatePasswordResetToken();
                $user->save();
                $user->sendEmail();
                $data['success'] = Yii::t('app', 'Please check your email to reset your password');
                $data['status'] = self::API_OK;
                $data['recover-email'] = $user->email;
            } else {
                $data['error'] = Yii::t('app', 'Email is not registered');
            }
        } else {
            $data['error'] = Yii::t('app', 'Please enter Email Address');
        }
        return $this->sendResponse($data);
    }

    /*
     * public function actionSwitchRole() {
     * $data = [ ];
     * $param = \Yii::$app->request->bodyParams;
     * $role = $param ['User'] ['role_id'];
     * $user = \Yii::$app->user->identity;
     * if (($role == User::ROLE_USER) || ($role == User::ROLE_VENDOR)) {
     * $user->role_id = $role;
     * if ($user->save ()) {
     * $data ['status'] = self::API_OK;
     * $data ['message'] = \Yii::t ( 'app', 'Your role changed to ' . $user->getRole () );
     * } else {
     * $data ['status'] = self::API_NOK;
     * $data ['error'] = $user->getErrorString ();
     * }
     * } else {
     * $data ['status'] = self::API_NOK;
     * $data ['error'] = \Yii::t ( 'app', 'Invalid Role' );
     * }
     * return $this->sendResponse ( $data );
     * }
     */
    public function actionUpdateProfile()
    {
        $data = [];
        $user = \Yii::$app->user->identity;
        if ($user->load(\Yii::$app->request->post())) {
            $data = $user->getIsSaveStatus();
        } else {
            $data['status'] = self::API_NOK;
            $data['error'] = \Yii::t('app', 'No data posted');
        }
        return $this->sendResponse($data);
    }

    public function actionUpdateProfileImage()
    {
        $data = [];
        $user = \Yii::$app->user->identity;
        $old = $user->profile_file;
        if ($_FILES) {
            $user->saveUploadedFile($user, 'profile_file', $old);
            $data = $user->getIsSaveStatus();
        } else {
            $data['status'] = self::API_NOK;
            $data['error'] = \Yii::t('app', 'No data posted');
        }
        return $this->sendResponse($data);
    }

    public function actionUpdateVendorLogo()
    {
        $data = [];
        $vendorProfile = VendorProfile::my()->one();
        if (empty($vendorProfile)) {
            $vendorProfile = new VendorProfile();
            $vendorProfile->created_by_id = \Yii::$app->user->id;
        }
        if ($_FILES) {
            $vendorProfile->saveUploadedFile($vendorProfile, 'shop_logo');
            $data = $vendorProfile->getIsSaveStatus();
        } else {
            $data['status'] = self::API_NOK;
            $data['error'] = \Yii::t('app', 'No data posted');
        }
        return $this->sendResponse($data);
    }

    public function actionSlider()
    {
        $data = [];
        $detail = [];
        $models = File::find()->where([
            'model_type' => get_class(new Product())
        ])
            ->orderBy(new Expression('rand()'))
            ->limit(3)
            ->all();
        if (! empty($models)) {
            foreach ($models as $model) {
                $list['title'] = '';
                $title = Product::findOne($model->model_id);
                if (! empty($title)) {
                    $list['title'] = $title->title;
                }
                $list['id'] = $model->id;
                $list['image_file'] = $model->getImageUrl(true);
                $detail[] = $list;
            }
            $data['status'] = self::API_OK;
            $data['detail'] = $detail;
        } else {
            $data['error'] = \Yii::t('app', 'No data found');
        }
        
        return $this->sendResponse($data);
    }

    public function actionSale()
    {
        $data = [];
        $list = [];
        $models = Sale::find()->all();
        
        if (! empty($models)) {
            foreach ($models as $model) {
                $list[] = $model->asJson();
            }
            $data['status'] = self::API_OK;
            $data['detail'] = $list;
        } else {
            $data['error'] = \Yii::t('app', 'No data found');
        }
        
        return $this->sendResponse($data);
    }

    public function actionContactUs()
    {
        $data = [];
        $model = new ContactUs();
        if ($model->load(\Yii::$app->request->post())) {
            
            if ($model->save()) {
                $data['status'] = self::API_OK;
                $data['message'] = \Yii::t('app', 'Form Submited Successfully');
                $data['detail'] = $model->asJson();
            } else {
                $data['error'] = $model->errorsString;
            }
        } else {
            $data['error'] = \Yii::t('app', 'No data posted');
        }
        if (! empty($models)) {
            foreach ($models as $model) {
                $list['id'] = $model->id;
                $list['image_file'] = $model->getImageUrl(true);
                $detail[] = $list;
            }
            $data['status'] = self::API_OK;
            $data['detail'] = $detail;
        } else {
            $data['error'] = \Yii::t('app', 'No data found');
        }
        
        return $this->sendResponse($data);
    }

    public function actionSwitchRole()
    {
        $data = [];
        
        $user = Yii::$app->user->identity;
        $is_vendor = $user->is_vendor;
        $user_id = $user->id;
        $db = \Yii::$app->db;
        // $transaction = $db->beginTransaction ();
        $vendorAddressModel = VendorAddress::find()->where([
            'created_by_id' => $user_id
        ])->one();
        if (empty($vendorAddressModel)) {
            $vendorAddressModel = new VendorAddress();
        }
        
        $vendorProfileModel = VendorProfile::find()->where([
            'created_by_id' => $user_id
        ])->one();
        if (empty($vendorProfileModel)) {
            $vendorProfileModel = new VendorProfile();
        }
        $vendorLocation = VendorLocation::find()->where([
            'created_by_id' => $user_id
        ])->one();
        if (empty($vendorLocation)) {
            $vendorLocation = new VendorLocation();
        }
        $params = Yii::$app->request->bodyParams;
        
        if (! empty($user)) {
            /* try { */
            $user->is_vendor = User::IS_VENDOR;
            $post = \Yii::$app->request->post();
            if ($user->load($post)) {
                if ($user->save()) {
                    if ($is_vendor != User::IS_VENDOR) {
                        
                        if ($vendorAddressModel->load($post) && $vendorProfileModel->load($post) && $vendorLocation->load($post)) {
                            $vendorAddressModel->created_by_id = $user_id;
                            $vendorProfileModel->created_by_id = $user_id;
                            $vendorLocation->created_by_id = $user_id;
                            
                            $vendorProfileModel->saveUploadedFile($vendorProfileModel, 'shop_logo');
                            
                            $vendorProfileModel->title = $params['VendorProfile']['first_name'] . ' ' . $params['VendorProfile']['last_name'];
                            if ($vendorProfileModel->save() && $vendorAddressModel->save()) {
                                $vendorLocation->vendor_id = $user_id;
                                $vendorLocation->location = $vendorAddressModel->location;
                                if (! $vendorLocation->save()) {
                                    $data['error'] = $vendorLocation->errorsString;
                                } else {
                                    $user->is_vendor = User::IS_VENDOR;
                                    if ($user->save(false)) {
                                        $data['status'] = self::API_OK;
                                        $data['message'] = \Yii::t('app', 'Role switch successfully');
                                        $data['detail'] = $user->asJson(true);
                                    }
                                }
                            } else {
                                $data['error-pro'] = $vendorProfileModel->getErrorsString();
                                $data['error-ven'] = $vendorAddressModel->getErrorsString();
                            }
                        } else {
                            $data['error'] = \Yii::t('app', 'No data posted');
                        }
                    } else {
                        $data['status'] = self::API_OK;
                        $data['message'] = \Yii::t('app', 'Role switch successfully');
                        $data['detail'] = $user->asJson(true);
                    }
                } else {
                    $data['error'] = $user->errorsString;
                }
            } else {
                $data['error'] = \Yii::t('app', 'No data posted');
            }
            /*
             * } catch ( \Exception $e ) {
             * $data ['error'] = $e->getMessage ();
             * $transaction->rollBack ();
             * }
             */
        } else {
            $data['error'] = \Yii::t('app', 'No user found');
        }
        return $this->sendResponse($data);
    }

    public function actionPages($type)
    {
        $data = [];
        $model = Page::find()->where([
            'type_id' => $type
        ])->one();
        if (! empty($model)) {
            $data['status'] = self::API_OK;
            $data['detail'] = $model->asJson();
        } else {
            $data['error'] = \Yii::t('app', 'No Page found');
        }
        return $this->sendResponse($data);
    }

    public function actionGeoVendor()
    {
        $data = [];
        
        $latitude = isset($_POST['User']['latitude']) ? $_POST['User']['latitude'] : "";
        $longitude = isset($_POST['User']['longitude']) ? $_POST['User']['longitude'] : "";
        if (empty($latitude) && empty($longitude)) {
            $data['error'] = \Yii::t('app', 'Please provide your location');
            return $this->sendResponse($data);
        }
        $queries = VendorLocation::find()->select([
            "vendor_id, ( 6371 * acos( cos( radians({$latitude}) ) * cos( radians( `latitude` ) ) * cos( radians( `longitude` ) -
				radians({$longitude}) ) + sin( radians({$latitude}) ) * sin( radians( `latitude` ) ) ) ) AS distance"
        ])
            ->having("distance <:distance")
            ->addParams([
            ':distance' => '10'
        ])
            ->all();
        $ids = [];
        if (! empty($queries)) {
            foreach ($queries as $query) {
                $ids[] = $query->vendor_id;
            }
        }
        
        $users = User::find()->where([
            'AND',
            [
                'in',
                'id',
                $ids
            
            ],
            [
                'location_tracking' => User::LOCATION_TRACKING_ON
            ]
        ])->all();
        
        if (! empty($users)) {
            $list = [];
            foreach ($users as $user) {
                $list[] = $user->asJson(true);
            }
            $data['detail'] = $list;
            
            $data['status'] = self::API_OK;
        } else {
            $data['error'] = \Yii::t('app', 'No vendor found near your location');
        }
        // print_r($query->createCommand()->rawSql);exit;
        
        return $this->sendResponse($data);
    }

    public function actionUpdateCustomer()
    {
        $data = [];
        $user = \Yii::$app->user->identity;
        if ($user->load(\Yii::$app->request->post())) {
            $user->full_name = $user->first_name . ' ' . $user->last_name;
            if ($user->save()) {
                $data['status'] = self::API_OK;
                $data['detail'] = $user->asJson();
            } else {
                $data['error'] = $user->errorsString;
            }
        } else {
            $data['error'] = \Yii::t('app', 'No data posted');
        }
        return $this->sendResponse($data);
    }
}