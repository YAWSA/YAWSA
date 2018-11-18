<?php
use phpnt\exportFile\ExportFile;
use app\models\User;

/**
 *
 * @copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 * @author : Shiv Charan Panjeta < shiv@toxsl.com >
 */

/* @var $this yii\web\View */
/* @var $searchModel app\models\search\User */
/* @var $dataProvider yii\data\ActiveDataProvider */
// $this->title = Yii::t ( 'app', 'Users' );
if (\Yii::$app->controller->action->id == 'index') {
	$label = 'Customers';
	$role_id = User::ROLE_USER;
} else {
	$label = 'Vendor';
	$role_id = User::ROLE_VENDOR;
}
$this->params ['breadcrumbs'] [] = [ 
		'label' => $label 
];

?>
<div class="wrapper">
	<div class="user-index">
		<div class=" panel ">	
			
			<?=  \app\components\PageHeader::widget(['title'=>$label]); ?>

		</div>
		<div class="panel panel-margin">
			<div class="panel-body">
				<div class="content-section clearfix">
					<div class="pull-right">
					<?php
					echo ExportFile::widget ( [ 
							'title' => 'User Report',
							'model' => "app\models\search\User",
							'queryParams' => [ 
									'role_id' => $role_id 
							],
							'xls' => false,
							'word' => false,
							'html' => false,
							'pdf' => false,
							'getAll' => true 
					] )?>
				</div>
					<?php echo $this->render('_grid', ['dataProvider' => $dataProvider, 'searchModel' => $searchModel]); ?>
				</div>
			</div>
		</div>
	</div>
</div>