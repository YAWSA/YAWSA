<?php

/* @var $this yii\web\View */
/* @var $searchModel app\models\search\Color */
/* @var $dataProvider yii\data\ActiveDataProvider */

/* $this->title = Yii::t('app', 'Index'); */
$this->params['breadcrumbs'][] = [
    'label' => Yii::t('app', 'Colors'),
    'url' => [
        'index'
    ]
];
$this->params['breadcrumbs'][] = Yii::t('app', 'Index');

?>
<div class="page-wrapper">
	<div class="wrapper">
		<div class="user-index">
			<div class=" panel ">
				<div class="color-index">
<?=  \app\components\PageHeader::widget(); ?>
  </div>
			</div>
			<div class="content-section clearfix panel">
				<?= $this->render ( '_form', [ 'model' => $model ] )?>
			</div>
			<div class="panel panel-margin">
				<div class="panel-body">
					<div class="content-section clearfix">
						<header class="panel-heading head-border">   <?= strtoupper(Yii::$app->controller->action->id); ?> </header>
		<?= $this->render('_grid', ['dataProvider' => $dataProvider, 'searchModel' => $searchModel]); ?>
</div>
				</div>
			</div>
		</div>
	</div>
</div>
