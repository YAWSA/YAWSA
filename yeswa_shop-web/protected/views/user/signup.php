<?php
use app\models\User;
use app\components\TActiveForm;
use yii\helpers\Html;
use yii\helpers\Url;

/* @var $this yii\web\View */
/* @var $form yii\bootstrap\ActiveForm */
/* @var $model \frontend\models\SignupForm */

$this->title = 'Signup';
?>

<div class="well main_wrapper">

	<div class="container">
		<div class="row">

			<div class="login-box clearfix col-sm-4  login-design">
				<div class="form-outer padd-lt">


			<?php

$form = TActiveForm::begin([
    'id' => 'form-signup',
    'options' => [
        'class' => 'driver-form form-horizontal'
    ]
]);
?>
			<h3 class="text-center mar-tp-11">Registration Form</h3>


					<div class="row">
						<div class="col-sm-12"></div>
						<?=$form->field ( $model, 'full_name', [ 'template' => '<div class="col-sm-12">{input}{error}</div>' ] )->textInput ( [ 'maxlength' => true,'placeholder' => 'Full Name' ] )->label ( false )?>



						<?=$form->field ( $model, 'email', [ 'template' => '<div class="col-sm-12">{input}{error}</div>' ] )->textInput ( [ 'maxlength' => true,'placeholder' => 'Email' ] )->label ( false )?>


							<?=$form->field ( $model, 'password', [ 'template' => '<div class="col-sm-12">{input}{error}</div>' ] )->passwordInput ( [ 'maxlength' => true,'placeholder' => 'Password' ] )->label ( false )?>


							<?=$form->field ( $model, 'confirm_password', [ 'template' => '<div class="col-sm-12">{input}{error}</div>' ] )->passwordInput ( [ 'maxlength' => true,'placeholder' => 'Confirm Password' ] )->label ( false )?>
						<div class="">
                    <?=Html::submitButton ( 'Signup', [ 'class' => 'btn btn-lg btn-success btn-block','name' => 'signup-button' ] )?>
                </div>


						<div class="registration m-t-20 m-b-20">
							<a class="" href="<?php echo Url::toRoute(['user/login']);?>">
								Login </a>
						</div>


					<?php TActiveForm::end(); ?>				<!-- driver form ends -->



					</div>

				</div>
			</div>
		</div>
	</div>
</div>
