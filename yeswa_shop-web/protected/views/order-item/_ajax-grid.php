<?php
use app\components\TGridView;
use yii\grid\GridView;
use yii\widgets\Pjax;
use yii\helpers\Html;
/**
 *
 * @var yii\web\View $this
 * @var yii\data\ActiveDataProvider $dataProvider
 * @var app\models\search\OrderItem $searchModel
 */
$dataProvider->sort->attributes = [ ];
?>
<?php Pjax::begin(['id'=>'order-item-pjax-ajax-grid','enablePushState'=>false,'enableReplaceState'=>false]); ?>
    <?php
				
				echo TGridView::widget ( [ 
						'id' => 'order-item-ajax-grid-view',
						'dataProvider' => $dataProvider,
						'filterModel' => $searchModel,
						'enableRowClick' => false,
						'tableOptions' => [ 
								'class' => 'table table-bordered' 
						],
						'columns' => [ 
								// ['class' => 'yii\grid\SerialColumn','header'=>'<a>S.No.<a/>'],
								
								'id',
								
								'quantity',
								'amount',
            /* 'expected_delivery_date:datetime',*/
            [ 
										'attribute' => 'color_id',
										'label' => \Yii::t ( 'app', 'Color' ),
										'format' => 'raw',
										'value' => function ($data) {
											return isset ( $data->productVariant->color ) ? $data->productVariant->color->title : "";
										} 
								],
								[ 
										'attribute' => 'size_id',
										'label' => \Yii::t ( 'app', 'Size' ),
										'format' => 'raw',
										'value' => function ($data) {
											return isset ( $data->productVariant->size ) ? $data->productVariant->size->title : "";
										} 
								],
								[ 
										'attribute' => 'product_id',
										'label' => 'Product',
										'format' => 'raw',
										'value' => function ($data) {
											return Html::a ( isset ( $data->product ) ? $data->product->title : "", [ 
													'/product/view',
													'id' => $data->product->id 
											] );
										} 
								] 
						
						] 
				] );
				?>
<?php Pjax::end(); ?>

