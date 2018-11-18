<?php
use yii\helpers\Html;
use app\components\TActiveForm;
use yii\helpers\Url;
use kartik\file\FileInput;
use app\models\File;

/* @var $this yii\web\View */
/* @var $model app\models\Product */
/* @var $form yii\widgets\ActiveForm */
?>
<header class="panel-heading">
                            <?php echo strtoupper(Yii::$app->controller->action->id); ?>
                        </header>
<div class="panel-body">

    <?php
				$form = TActiveForm::begin ( [ 
						'layout' => 'horizontal',
						'id' => 'product-form' 
				] );
				?>
		 <?php echo $form->field($model, 'title')->textInput(['maxlength' => 256]) ?>
	 		
		 <?php echo  $form->field($model, 'description')->widget ( app\components\TRichTextEditor::className (), [ 'options' => [ 'rows' => 6 ],'preset' => 'basic' ] ); //$form->field($model, 'description')->textarea(['rows' => 6]); ?>
	 	 
	 	 <?php echo $form->field($model, 'category_id')->dropDownList($model->getCategoryOptions(), ['prompt' => '']); ?>
	 		
		 <?php echo $form->field($model, 'brand_id')->dropDownList($model->getBrandOptions(), ['prompt' => '']) ?>

		 <?php echo $form->field($model, 'state_id')->dropDownList($model->getStateOptions(), ['prompt' => '']) ?>
	 	
	 	<?php
			$data = [ ];
			if (Yii::$app->controller->action->id == 'update') {
				
				if (! empty ( $previous )) {
					
					foreach ( $previous as $p ) {
						
						$data [] = Html::img ( [ 
								'file/view',
								'id' => $p->id 
						], [ 
								'width' => '150',
								'class' => 'file-preview-frame' 
						] );
					}
				}
			}
			
			?>
		 
		 <?php
			if (Yii::$app->controller->action->id != 'update') {
				
				echo $form->field ( $file, 'filename[]', [ 
						'enableAjaxValidation' => false 
				] )->widget ( FileInput::classname (), [ 
						'options' => [ 
								'accept' => 'image/*',
								'multiple' => true 
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
				] );
			}
			?>	


	   <div class="form-group">
		<div
			class="col-md-6 col-md-offset-3 bottom-admin-button btn-space-bottom text-right">
        <?= Html::submitButton($model->isNewRecord ? Yii::t('app', 'Save') : Yii::t('app', 'Update'), ['id'=> 'product-form-submit','class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
    </div>
	</div>

    <?php TActiveForm::end(); ?>

</div>
<script>
$("#product-category_id").on("change" , function(){
	updateBrand();
});
function updateBrand(){
	let id = $("#product-category_id").val();
	let url = "<?= Url::toRoute(['product-variant/get-brand'])?>";
	$.ajax({
		url : url,
		type:'POST',
		data:{
			id : id,
		},
		dataType:'json',
		}).success(function(response){
			console.log(response);
    		if(response.status == 'OK'){
    			var options = ''
    				$.each(response.data, function(index, value) {
						options += "<option value=" + index + ">" + value + "</option>";
					});
    			$('#product-brand_id').empty();
				$(options).appendTo('#product-brand_id');
            } 
	});
}
</script>