<?php

/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
namespace app\modules\comment\widgets;

use app\components\TBaseWidget;
use app\models\File;
use app\modules\comment\models\Comment;
use yii\data\ActiveDataProvider;
use yii\helpers\VarDumper;
use yii\web\UploadedFile;

/**
 * This is just an example.
 */
class CommentsWidget extends TBaseWidget
{

    public $model;

    public $readOnly = false;

    public $disabled = false;

    /*
     * public function rules() {
     * return
     * [
     * [
     * 'uploaded_file'
     * ],
     * 'file',
     * 'skipOnEmpty' => true,
     * 'extensions' => 'jpg'
     * ];
     *
     * }
     */
    protected function getRecentComments()
    {
        if ($this->model == null)
            return null;
        $query = Comment::find()->where([
            'model_type' => get_class($this->model),
            'model_id' => $this->model->id
        ])->orderBy('id DESC');
        return new ActiveDataProvider([
            'query' => $query
        ]);
    }

    protected function formModel()
    {
        $comment = null;
        if ($this->readOnly == false) {
            $comment = new Comment();
            $comment->loadDefaultValues();
            $comment->model_type = get_class($this->model);
            $comment->model_id = $this->model->id;
        }
        return $comment;
    }

//     public function run()
//     {
//         if ($this->disabled)
//             return; // Do nothing
        
//         $comment = new Comment();
//         $comment->loadDefaultValues();
        
//         if (isset($_FILES['Comment'])) {
//             $uploaded_file = UploadedFile::getInstance($comment, 'file');
//             if ($uploaded_file != null && File::add($this->model, $uploaded_file)) {
//                 $_POST['Comment']['comment'] = 'File uploaded ' . $uploaded_file->getBaseName() . $uploaded_file->getExtension();
//             }
//         }
//         if (isset($_POST['Comment'])) {
            
//             $comment->load($_POST);
//             $comment->model_type = get_class($this->model);
//             $comment->model_id = $this->model->id;
//             $comment->state_id = 0;
            
//             if (! $comment->save()) {
//                 VarDumper::dump($comment->errors);
//             } else {
//                 \Yii::$app->controller->redirect(\Yii::$app->request->referrer);
//             }
//         }
//         return $this->render('comments', [
//             'comments' => $this->getRecentComments(),
//             'model' => $this->formModel()
//         ]);
//     }
}
