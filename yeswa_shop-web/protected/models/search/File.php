<?php

/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
namespace app\models\search;

use app\models\File as FileModel;
use yii\base\Model;
use yii\data\ActiveDataProvider;

/**
 * File represents the model behind the search form about `app\models\File`.
 */
class File extends FileModel
{

    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [
                [
                    'id',
                    'model_id',
                    'state_id',
                    'type_id'
                ],
                'integer'
            ],
            [
                [
                    'title',
                    'file',
                    'size',
                    'extension',
                    'model_type',
                    'created_on',
                    'updated_on',
                    'created_by_id'
                ],
                'safe'
            ]
        ];
    }

    /**
     * @inheritdoc
     */
    public function scenarios()
    {
        // bypass scenarios() implementation in the parent class
        return Model::scenarios();
    }

    public function beforeValidate()
    {
        return true;
    }

    /**
     * Creates data provider instance with search query applied
     *
     * @param array $params
     *
     * @return ActiveDataProvider
     */
    public function search($params)
    {
        $query = FileModel::find()->alias('f')->joinWith([
            'createdBy as c'
        ]);
        
        $dataProvider = new ActiveDataProvider([
            'query' => $query,
            'sort' => [
                'defaultOrder' => [
                    'id' => SORT_DESC
                ]
            ]
        ]);
        
        if (! ($this->load($params) && $this->validate())) {
            return $dataProvider;
        }
        
        $query->andFilterWhere([
            'f.id' => $this->id,
            'f.model_id' => $this->model_id,
            'f.state_id' => $this->state_id,
            'f.type_id' => $this->type_id,
            'f.created_on' => $this->created_on,
            'f.updated_on' => $this->updated_on
        ]);
        
        $query->andFilterWhere([
            'like',
            'f.title',
            $this->title
        ])
            ->andFilterWhere([
            'like',
            'f.file',
            $this->file
        ])
            ->andFilterWhere([
            'like',
            'f.size',
            $this->size
        ])
            ->andFilterWhere([
            'like',
            'f.extension',
            $this->extension
        ])
            ->andFilterWhere([
            'like',
            'c.full_name',
            $this->created_by_id
        ]);
        
        return $dataProvider;
    }
}
