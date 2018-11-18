<?php


/* @var $this yii\web\View */
/* @var $model app\models\SubCategory */

/* $this->title = Yii::t('app', 'Update {modelClass}: ', [
    'modelClass' => 'Sub Category',
]) . ' ' . $model->title; */
$this->params['breadcrumbs'][] = ['label' => Yii::t('app', 'Sub Categories'), 'url' => ['index']];
$this->params['breadcrumbs'][] = ['label' => $model->title, 'url' => ['view', 'id' => $model->id]];
$this->params['breadcrumbs'][] = Yii::t('app', 'Update');
?>
<div class="page-wrapper">
<div class="wrapper">
	<div class=" panel ">
		<div
			class="sub-category-update">
	<?=  \app\components\PageHeader::widget(['model' => $model]); ?>
	</div>
	</div>


	<div class="content-section clearfix panel">
		<?= $this->render ( '_form', [ 'model' => $model ] )?></div>
</div>
</div>