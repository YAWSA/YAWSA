<?php
use app\components\useraction\UserAction;
use app\modules\comment\widgets\CommentsWidget;
use app\models\File;
use app\components\TActiveForm;
use yii\helpers\Html;
use yii\helpers\Url;

/* @var $this yii\web\View */
/* @var $model app\models\Product */

/* $this->title = $model->label() .' : ' . $model->title; */
$this->params ['breadcrumbs'] [] = [ 
		'label' => Yii::t ( 'app', 'Products' ),
		'url' => [ 
				'index' 
		] 
];
$this->params ['breadcrumbs'] [] = ( string ) $model;
$media = new File ();
?>
<div class="page-wrapper">
	<div class="wrapper">
		<div class="panel">
			<div class="product-view panel-body">
			<?php echo  \app\components\PageHeader::widget(['model'=>$model]); ?>
		</div>
		</div>

		<div class=" panel ">
			<div class=" panel-body ">
    <?php
				
				echo \app\components\TDetailView::widget ( [ 
						'id' => 'product-detail-view',
						'model' => $model,
						'options' => [ 
								'class' => 'table table-bordered' 
						],
						'attributes' => [ 
								'id',
            /*'title',*/
            /*'description:html',*/
            [ 
										'attribute' => 'category_id',
										'format' => 'raw',
										'value' => $model->getRelatedDataLink ( 'category_id' ) 
								],
								[ 
										'attribute' => 'brand_id',
										'format' => 'raw',
										'value' => $model->getRelatedDataLink ( 'brand_id' ) 
								],
            /*[
			'attribute' => 'state_id',
			'format'=>'raw',
			'value' => $model->getStateBadge(),],*/
            /*[
			'attribute' => 'type_id',
			'value' => $model->getType(),
			],*/
            'created_on:datetime',
								'updated_on:datetime',
								[ 
										'attribute' => 'created_by_id',
										'format' => 'raw',
										'value' => $model->getRelatedDataLink ( 'created_by_id' ) 
								] 
						] 
				] )?>


<?php  echo $model->description;?>


		<?php
		
		echo UserAction::widget ( [ 
				'model' => $model,
				'attribute' => 'state_id',
				'states' => $model->getStateOptions () 
		] );
		?>
<div class=" panel ">
					<div class=" panel-body ">
						Files
<?php
$form = TActiveForm::begin ( [ 
		'id' => 'upload-image',
		'options' => [ 
				'enctype' => 'multipart/form-data' 
		] 
] );

echo $form->field ( $media, 'title', [ 
		'template' => '{input}' 
] )->fileInput ( [ 
		'id' => 'dairy' 
] );
?>
							<?=$form->field ( $media, 'model_id', [ 'template' => '{input}','options' => [ 'tags' => false ] ] )->hiddenInput ( [ 'value' => $model->id ] )?>
							
							<?=$form->field ( $media, 'model_type', [ 'template' => '{input}','options' => [ 'tags' => false ] ] )->hiddenInput ( [ 'value' => get_class ( $model ) ] )?>
							
							<?=$form->field ( $media, 'create_user_id', [ 'template' => '{input}','options' => [ 'tags' => false ] ] )->hiddenInput ( [ 'value' => $model->created_by_id ] )?>
									
						<?php TActiveForm::end ()?>

						<div class="image_container">
		<?php
		$files = File::getAllImg ( $model, false );
		if (! empty ( $files )) {
			foreach ( $files as $key => $img ) {
				// print_r($img);exit;
				$ext = explode ( '.', $img );
				
				$end = end ( $ext );
				// print_r($end);exit;
				if ($end == 'pdf' || $end == 'xlsx' || $end == 'docx') {
					
					?>
		       <div class="col-md-3 image" data-id="<?= $key ?>">
								<a href="<?= $img ?>">File</a>
								<div class="del">
									<a href="javascript:;" title="Delete Image"
										class="image_delete" data-id="<?= $key ?>"> <i
										class="fa fa-trash"></i></a>
								</div>
							</div>
				<?php }else{?>
				<div class="col-md-3 image" data-id="<?= $key ?>">
								<a class="img-responsive" href="<?= $img ?>"> <img
									src="<?= $img ?>" alt="Image" width="200" height="150">

								</a>
								<div class="del">
									<a href="javascript:;" title="Delete Image"
										class="image_delete" data-id="<?= $key ?>"> <i
										class="fa fa-trash"></i></a>
								</div>
							</div>
		  <?php
				}
			}
		}
		?>
		</div>
					</div>
				</div>

			</div>
		</div>



		<div class="panel">
			<div class="panel-body">
				<div class="product-panel">

<?php
$this->context->startPanel ();
$this->context->addPanel ( 'ProductVariants', 'productVariants', 'ProductVariant', $model );
$this->context->endPanel ();
?>
				</div>
			</div>
		</div>


	</div>
</div>

<script>


var notEmpty = function(value) {
	if( value == null || value == 'undefined' || value == '' || value == 0 ) {
		return false;
	}
	return true;
}

$(".image_container").on('click', '.image_delete',function() {
	var id = $(this).attr('data-id');
	deleteImage(id);
}); 
function deleteImage(id) {
	$.ajax({
			type: 'POST',
			url: '<?= Url::toRoute(['file/delete-image']) ?>',
			data: { id : id },
			success : function( response ) {
				if ( response.status == 'OK' ) {
					$(".image[data-id = '"+id+"']").remove();
				}
			}
	});
}



$('#dairy').change(function() {
	$('#upload-image').submit();
});

$('#upload-image').on('submit',(function(e) {
    e.preventDefault();
    var formData = new FormData(this);
    $.ajax({
        type:'POST',
        url: '<?= Url::toRoute(['file/upload']) ?>',
        data:formData,
        cache:false,
        contentType: false,
        processData: false,
        success:function(response) {
            if( response.status == 'OK' && notEmpty(response.image) ) {
            	var img = appendImage(response.image, response.id);
            	$(".image_container").append(img);
            } 
        }
    });
}));

function appendImage(url, id) {
	var html = '';
	html += '<div class="col-md-3 image" data-id="'+id+'"><a href="'+url+'">';
	html += '<img src="'+url+'" alt="Image" width="200" height="150">';
	html += '</a>';
	
	html += '<div class="del">';
	html += '<a href="javascript:;" title="Delete Image" class="image_delete" data-id="'+id+'"><i class="fa fa-trash"></i></a>';
	html +=	'</div></div>';
	
	return html;
}
</script>
