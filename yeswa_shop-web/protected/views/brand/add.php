<?php
use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model app\models\Brand */

/* $this->title = Yii::t('app', 'Add'); */
$this->params['breadcrumbs'][] = [
    'label' => Yii::t('app', 'Brands'),
    'url' => [
        'index'
    ]
];
$this->params['breadcrumbs'][] = Yii::t('app', 'Add');
?>
<div class="page-wrapper">
	<div class="wrapper">
		<div class="panel">

			<div class="brand-create">
	<?=  \app\components\PageHeader::widget(); ?>
</div>

		</div>

		<div class="content-section clearfix panel">

		<?= $this->render ( '_form', [ 'model' => $model ] )?></div>
	</div>
</div>