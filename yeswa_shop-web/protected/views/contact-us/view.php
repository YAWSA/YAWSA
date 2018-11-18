<?php
use app\components\useraction\UserAction;
use app\modules\comment\widgets\CommentsWidget;
/* @var $this yii\web\View */
/* @var $model app\models\ContactUs */

/* $this->title = $model->label() .' : ' . $model->id; */
$this->params ['breadcrumbs'] [] = [ 
		'label' => Yii::t ( 'app', 'Contact Us' ),
		'url' => [ 
				'index' 
		] 
];
$this->params ['breadcrumbs'] [] = ( string ) $model;
?>

<div class="wrapper">
	<div class=" panel ">

		<div class="contact-us-view panel-body">
			<?php echo  \app\components\PageHeader::widget(['model'=>$model]); ?>



		</div>
	</div>

	<div class=" panel ">
		<div class=" panel-body ">
    <?php
				
echo \app\components\TDetailView::widget ( [ 
						'id' => 'contact-us-detail-view',
						'model' => $model,
						'options' => [ 
								'class' => 'table table-bordered' 
						],
						'attributes' => [ 
								'id',
								'message:html',
								'contact_no',
								[ 
										'attribute' => 'state_id',
										'format' => 'raw',
										'value' => $model->getStateBadge () 
								],
								
								'created_on:datetime',
								'updated_on:datetime',
								[ 
										'attribute' => 'created_by_id',
										'format' => 'raw',
										'value' => $model->getRelatedDataLink ( 'created_by_id' ) 
								] 
						] 
				] )?>


<?php  ?>


		<?php
		
echo UserAction::widget ( [ 
				'model' => $model,
				'attribute' => 'state_id',
				'states' => $model->getStateOptions () 
		] );
		?>

		</div>
	</div>

	<div class=" panel ">
		<div class=" panel-body ">

<?php echo CommentsWidget::widget(['model'=>$model]); ?>
			</div>
	</div>
</div>
