<?php
use yii\helpers\Html;
use app\components\TActiveForm;
use kartik\file\FileInput;

/* @var $this yii\web\View */
/* @var $model app\models\Category */
/* @var $form yii\widgets\ActiveForm */
?>
<header class="panel-heading">
                            <?php echo strtoupper(Yii::$app->controller->action->id); ?>
                        </header>
<div class="panel-body">

    <?php
    $form = TActiveForm::begin([
        'layout' => 'horizontal',
        'id' => 'category-form'
    ]);
    ?>





		 <?php echo $form->field($model, 'title')->textInput(['maxlength' => 256]) ?>
	 		


		 <?php echo $form->field($model, 'state_id')->dropDownList($model->getStateOptions(), ['prompt' => '']) ?>
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

	   <div class="form-group">
		<div
			class="col-md-6 col-md-offset-3 bottom-admin-button btn-space-bottom text-right">
        <?= Html::submitButton($model->isNewRecord ? Yii::t('app', 'Save') : Yii::t('app', 'Update'), ['id'=> 'category-form-submit','class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
    </div>
	</div>

    <?php TActiveForm::end(); ?>

</div>
