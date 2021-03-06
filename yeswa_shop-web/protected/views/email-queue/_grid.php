<?php
use app\components\TGridView;
use yii\widgets\Pjax;
use app\models\User;
use yii\helpers\Html;
use yii\helpers\Url;
/**
 *
 * @var yii\web\View $this
 * @var yii\data\ActiveDataProvider $dataProvider
 * @var app\models\search\EmailQueue $searchModel
 */

?>
<?php if (User::isAdmin()) echo Html::a('','#',['class'=>'multiple-delete glyphicon glyphicon-trash','id'=>"bulk-delete_email_queue"])?>
 <?php Pjax::begin(["enablePushState"=>false,"enableReplaceState"=>false,'id' => 'email-queue-pjax-grid']); ?>
 
    <?php
    
    echo TGridView::widget([
        'id' => 'email-queue-grid-view',
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
            /* 'from_email:email',*/
            'to_email:email',
            /* 'message:html',*/
            'subject',
            /* 'date_published:datetime',*/
            /* 'last_attempt:datetime',*/
             'date_sent:datetime',
            /* 'attempts',*/
             [
                'attribute' => 'state_id',
                'format' => 'raw',
                'filter' => isset($searchModel) ? $searchModel->getStateOptions() : null,
                'value' => function ($data) {
                    return $data->getStateBadge();
                }
            ],
            /* 'model_id',*/
            /* 'model_type',*/

            [
                'class' => 'app\components\TActionColumn',
                'template' => '{view}{update}{delete}',
                'header' => '<a>Actions</a>'
            ]
        ]
    ]);
    ?>
<?php Pjax::end(); ?>

<script>
$('#bulk-delete_email_queue').click(function(e) {
	e.preventDefault();
	 var keys = $('#email-queue-grid-view').yiiGridView('getSelectedRows');

	 if ( keys != '' ) {
		var ok = confirm("Do you really want to delete these items?");

		if( ok ) {
			$.ajax({
				url  : '<?php echo Url::toRoute(['email-queue/mass','action'=>'delete'])?>', 
				type : "POST",
				data : {
					ids : keys,
				},
				success : function( response ) {
					if ( response.status == "OK" ) {
						 $.pjax.reload({container: '#email-queue-pjax-grid'});
					}
				}
		     });
		}
	 } else {
		alert('Please select items to delete');
	 }
});
</script>

