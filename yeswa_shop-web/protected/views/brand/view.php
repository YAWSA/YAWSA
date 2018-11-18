<?php
use app\components\useraction\UserAction;
use app\modules\comment\widgets\CommentsWidget;
use yii\helpers\Html;
/* @var $this yii\web\View */
/* @var $model app\models\Brand */

/* $this->title = $model->label() .' : ' . $model->title; */
$this->params['breadcrumbs'][] = [
    'label' => Yii::t('app', 'Brands'),
    'url' => [
        'index'
    ]
];
$this->params['breadcrumbs'][] = (string) $model;
?>
<div class="page-wrapper">
	<div class="wrapper">
		<div class="panel">
			<div class="brand-view panel-body">
			<?php echo  \app\components\PageHeader::widget(['model'=>$model]); ?>
		</div>
		</div>

		<div class="panel">
			<div class="panel-body">
    <?php
    
    echo \app\components\TDetailView::widget([
        'id' => 'brand-detail-view',
        'model' => $model,
        'options' => [
            'class' => 'table table-bordered'
        ],
        'attributes' => [
            'id',
            [
                'attribute' => 'Image File',
                'format' => 'raw',
                'value' => Html::img($model->getImageUrl(true))
            ],
            
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


<?php  echo $model->description;?>


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

<?php //echo CommentsWidget::widget(['model'=>$model]); ?>
			</div>
		</div>
	</div>
</div>