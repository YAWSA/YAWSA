<?php

/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
use app\components\TActiveForm;
use yii\helpers\Html;
use yii\helpers\Url;

/* @var $this yii\web\View */
/* @var $form yii\bootstrap\ActiveForm */
/* @var $model \common\models\LoginForm */

$this->title = 'Sign In';

$fieldOptions1 = [
    'options' => [
        'class' => 'form-group has-feedback'
    ],
    
    'inputTemplate' => "{input}<span class='glyphicon glyphicon-envelope form-control-feedback'></span>"
];

$fieldOptions2 = [
    'options' => [
        'class' => 'form-group has-feedback'
    ],
    'inputTemplate' => "{input}<span class='glyphicon glyphicon-lock form-control-feedback'></span>"
];
?>
<div class="well main_wrapper">
	<div class="container">

		<div class="login-box clearfix col-sm-4  login-design">
			<div class="text-center">
				<a class="page-logo" href="<?= Url::home() ?>">
					<h3 class="colw">Log In</h3>
				</a>
			</div>

			 <?php
    
    $form = TActiveForm::begin([
        'id' => 'login-form',
        'enableClientValidation' => false,
        'enableAjaxValidation' => false,
        'options' => [
            'class' => 'login-form form'
        ]
    ]);
    ?>
			 <?=$form->field ( $model, 'username', $fieldOptions1 )->label ( false )->textInput ( [ 'placeholder' => $model->getAttributeLabel ( 'email' ) ] )?>
			<?=$form->field ( $model, 'password', $fieldOptions2 )->label ( false )->passwordInput ( [ 'placeholder' => $model->getAttributeLabel ( 'password' ) ] )?>

			
				<div class="col-md-6 padd-0">
					<div class="checkbox remember">
					<?php echo $form->field($model, 'rememberMe')->checkbox();?>

					</div>
				</div>
				<div class="col-md-6">
					<a class="forgot pull-right"
						href="<?php echo Url::toRoute(['user/recover'])?>">Forgot
						Password? </a>
				</div>

		
					<?=Html::submitButton ( 'Login', [ 'class' => 'btn btn-lg btn-block btn-success submit-btn','id' => 'login','name' => 'login-button' ] )?>
						
			</h4>
			<?php TActiveForm::end()?>
		</div>
	</div>
</div>