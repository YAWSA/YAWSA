<?php
use yii\widgets\Pjax;

?>

<div class="panel panel-info widget comment-view">
	<div class="panel-heading">

		<h4>Comments</h4>

	</div> 	<?php Pjax::begin(['id'=>'comments']); ?>
	<div id='comments' class="panel-body panel-body-list">


<?php if ($model &&  !Yii::$app->user->isGuest) {?>
<?=$this->render ( '_form', [ 'model' => $model ] )?>

    <?php }?>
    		<div class="content-list content-image menu-action-right">
			<ul class="list-wrapper">

<?php
echo \yii\widgets\ListView::widget([
    'dataProvider' => $comments,
    
    'summary' => false,
    
    'itemOptions' => [
        'class' => 'item'
    ],
    'itemView' => '_view',
    'options' => [
        'class' => 'list-view comment-list'
    ]
]);
?>
</ul>

		</div>
	</div><?php Pjax::end(); ?>

</div>

