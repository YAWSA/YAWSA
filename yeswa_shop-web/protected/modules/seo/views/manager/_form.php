<?php

use yii\helpers\Html;
use app\components\TActiveForm;

/* @var $this yii\web\View */
/* @var $model app\models\Seo */
/* @var $form yii\widgets\ActiveForm */
?>
<header class="panel-heading">
                            <?php echo strtoupper(Yii::$app->controller->action->id); ?>
                        </header>
<div class="panel-body">

    <?php 
$form = TActiveForm::begin([
						'layout' => 'horizontal',
						'id'	=> 'seo-form',
						]);
?>
	



		
		 <?php echo $form->field($model, 'route')->textInput(['maxlength' => 255]) ?>
	 		

		
		 <?php echo $form->field($model, 'title')->textInput(['maxlength' => 255])  ?>
	 		

		
		 <?php echo $form->field($model, 'keywords')->textInput(['maxlength' => 255])  ?>
	 		

		
		 <?php echo $form->field($model, 'description')->textarea(['rows' => 6]); //$form->field($model, 'description')->widget(kartik\widgets\Html5Input::className(),[]); */ ?>
	 		

		
		 <?php echo $form->field($model, 'data')->textInput(['maxlength' => 255]) ?>
	 		


	   <div class="form-group">
		<div
			class="col-md-6 col-md-offset-3 bottom-admin-button btn-space-bottom text-right">
        <?= Html::submitButton($model->isNewRecord ? Yii::t('app', 'Save') : Yii::t('app', 'Update'), ['id'=>'seo-form-submit','class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
    </div>
	</div>

    <?php TActiveForm::end(); ?>

</div>
