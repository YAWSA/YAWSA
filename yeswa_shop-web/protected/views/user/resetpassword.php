<?php
/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
use app\components\TActiveForm;
use yii\helpers\Html;
use yii\helpers\Inflector;

$this->params ['breadcrumbs'] [] = [ 
		'label' => 'Users',
		'url' => [ 
				'user/index' 
		] 
];

$this->params ['breadcrumbs'] [] = Inflector::humanize ( Yii::$app->controller->action->id );
?>
<div class="container">
	<div class="site-changepassword">
		<p>Please fill out the following fields to change password :</p>
		<br>
    <?php
				
				$form = TActiveForm::begin ( [ 
						'id' => 'changepassword-user-form',
						'options' => [ 
								'class' => 'form-horizontal' 
						],
						'fieldConfig' => [ 
								'template' => "{label}\n<div class=\"col-lg-3\">
                        {input}</div>\n<div class=\"col-lg-5\">
                        {error}</div>",
								'labelOptions' => [ 
										'class' => 'col-lg-2 control-label' 
								] 
						] 
				] );
				?>


         <?=$form->field ( $model, 'password', [ 'inputOptions' => [ 'placeholder' => '' ] ] )->passwordInput (['value'=>''])?>




        <div class="clearfix">
			<div class="col-lg-offset-3 col-lg-2">
			<?= Html::submitButton(Yii::t('app', 'Change password'), ['id'=> 'user-changepassword-form-submit','class' =>  'btn btn-primary']) ?>
			
            </div>
		</div>
    <?php TActiveForm::end(); ?>
</div>
</div>