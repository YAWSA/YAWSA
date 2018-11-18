<?php
use app\components\TGridView;
use yii\grid\GridView;
use yii\widgets\Pjax;
use yii\helpers\Html;
/**
 *
 * @var yii\web\View $this
 * @var yii\data\ActiveDataProvider $dataProvider
 * @var app\models\search\ProductVariant $searchModel
 */
$dataProvider->sort->attributes=[];
?>
<?php
if (! empty($menu))
    echo Html::a($menu['label'], $menu['url'], $menu['htmlOptions']);
?>
<?php Pjax::begin(['id'=>'product-variant-pjax-ajax-grid','enablePushState'=>false,'enableReplaceState'=>false]); ?>
    <?php
    
    echo TGridView::widget([
        'id' => 'product-variant-ajax-grid-view',
        'dataProvider' => $dataProvider,
        'filterModel' => $searchModel,
        'tableOptions' => [
            'class' => 'table table-bordered'
        ],
        'columns' => [
            // ['class' => 'yii\grid\SerialColumn','header'=>'<a>S.No.<a/>'],
            
            'id',
           /*  [
                'attribute' => 'product_id',
                'format' => 'raw',
                'value' => function ($data) {
                    return $data->getRelatedDataLink('product_id');
                }
            ], */
           
            [
                'attribute' => 'color_id',
                'format' => 'raw',
                'value' => function ($data) {
                    return $data->getRelatedDataLink('color_id');
                }
            ],
            [
                'attribute' => 'size_id',
                'format' => 'raw',
                'value' => function ($data) {
                    return $data->getRelatedDataLink('size_id');
                }
            ],
            'quantity',
            'amount',
            [
                'attribute' => 'state_id',
                'format' => 'raw',
                'filter' => isset($searchModel) ? $searchModel->getStateOptions() : null,
                'value' => function ($data) {
                    return $data->getStateBadge();
                }
            ],
            /* [
                'attribute' => 'type_id',
                'filter' => isset($searchModel) ? $searchModel->getTypeOptions() : null,
                'value' => function ($data) {
                    return $data->getType();
                }
            ], */
            'created_on:datetime',
            /* 'updated_on:datetime',*/
            /* [
				'attribute' => 'created_by_id',
				'format'=>'raw',
				'value' => function ($data) { return $data->getRelatedDataLink('created_by_id');  },
				],*/

            [
                'class' => 'app\components\TActionColumn',
                'header' => '<a>Actions</a>',
            	'template'=>'{view}{update}'
            ]
        ]
    ]);
    ?>
<?php Pjax::end(); ?>

