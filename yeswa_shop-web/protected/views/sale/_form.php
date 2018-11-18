<?php
use yii\helpers\Html;
use app\components\TActiveForm;
use yii\helpers\Url;

/* @var $this yii\web\View */
/* @var $model app\models\Sale */
/* @var $form yii\widgets\ActiveForm */
?>
<header class="panel-heading">
                            <?php echo strtoupper(Yii::$app->controller->action->id); ?>
                        </header>
<div class="panel-body">

    <?php
    $form = TActiveForm::begin([
        'layout' => 'horizontal',
        'id' => 'sale-form'
    ]);
    
    echo $form->errorSummary($model);
    // $data = $model->getCurrentMenu();
    ?>
		 <?php echo $form->field($model, 'brand_id')->dropDownList($model->getCategoryList(), ['prompt' => 'select', 'id'=>'cat-id'])->label('Sales Category'); ?>

<?php echo $form->field($model, 'brand_id')->dropDownList([]) ?>

 <?php echo $form->field($model, 'model_id')->dropDownList([])->label('Product') ?>      
		
		 <?php echo $form->field($model, 'title')->textInput(['maxlength' => 255]) ?>
	 		
<?php echo $form->field($model, 'type_id')->dropDownList($model->getTypeOptions(), ['prompt' => 'Select']) ?>
	
		 <?php echo $form->field($model, 'discount')->textInput(['maxlength' => 11])->label('Buy',['id'=>'sale']) ?>
	 		

		 <?php echo $form->field($model, 'min_limit')->textInput(['maxlength' => 255])->label('Get',['id'=>'get']) ?>
	 		
	 	
		 <?php echo $form->field($model, 'state_id')->dropDownList($model->getStateOptions(), ['prompt' => '']) ?>
	 		
     <?php echo $form->field($model, 'image_file')->fileInput(); ?>

	   <div class="form-group">
		<div
			class="col-md-6 col-md-offset-3 bottom-admin-button btn-space-bottom text-right">
        <?= Html::submitButton($model->isNewRecord ? Yii::t('app', 'Save') : Yii::t('app', 'Update'), ['id'=> 'sale-form-submit','class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
    </div>
	</div>

    <?php TActiveForm::end(); ?>

</div>

<script>

$(document).ready(function(e){
	$("#cat-id").change(function(){
		var id = $('#cat-id').val();
		onSubCategory(id);
	});

	$("#sale-brand_id").change(function(){
		var id = $('#sale-brand_id').val();
		onBrandCategory(id);
	});
	
	function onSubCategory(id){
	  	var url = "<?php echo Url::toRoute(['sale/brand-list'])?>"+"?id="+id;
		$.ajax({
			url : url,
			type: 'GET',
	        dataType:'json',
			}).success(function(response){
				options = ''; 
					  if(response.status == 'OK'){
						var brand = response.brand;
						var options = "<option value=''> <?= Yii::t('app','Choose') ?> </option>";
						$.each(brand, function(index, value) {
							options += "<option value=" + index + ">" + value + "</option>";
						});
					}
					$('#sale-brand_id').empty();
					$(options).appendTo('#sale-brand_id');
			});
		return false;
	}

	function onBrandCategory(id){
	  	var url = "<?php echo Url::toRoute(['sale/product-list'])?>"+"?id="+id;
		$.ajax({
			url : url,
			type: 'GET',
	        dataType:'json',
			}).success(function(response){
				options = ''; 
					  if(response.status == 'OK'){
						var product = response.product;
						var options = "<option value=''> <?= Yii::t('app','Choose') ?> </option>";
						$.each(product, function(index, value) {
							options += "<option value=" + index + ">" + value + "</option>";
						});
					}
					$('#sale-model_id').empty();
					$(options).appendTo('#sale-model_id');
			});
		return false;
	}


	$("#sale-type_id").change(function(){
		if($("#sale-type_id").val()==1){
			$("#sale").text('Discount');
		}else{
			$("#sale").text('Buy');
		}

		if($("#sale-type_id").val()==1){
			$("#get").text('Min Limit');
		}else{
			$("#get").text('Get');
		}
		
	});
});

</script>
