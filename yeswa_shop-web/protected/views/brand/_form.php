<?php
use app\components\TActiveForm;
use kartik\file\FileInput;
use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\Brand */
/* @var $form yii\widgets\ActiveForm */
?>
<header class="panel-heading">
                            <?php echo strtoupper(Yii::$app->controller->action->id); ?>
                        </header>
<div class="panel-body">

    <?php
    $form = TActiveForm::begin([
        'layout' => 'horizontal',
        'id' => 'brand-form'
    ]);
    ?>

<?php echo $form->field($model, 'category_id')->dropDownList($model->getCategoryOptions(), ['prompt' => '']) ?>



		 <?php echo $form->field($model, 'title')->textInput(['maxlength' => 255]) ?>
	 		


		 <?php echo  $form->field($model, 'description')->widget ( app\components\TRichTextEditor::className (), [ 'options' => [ 'rows' => 6 ],'preset' => 'basic' ] ); //$form->field($model, 'description')->textarea(['rows' => 6]);  ?>
	 		

<?php
$data = [];
if (Yii::$app->controller->action->id == 'update') {
    if (! empty($file)) {
        $data[] = Html::img([
            'file/view',
            'id' => $file->id
        ], [
            'width' => '150',
            'class' => 'file-preview-frame'
        ]);
    }
}

?>
 <?php

echo $form->field($file, 'filename', [
    'enableAjaxValidation' => false
])->widget(FileInput::classname(), [
    'options' => [
        'accept' => 'image/*',
        'multiple' => false
    ],
    'pluginOptions' => [
        'initialPreview' => $data,
        'allowedFileExtensions' => [
            'jpg',
            'jpeg',
            'gif',
            'png'
        ],
        'showUpload' => false,
        'previewFileType' => 'image'
    ]
]);
?>

		 <?php //echo $form->field($model, 'state_id')->dropDownList($model->getStateOptions(), ['prompt' => '']) ?>
	 		


		 <?php //echo $form->field($model, 'type_id')->dropDownList($model->getTypeOptions(), ['prompt' => '']) ?>
	 		


	   <div class="form-group">
		<div
			class="col-md-6 col-md-offset-3 bottom-admin-button btn-space-bottom text-right">
        <?= Html::submitButton($model->isNewRecord ? Yii::t('app', 'Save') : Yii::t('app', 'Update'), ['id'=> 'brand-form-submit','class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
    </div>
	</div>
    <?php TActiveForm::end(); ?>
</div>