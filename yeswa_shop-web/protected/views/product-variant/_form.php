<?php
use yii\helpers\Html;
use app\components\TActiveForm;
use yii\helpers\Url;
use yii\widgets\Pjax;
use kartik\file\FileInput;

/* @var $this yii\web\View */
/* @var $model app\models\ProductVariant */
/* @var $form yii\widgets\ActiveForm */
?>
<header class="panel-heading">
                            <?php echo strtoupper(Yii::$app->controller->action->id); ?>
                        </header>
<div class="panel-body">

    <?php
				$form = TActiveForm::begin ( [ 
						'id' => 'product-variant-form' 
				] );
				?>


		 <?php //echo $form->field($model, 'product_id')->dropDownList($model->getProductOptions(), ['prompt' => '']) ?>
	 		
<div class="row">
		<div class="col-md-6">
		 
	 		
		 <?php echo $form->field($model, 'color_id')->dropDownList($model->getColorOptions()) ?>
		 
		 <?php echo $form->field($model, 'state_id')->dropDownList($model->getStateOptions()) ?>
		  <?php echo $form->field($model, 'size_id')->dropDownList($model->getSizeOptions())  ?>
	 		
		
	</div>
		<div class="col-md-6">
		
	 		 <?php echo $form->field($model, 'quantity')->textInput() ?>
		 <?php echo $form->field($model, 'amount')->textInput(['maxlength' => 255]) ?>
		 
		 
	 	 
	</div>
	</div>
	<div class="form-group">
		<div
			class="col-md-6 col-md-offset-3 bottom-admin-button btn-space-bottom text-right">
        <?= Html::submitButton($model->isNewRecord ? Yii::t('app', 'Save') : Yii::t('app', 'Update'), ['id'=> 'product-variant-form-submit','class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
    </div>
	</div>
    <?php TActiveForm::end(); ?>
</div>

