<?php
/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
use app\components\PageHeader;
use app\components\TDetailView;
use app\components\useraction\UserAction;
use yii\helpers\Html;
use yii\helpers\Url;
use app\models\User;
use app\modules\comment\widgets\CommentsWidget;
use kartik\export\ExportMenu;
use phpnt\exportFile\ExportFile;
use app\components\TExportFile;
/* @var $this yii\web\View */
/* @var $model app\models\User */
if ($model->role_id == User::ROLE_USER) {
	$label = 'Customers';
	$url = 'index';
} elseif ($model->role_id == User::ROLE_VENDOR) {
	$label = 'Vendor';
	$url = 'vendor';
} else {
	$label = 'User';
	$url = 'dashboard/index';
}
$this->params ['breadcrumbs'] [] = [ 
		'label' => $label,
		'url' => [ 
				$url 
		] 
];
$this->params ['breadcrumbs'] [] = [ 
		'label' => $model->full_name 
];

?>
<div class="wrapper">

	<div class=" panel ">
		<?php echo  PageHeader::widget(['model'=>$model]); ?>
	</div>
	<div class="panel">
		<div class=" panel-body">
			<div class="col-md-2">
			<?php if(!empty($model->profile_file)) { ?>
				<?php echo Html::img($model->getImageUrl(true))?><br /> <br />
				<p>
        			<?= Html::a('Download image file', ['download','profile_file'=>$model->profile_file], ['class' => 'btn btn-success','name' => 'download-button'])?>
   			 	</p>
   			 	
   			 	<?php }else{?>
   			 	<img src="<?=$this->theme->getUrl('/img/default.png')?>"
					height="150px" width="150px"><br /> <br />
								<?php
			}
			?>
			</div>
			<div class="col-md-10">
				<div class="pull-right">
<?php
echo ExportFile::widget ( [ 
		'title' => 'User Report',
		'model' => "app\models\search\User",
		'queryParams' => [ 
				'id' => $model->id 
		],
		'xls' => false,
		'word' => false,
		'html' => false,
		'pdf' => false 
] )?>
	</div>		
			<?php
			echo TDetailView::widget ( [ 
					'model' => $model,
					'attributes' => [ 
							'id',
							'full_name',
							'email:email',
							[ 
									'attribute' => 'role_id',
									'format' => 'raw',
									'value' => $model->getRoleOptions ( $model->role_id ) 
							],
							
							'created_on:datetime' 
					] 
			] )?>
			</div>
		</div>
		<div class="panel-body">
				<?php
				if ((User::isAdmin ()) && (\Yii::$app->user->id != $model->id)) {
					/*
					 * $actions = $model->getStateOptions();
					 * array_shift($actions);
					 */
					echo UserAction::widget ( [ 
							'model' => $model,
							'attribute' => 'state_id',
							'states' => $model->getStateOptions () 
						// 'allowed' => $actions
					] );
				}
				?>
			</div>



	</div>

	<div class=" panel ">
		<div class=" panel-body ">
				<?php
				$this->context->startPanel ();
				
				if ($model->role_id == User::ROLE_VENDOR)
				
				/* $this->context->addPanel ( 'Brand', 'brand', 'Brand', $model );
				$this->context->addPanel ( 'Order', 'order', 'Order', $model );
				$this->context->addPanel ( 'Product', 'product', 'Product', $model ); */
				$this->context->addPanel ( 'VendorLocation', 'vendorLocation', 'VendorLocation', $model );
				$this->context->addPanel ( 'VendorAddress', 'vendorAddress', 'VendorAddress', $model );
				$this->context->addPanel ( 'VendorProfile', 'vendorProfile', 'VendorProfile', $model );
				
				
				$this->context->endPanel ();
				?>
			</div>
	</div>


	<div class=" panel ">
		<div class=" panel-body ">
				<?php echo  CommentsWidget::widget(['model'=>$model,'disabled' => false]); ?>
		</div>
	</div>
</div>

