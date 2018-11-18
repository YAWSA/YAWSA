<?php
use app\components\useraction\UserAction;
use app\modules\comment\widgets\CommentsWidget;

/* @var $this yii\web\View */
/* @var $model app\models\ProductVariant */

/* $this->title = $model->label() .' : ' . $model->id; */
$this->params['breadcrumbs'][] = [
    'label' => Yii::t('app', 'Product Variants'),
    'url' => [
        'index'
    ]
];
$this->params['breadcrumbs'][] = (string) $model;
?>
<div class="page-wrapper">
	<div class="wrapper">
		<div class="panel">
			<div class="product-variant-view panel-body">
			<?php echo  \app\components\PageHeader::widget(['model'=>$model]); ?>
		</div>
		</div>

		<div class=" panel ">
			<div class=" panel-body ">
    <?php
    
echo \app\components\TDetailView::widget([
        'id' => 'product-variant-detail-view',
        'model' => $model,
        'options' => [
            'class' => 'table table-bordered'
        ],
        'attributes' => [
            'id',
            [
                'attribute' => 'product_id',
                'format' => 'raw',
                'value' => $model->getRelatedDataLink('product_id')
            ],
           
            [
                'attribute' => 'color_id',
                'format' => 'raw',
                'value' => $model->getRelatedDataLink('color_id')
            ],
            [
                'attribute' => 'size_id',
                'format' => 'raw',
                'value' => $model->getRelatedDataLink('size_id')
            ],
            'quantity',
            'amount',
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



		<div class="panel">
			<div class="panel-body">
				<div class="product-variant-panel">


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