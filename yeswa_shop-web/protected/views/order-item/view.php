<?php
use app\components\useraction\UserAction;
use app\modules\comment\widgets\CommentsWidget;

/* @var $this yii\web\View */
/* @var $model app\models\OrderItem */

/* $this->title = $model->label() .' : ' . $model->id; */
$this->params['breadcrumbs'][] = [
    'label' => Yii::t('app', 'Order Items'),
    'url' => [
        
        'index'
    ]
];
$this->params['breadcrumbs'][] = (string) $model;
?>
<div class="page-wrapper">
	<div class="wrapper">
		<div class="panel">
			<div class="order-item-view panel-body">
			<?php echo  \app\components\PageHeader::widget(['model'=>$model]); ?>
		</div>
		</div>

		<div class=" panel ">
			<div class=" panel-body ">
    <?php
echo \app\components\TDetailView::widget([
    'id' => 'order-item-detail-view',
    'model' => $model,
    'options' => [
        'class' => 'table table-bordered'
    ],
    'attributes' => [
        'id',
        
        [
            'attribute' => 'order_id',
            'format' => 'raw',
            'value' => $model->getRelatedDataLink('order_id')
        ],
        [
            'attribute' => 'product_variant_id',
            'format' => 'raw',
            'value' => function ($data) {
                return $data->productVariant->product;
            }
        ],
        'quantity',
        'amount',
        'expected_delivery_date:datetime',
            /*[
			'attribute' => 'type_id',
			'value' => $model->getType(),
			],*/
            /*[
			'attribute' => 'state_id',
			'format'=>'raw',
			'value' => $model->getStateBadge(),],*/
            'created_on:datetime',
        'updated_on:datetime',
        
        [
            'attribute' => 'created_by_id',
            'format' => 'raw',
            'value' => $model->getRelatedDataLink('created_by_id')
        ]
    ]
])?>


<?php  ?>


		<?php

echo UserAction::widget([
    'model' => $model,
    'attribute' => 'state_id',
    'states' => $model->getStateOptions()
]);
?>

		</div>
		</div>

		<div class=" panel ">
			<div class=" panel-body ">

<?php echo CommentsWidget::widget(['model'=>$model]); ?>
			</div>
		</div>
	</div>
</div>