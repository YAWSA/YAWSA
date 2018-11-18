<?php
use app\components\TGridView;
use yii\grid\GridView;
use yii\widgets\Pjax;
/**
 *
 * @var yii\web\View $this
 * @var yii\data\ActiveDataProvider $dataProvider
 * @var app\models\search\VendorProfile $searchModel
 */
$dataProvider->sort->attributes=[];
?>
<?php Pjax::begin(['id'=>'vendor-profile-pjax-ajax-grid','enablePushState'=>false,'enableReplaceState'=>false]); ?>
    <?php
				
echo TGridView::widget ( [ 
						'id' => 'vendor-profile-ajax-grid-view',
						'enableRowClick' => false,
						
						'dataProvider' => $dataProvider,
						'filterModel' => $searchModel,
						'tableOptions' => [ 
								'class' => 'table table-bordered' 
						],
						'columns' => [ 
								// ['class' => 'yii\grid\SerialColumn','header'=>'<a>S.No.<a/>'],
								
								'id',
								'title',
								'first_name',
								'last_name',
								'civil_id',
            /* 'description:html',*/
            'whats_app_no',
								'shopname',
								'shop_logo',
            /* [
			'attribute' => 'state_id','format'=>'raw','filter'=>isset($searchModel)?$searchModel->getStateOptions():null,
			'value' => function ($data) { return $data->getStateBadge();  },],*/
            /* ['attribute' => 'type_id','filter'=>isset($searchModel)?$searchModel->getTypeOptions():null,
			'value' => function ($data) { return $data->getType();  },],*/
            /* 'created_on:datetime',*/
            /* 'updated_on:datetime',*/
            /* [
				'attribute' => 'created_by_id',
				'format'=>'raw',
				'value' => function ($data) { return $data->getRelatedDataLink('created_by_id');  },
				],*/

           /*  [ 
										'class' => 'app\components\TActionColumn',
										'header' => '<a>Actions</a>' 
								]  */
						] 
				] );
				?>
<?php Pjax::end(); ?>

