<?php

use yii\helpers\Html;
use app\components\TActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\VendorAddress */
/* @var $form yii\widgets\ActiveForm */
?>
<header class="panel-heading">
                            <?php echo strtoupper(Yii::$app->controller->action->id); ?>
                        </header>
<div class="panel-body">

    <?php 
$form = TActiveForm::begin([
											'id'	=> 'vendor-address-form',
						]);
?>





<div class="col-md-6">

	
		 <?php echo $form->field($model, 'location')->textInput(['maxlength' => 255]) ?>
	 		


		 <?php echo $form->field($model, 'city')->textInput(['maxlength' => 255]) ?>
	 		


		 <?php echo $form->field($model, 'area')->textInput(['maxlength' => 255]) ?>
	 		


		 <?php echo $form->field($model, 'block')->textInput(['maxlength' => 255]) ?>
	 		


		 <?php echo $form->field($model, 'street')->textInput(['maxlength' => 255]) ?>
	 		


		 <?php echo $form->field($model, 'house')->textInput(['maxlength' => 255]) ?>
	 		

	</div>
	<div class="col-md-6">

		
		 <?php echo $form->field($model, 'apartment')->textInput(['maxlength' => 255]) ?>
	 		


		 <?php echo $form->field($model, 'office')->textInput(['maxlength' => 255]) ?>
	 		


		 <?php echo $form->field($model, 'latitude')->textInput(['maxlength' => 255]) ?>
	 		


		 <?php echo $form->field($model, 'longitude')->textInput(['maxlength' => 255]) ?>
	 		


		 <?php echo $form->field($model, 'state_id')->dropDownList($model->getStateOptions(), ['prompt' => '']) ?>
	 		


		 <?php /*echo $form->field($model, 'type_id')->dropDownList($model->getTypeOptions(), ['prompt' => '']) */ ?>
	 			</div>

	


	   <div class="form-group">
		<div
			class="col-md-6 col-md-offset-3 bottom-admin-button btn-space-bottom text-right">
        <?= Html::submitButton($model->isNewRecord ? Yii::t('app', 'Save') : Yii::t('app', 'Update'), ['id'=> 'vendor-address-form-submit','class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
    </div>
	</div>

    <?php TActiveForm::end(); ?>

</div>
