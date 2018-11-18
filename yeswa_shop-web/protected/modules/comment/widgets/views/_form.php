<?php
/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
use app\components\TActiveForm;
use yii\helpers\Html;

/* @var $this yii\web\View */
/* @var $model use app\modules\comment\models\Comment */
/* @var $form yii\widgets\ActiveForm */

?>

<div class="comment-form">

    <?php
    
    $form = TActiveForm::begin([
        'enableAjaxValidation' => false,
        'enableClientValidation' => false
    
    ]);
    ?>
    <?php echo  $form->field($model, 'comment')->label(false)->widget ( app\components\TRichTextEditor::className (), [ 'options' => [ 'rows' => 6 ],'preset' => 'basic' ] ); //$form->field($model, 'content')->textarea(['rows' => 6]); //$form->field($model, 'content')->widget(kartik\widgets\Html5Input::className(),[]); */ ?>


    <?php  echo $form->field($model, 'file')->fileInput()->label("Upload File");?>
    
    <div class="form-group">
        <?= Html::submitButton($model->isNewRecord ? Yii::t('app', 'Add') : Yii::t('app', 'Update'), ['class' => $model->isNewRecord ? 'btn btn-success' : 'btn btn-primary']) ?>
    </div>

    <?php TActiveForm::end(); ?>

</div>
