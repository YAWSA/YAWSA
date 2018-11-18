<?php

use app\components\TGridView;
use phpnt\exportFile\ExportFile;
/* @var $searchModel \common\models\GeoCitySearch */
/* @var $dataProvider yii\data\ActiveDataProvider */

echo ExportFile::widget([
    'model' => "app\models\search\User", // путь к модели
    'searchAttributes' => $searchModel 
])?>






<?= TGridView::widget([
    'dataProvider'  => $dataProvider,
    'filterModel'   => $searchModel,
    'columns' => [
        'id',
        'full_name'
    ]
]);
?>