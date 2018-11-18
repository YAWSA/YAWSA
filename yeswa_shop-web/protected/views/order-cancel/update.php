<?php


/* @var $this yii\web\View */
/* @var $model app\models\OrderCancel */

/* $this->title = Yii::t('app', 'Update {modelClass}: ', [
    'modelClass' => 'Order Cancel',
]) . ' ' . $model->id; */
$this->params['breadcrumbs'][] = ['label' => Yii::t('app', 'Order Cancels'), 'url' => ['index']];
$this->params['breadcrumbs'][] = ['label' => $model->id, 'url' => ['view', 'id' => $model->id]];
$this->params['breadcrumbs'][] = Yii::t('app', 'Update');
?>
<div class="page-wrapper">
<div class="wrapper">
	<div class=" panel ">
		<div
			class="order-cancel-update">
	<?=  \app\components\PageHeader::widget(['model' => $model]); ?>
	</div>
	</div>


	<div class="content-section clearfix panel">
		<?= $this->render ( '_form', [ 'model' => $model ] )?></div>
</div>
</div>