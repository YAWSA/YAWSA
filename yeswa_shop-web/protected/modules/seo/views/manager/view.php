<?php

use yii\helpers\Html;
use app\components\useraction\UserAction;

/* @var $this yii\web\View */
/* @var $model app\models\Seo */

/*$this->title =  $model->label() .' : ' . $model->title; */
$this->params['breadcrumbs'][] = ['label' => Yii::t('app', 'Seos'), 'url' => ['index']];
$this->params['breadcrumbs'][] = (string)$model;
?>

<div class="wrapper">
	<div class=" panel ">

		<div
			class="seo-view panel-body">
			<?php echo  \app\components\PageHeader::widget(); ?>



		</div>
	</div>

	<div class=" panel ">
		<div class=" panel-body ">
    <?php echo \app\components\TDetailView::widget([
    	'id'	=> 'seo-detail-view',
        'model' => $model,
        'options'=>['class'=>'table table-bordered'],
        'attributes' => [
            'id',
            'route',
            'title',
            'keywords',
            /*'description:html',*/
            'data',
            /* 'created_on:datetime',
            'updated_on:datetime', */
        ],
    ]) ?>


<?php  echo $model->description;?>
	</div>
 </div>

	</div>
</div>