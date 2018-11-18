<?php

use app\components\useraction\UserAction;
use app\modules\comment\widgets\CommentsWidget;

/* @var $this yii\web\View */
/* @var $model app\models\SuperOrder */

/*$this->title =  $model->label() .' : ' . $model->id; */
$this->params['breadcrumbs'][] = ['label' => Yii::t('app', 'Super Orders'), 'url' => ['index']];
$this->params['breadcrumbs'][] = (string)$model;
?>
<div class="page-wrapper">
<div class="wrapper">
	<div class="panel">
		<div
			class="super-order-view panel-body">
			<?php echo  \app\components\PageHeader::widget(['model'=>$model]); ?>
		</div>
	</div>

	<div class=" panel ">
		<div class=" panel-body ">
    <?php echo \app\components\TDetailView::widget([
    	'id'	=> 'super-order-detail-view',
        'model' => $model,
        'options'=>['class'=>'table table-bordered'],
        'attributes' => [
            'id',
            [
			'attribute' => 'shipping_address_id',
			'format'=>'raw',
			'value' => $model->getRelatedDataLink('shipping_address_id'),
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
			'format'=>'raw',
			'value' => $model->getRelatedDataLink('created_by_id'),
			],
        ],
    ]) ?>


<?php  ?>


		<?php				echo UserAction::widget ( [
						'model' => $model,
						'attribute' => 'state_id',
						'states' => $model->getStateOptions ()
				] );
				?>

		</div>
</div>
 


	<div class="panel">
				<div class="panel-body">
					<div
						class="super-order-panel">

<?php
$this->context->startPanel();
	$this->context->addPanel('Orders', 'orders', 'Order',$model);

$this->context->endPanel();
?>
				</div>
				</div>
			</div>

	<div class=" panel ">
		<div class=" panel-body ">

<?php echo CommentsWidget::widget(['model'=>$model]); ?>
			</div>
	</div>
</div>
</div>