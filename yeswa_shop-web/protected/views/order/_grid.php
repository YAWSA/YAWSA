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
 * @var app\models\search\Order $searchModel
 */

?>
<?php Pjax::begin(['id'=>'order-pjax-grid']); ?>
    <?php
				
				echo TGridView::widget ( [ 
						'id' => 'order-grid-view',
						'dataProvider' => $dataProvider,
						'filterModel' => $searchModel,
						'tableOptions' => [ 
								'class' => 'table table-bordered' 
						],
						'columns' => [ 
								// ['class' => 'yii\grid\SerialColumn','header'=>'<a>S.No.<a/>'],
								/* [ 
										'name' => 'check',
										'class' => 'yii\grid\CheckboxColumn',
										'visible' => User::isAdmin () 
								], */
								
								'id',
								[ 
										'attribute' => 'order_number',
										'format' => 'raw',
										'header' => '<a>Order Number</a>',
										'value' => function ($data) {
											return isset ( $data->superOrder ) ? $data->superOrder->order_number : "";
										} 
								],
								[ 
										'attribute' => 'vendor_id',
										'label' => \Yii::t ( 'app', 'Vendor' ),
										'format' => 'raw',
										'value' => function ($data) {
											return isset ( $data->vendor ) ? $data->vendor->full_name : "";
										} 
								],
								'shipping_charge',
								[ 
										'attribute' => 'state_id',
										'format' => 'raw',
										'filter' => isset ( $searchModel ) ? $searchModel->getStateOptions () : null,
										'value' => function ($data) {
											return $data->getStateBadge ();
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
											return $data->getRelatedDataLink ( 'created_by_id' );
										} 
								],
								
								[ 
										'class' => 'app\components\TActionColumn',
										'header' => '<a>Actions</a>',
										'template' => '{view}' 
								] 
						] 
				] );
				?>
<?php Pjax::end(); ?>
<script> 
$('#bulk_delete_order-grid').click(function(e) {
	e.preventDefault();
	 var keys = $('#order-grid-view').yiiGridView('getSelectedRows');

	 if ( keys != '' ) {
		var ok = confirm("Do you really want to delete these items?");

		if( ok ) {
			$.ajax({
				url  : '<?php echo Url::toRoute(['order/mass','action'=>'delete'])?>', 
				type : "POST",
				data : {
					ids : keys,
				},
				success : function( response ) {
					if ( response.status == "OK" ) {
						 $.pjax.reload({container: '#order-pjax-grid'});
					}
				}
		     });
		}
	 } else {
		alert('Please select items to delete');
	 }
});

</script>

