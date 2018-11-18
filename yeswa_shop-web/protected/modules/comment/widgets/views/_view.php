<?php
use yii\helpers\Html;
?>

<li><div class="items">
		<div class="menu-icon">
	<?php echo Html::img(['/user/download','profile_file'=>Yii::$app->user->identity->profile_file],['height'=>'50','width'=>'50'])?>
		</div>
		<div class="menu-text">
			<p><?php echo $model->comment?> </p>
			<ul class="nav" style="display: inline;"></ul>
		</div>
		<div class="menu-text">
			<div class="menu-info">
		<?php if(isset($model->created_by_id)) {?>
				<?= $model->createdBy->linkify() ?> - <span class="menu-date"><?= \yii::$app->formatter->asDatetime($model->created_on)?> </span>
			<?php } else {?>
			<?= !empty($model->getModel()) ? $model->getModel()->linkify() : '' ?> - <span class="menu-date"><?= \yii::$app->formatter->asDatetime($model->created_on)?> </span>
			<?php }?>

			</div>

			<div class="menu-text" style="text-align: right">
			<?php

echo Html::a('Delete', $model->getUrl('delete'), [
    'class' => 'label label-danger',
    'data' => [
        'method' => 'POST',
        
        'confirm' => Yii::t('app', 'Are you sure you want to delete this ?')
    ]
]);
?>
</div>
		</div>
	</div></li>
<div class="clearfix"></div>





