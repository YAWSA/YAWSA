<?php
use app\components\TGridView;
use yii\grid\GridView;
use yii\widgets\Pjax;
/**
 *
 * @var yii\web\View $this
 * @var yii\data\ActiveDataProvider $dataProvider
 * @var app\models\search\VendorAddress $searchModel
 */
$dataProvider->sort->attributes=[];
?>
<?php Pjax::begin(['id'=>'vendor-address-pjax-ajax-grid','enablePushState'=>false,'enableReplaceState'=>false]); ?>
    <?php
				
echo TGridView::widget ( [ 
						'id' => 'vendor-address-ajax-grid-view',
						'enableRowClick' => false,
						'dataProvider' => $dataProvider,
						'filterModel' => $searchModel,
						'tableOptions' => [ 
								'class' => 'table table-bordered' 
						],
						'columns' => [ 
								// ['class' => 'yii\grid\SerialColumn','header'=>'<a>S.No.<a/>'],
								
								'id',
								'location',
								'city',
								'area',
								'block',
								'street',
								'house',
								'apartment' 
							/* 'office', */
							/* 'latitude', */
							/* 'longitude', */
							/*
						 * [
						 * 'attribute' => 'state_id','format'=>'raw','filter'=>isset($searchModel)?$searchModel->getStateOptions():null,
						 * 'value' => function ($data) { return $data->getStateBadge(); },],
						 */
							/*
						 * ['attribute' => 'type_id','filter'=>isset($searchModel)?$searchModel->getTypeOptions():null,
						 * 'value' => function ($data) { return $data->getType(); },],
						 */
							/* 'created_on', */
							/* 'updated_on', */
							/*
						 * [
						 * 'attribute' => 'created_by_id',
						 * 'format'=>'raw',
						 * 'value' => function ($data) { return $data->getRelatedDataLink('created_by_id'); },],
						 */
							
						/* ['class' => 'app\components\TActionColumn','header'=>'<a>Actions</a>'], */
						] 
				] );
				?>
<?php Pjax::end(); ?>
