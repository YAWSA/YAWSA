<?php

use yii\helpers\Html;
use app\components\TActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\VendorProfile */
/* @var $form yii\widgets\ActiveForm */
?>
<header class="panel-heading">
                            <?php echo strtoupper(Yii::$app->controller->action->id); ?>
                        </header>
<div class="panel-body">

    <?php 
$form = TActiveForm::begin([
											'id'	=> 'vendor-profile-form',
						]);
?>





<div class="col-md-6">

	
		 <?php echo $form->field($model, 'title')->textInput(['maxlength' => 255]) ?>
	 		


		 <?php echo $form->field($model, 'first_name')->textInput(['maxlength' => 255]) ?>
	 		


		 <?php echo $form->field($model, 'last_name')->textInput(['maxlength' => 255]) ?>
	 		


		 <?php echo $form->field($model, 'civil_id')->dropDownList($model->getCivilOptions(), ['prompt' => '']) ?>
	 		


		 <?php /*echo  $form->field($model, 'description')->widget ( app\components\TRichTextEditor::className (), [ 'options' => [ 'rows' => 6 ],'preset' => 'basic' ] ); //$form->field($model, 'description')->textarea(['rows' => 6]); */ ?>
	 		

	</div>
	<div class="col-md-6">

		
		 <?php echo $form->field($model, 'whats_app_no')->textInput(['maxlength' => 255]) ?>
	 		


		 <?php echo $form->field($model, 'shopname')->textInput(['maxlength' => 255]) ?>
	 		


		 <?php echo $form->field($model, 'shop_logo')->textInput(['maxlength' => 255]) ?>
	 		


		 <?php echo $form->field($model, 'state_id')->dropDownList($model->getStateOptions(), ['prompt' => '']) ?>
	 			</div>

	


	   <div class="form-group">
		<div
			class="col-md-6 col-md-offset-3 bottom-admin-button btn-space-bottom text-right">
        <?= Html::submitButton($model->isNewRecord ? Yii::t('app', 'Save') : Yii::t('app', 'Update'), ['id'=> 'vendor-profile-form-submit','class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
    </div>
	</div>

    <?php TActiveForm::end(); ?>

</div>
