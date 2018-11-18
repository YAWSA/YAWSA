<?php
/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
use app\components\notice\Notices;
use app\controllers\DashboardController;
use app\models\LoginHistory;
use app\models\Page;
use app\models\User;
use app\models\search\User as UserSearch;
use miloschuman\highcharts\Highcharts;
use yii\helpers\Url;
use app\components\TBaseWidget;
use yii\base\Widget;
use app\components\TCardDetail;
use app\components\TCard;
use app\models\Product;

/* @var $this yii\web\View */
// $this->title = Yii::t ( 'app', 'Dashboard' );
$this->params ['breadcrumbs'] [] = [ 
		'label' => Yii::t ( 'app', 'Dashboard' ) 
];
?>

<?= Notices::widget(); ?>

<div class="wrapper">
	<?php
	$isConfig = \Yii::$app->settings->isConfig;
	if (! $isConfig) {
		?>
		<div>
		<div class="alert alert-info">
			<strong> Info !! </strong> Your app is not configure properly <b><a
				href="<?= Url::toRoute(['/setting/index']) ?>"> Click Here </a></b>
			To configure..
		</div>
	</div>
	<?php } ?>
	
	<!--state overview start-->
	<div class="row state-overview">
		
		
		<?php
		echo TCard::widget ( [ 
				'icon' => 'users',
				'title' => 'Customers',
				'content' => User::find ()->where ( [ 
						'role_id' => User::ROLE_USER 
				] )->count (),
				'action' => 'user/index',
				'visible' => User::isAdmin () 
		] );
		
		echo TCard::widget ( [ 
				'icon' => 'users',
				'title' => 'Vendor',
				'content' => User::find ()->where ( [ 
						'role_id' => User::ROLE_VENDOR 
				] )->count (),
				'action' => 'user/vendor',
				'visible' => User::isAdmin () 
		] );
		
		echo TCard::widget ( [
				'icon' => 'database',
				'title' => 'Products',
				'content' => Product::find ()->count (),
				'action' => 'product/index',
				'visible' => User::isAdmin ()
		] );
		
		echo TCard::widget ( [ 
				'icon' => 'file',
				'title' => 'Pages',
				'content' => Page::find ()->count (),
				'action' => 'page/index',
				'visible' => User::isAdmin () 
		
		] );
		echo TCard::widget ( [ 
				'icon' => 'users',
				'title' => 'Login History',
				'content' => LoginHistory::find ()->count (),
				'action' => 'login-history/index',
				'visible' => User::isAdmin () 
		] );
		
		?>

	</div>



	<div class="panel">
		<div class="panel-body">
			Welcome <strong>
         <?= Yii::$app->user->identity->full_name;?></strong>


			<!-- <div class="text-right">
				<a class="btn btn-danger"
					href="< ?= Url::toRoute(['dashboard/default-data']) ?>"
					data-confirm="< ?= \Yii::t("app", "Are you sure you want to Reset all settings?") ?>"> Reset
					Settings </a>
			</div> -->

		</div>
	</div>

	<div class="panel">

		<div class="panel-body">
			<div class="panel-heading">
				<span class="tools pull-right"> </span>
			</div>

			<div class="col-md-6">
						<?php
						$data = DashboardController::MonthlySignups ();
						
						echo Highcharts::widget ( [ 
								'options' => [ 
										'credits' => array (
												'enabled' => false 
										),
										
										'title' => [ 
												'text' => 'Monthly Product Created' 
										],
										'chart' => [ 
												'type' => 'column' 
										],
										'xAxis' => [ 
												'categories' => array_keys ( $data ) 
										],
										'yAxis' => [ 
												'title' => [ 
														'text' => 'Count' 
												] 
										],
										'series' => [ 
												[ 
														'name' => 'Product',
														'data' => array_values ( $data ) 
												] 
										] 
								] 
						
						] );
						?>
	</div>

			<div class="col-md-6">
	<?php
	$data = DashboardController::MonthlySignups ();
	
	?>
					<?php
					echo Highcharts::widget ( [ 
							'scripts' => [ 
									'highcharts-3d',
									'modules/exporting' 
							],
							
							'options' => [ 
									'credits' => array (
											'enabled' => false 
									),
									'chart' => [ 
											'plotBackgroundColor' => null,
											'plotBorderWidth' => null,
											'plotShadow' => false,
											'type' => 'pie' 
									],
									'title' => [ 
											'text' => 'Statistics' 
									],
									'tooltip' => [ 
											'valueSuffix' => '' 
									],
									'plotOptions' => [ 
											'pie' => [ 
													'allowPointSelect' => true,
													'cursor' => 'pointer',
													'dataLabels' => [ 
															'enabled' => true 
													],
													// 'format' => '<b>{point.name}</b>: {point.percentage:.1f} %'
													'showInLegend' => true 
											] 
									],
									
									'htmlOptions' => [ 
											'style' => 'min-width: 100%; height: 400px; margin: 0 auto' 
									],
									'series' => [ 
											[ 
													'name' => 'Total Count',
													'colorByPoint' => true,
													
													'data' => [ 
															[ 
																	'name' => 'Inactive Product',
																	'color' => $this->theme->style,
																	'y' => ( int ) User::findActive ( 0 )->count (),
																	'sliced' => true,
																	'selected' => true 
															],
															
															[ 
																	'name' => 'Active Product',
																	'color' => $this->theme->style,
																	'y' => ( int ) User::findActive ()->count (),
																	'sliced' => true,
																	'selected' => true 
															] 
													] 
											] 
									] 
							] 
					] );
					?>
							</div>
		</div>

	</div>
	<div class="clearfix"></div>
	<div class="panel">
		<div class="panel-body">
		<?php
		
		echo $this->render ( '//user/_grid', [ 
				'dataProvider' => $dataProvider,
				'searchModel' => $searchModel 
		] );
		
		?>
	</div>
	</div>
</div>