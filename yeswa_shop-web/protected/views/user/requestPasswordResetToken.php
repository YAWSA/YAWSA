<?php

/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
use app\components\TActiveForm;
use yii\helpers\Html;
use yii\helpers\Inflector;
/* @var $this yii\web\View */
/* @var $form yii\bootstrap\ActiveForm */
/* @var $model \frontend\models\PasswordResetRequestForm */

$this->params ['breadcrumbs'] [] = [ 
		'label' => 'Users',
		'url' => [ 
				'user/index' 
		] 
];

$this->params ['breadcrumbs'] [] = Inflector::humanize ( Yii::$app->controller->action->id );

?>
<div class="well main_wrapper">
	<div class="container">

		<div class="login-box clearfix col-sm-4  login-design">
			<div class="text-center">
			<h3 class="colw">Reset Password</h3>
						<p> <?= \Yii::t("app", "Please fill out your email. A link to reset password will be sent there.") ?></p>
</div>

					
            <?php
												
												$form = TActiveForm::begin ( [ 
														'id' => 'request-password-reset-form',
														'enableClientValidation' => true,
														'enableAjaxValidation' => false 
												] );
												?>
            
                <?= $form->field($model, 'email')->label ( false )->textInput ( [ 'placeholder' => $model->getAttributeLabel ( 'email' ) ] ) ?>
                <div class="form-group">
                    <?= Html::submitButton('Send', ['class' => 'btn btn-lg btn-block btn-success submit-btn','name' => 'send-button']) ?>
                </div>
           <?php TActiveForm::end(); ?>
        </div>
						</div>
					</div>
				
