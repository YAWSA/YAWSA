<?php
use app\components\TGridView;
use yii\helpers\Html;
use yii\helpers\Url;

use app\models\User;

use yii\grid\GridView;
use yii\widgets\Pjax;
/**
 *
 * @var yii\web\View $this
 * @var yii\data\ActiveDataProvider $dataProvider
 * @var app\models\search\ProductVariant $searchModel
 */

?>
<?php if (User::isAdmin()) echo Html::a('','#',['class'=>'multiple-delete glyphicon glyphicon-trash','id'=>"bulk_delete_product-variant-grid"])?>
<?php Pjax::begin(['id'=>'product-variant-pjax-grid']); ?>
    <?php
    
    echo TGridView::widget([
        'id' => 'product-variant-grid-view',
        'dataProvider' => $dataProvider,
        'filterModel' => $searchModel,
        'tableOptions' => [
            'class' => 'table table-bordered'
        ],
        'columns' => [
            // ['class' => 'yii\grid\SerialColumn','header'=>'<a>S.No.<a/>'],
            [
                'name' => 'check',
                'class' => 'yii\grid\CheckboxColumn',
                'visible' => User::isAdmin()
            ],
            
            'id',
            [
                'attribute' => 'product_id',
                'format' => 'raw',
                'value' => function ($data) {
                    return $data->getRelatedDataLink('product_id');
                }
            ],
            [
                'attribute' => 'category_id',
                'format' => 'raw',
                'value' => function ($data) {
                    return $data->getRelatedDataLink('category_id');
                }
            ],
            [
                'attribute' => 'brand_id',
                'format' => 'raw',
                'value' => function ($data) {
                    return $data->getRelatedDataLink('brand_id');
                }
            ],
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
            /* ['attribute' => 'type_id','filter'=>isset($searchModel)?$searchModel->getTypeOptions():null,
			'value' => function ($data) { return $data->getType();  },],*/
            'created_on:datetime',
            /* 'updated_on:datetime',*/
            [
                'attribute' => 'created_by_id',
                'format' => 'raw',
                'value' => function ($data) {
                    return $data->getRelatedDataLink('created_by_id');
                }
            ],
            
            [
                'class' => 'app\components\TActionColumn',
                'header' => '<a>Actions</a>'
            ]
        ]
    ]);
    ?>
<?php Pjax::end(); ?>
<script> 
$('#bulk_delete_product-variant-grid').click(function(e) {
	e.preventDefault();
	 var keys = $('#product-variant-grid-view').yiiGridView('getSelectedRows');

	 if ( keys != '' ) {
		var ok = confirm("Do you really want to delete these items?");

		if( ok ) {
			$.ajax({
				url  : '<?php echo Url::toRoute(['product-variant/mass','action'=>'delete'])?>', 
				type : "POST",
				data : {
					ids : keys,
				},
				success : function( response ) {
					if ( response.status == "OK" ) {
						 $.pjax.reload({container: '#product-variant-pjax-grid'});
					}
				}
		     });
		}
	 } else {
		alert('Please select items to delete');
	 }
});

</script>

