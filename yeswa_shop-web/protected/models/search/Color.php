<?php
/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
namespace app\models\search;

use Yii;
use yii\base\Model;
use yii\data\ActiveDataProvider;
use app\models\Color as ColorModel;

/**
 * Color represents the model behind the search form about `app\models\Color`.
 */
class Color extends ColorModel
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
                    'state_id',
                    'type_id',
                    
                ],
                'integer'
            ],
            [
                [
                    'title',
                    'color_code',
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
        $query = ColorModel::find()->alias('co')->joinWith([
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
            'co.id' => $this->id,
            'co.state_id' => $this->state_id,
            'co.type_id' => $this->type_id,
            'co.created_on' => $this->created_on,
            'co.updated_on' => $this->updated_on,
            
        ]);
        
        $query->andFilterWhere([
            'like',
            'ca.title',
            $this->title
        ])->andFilterWhere([
            'like',
            'ca.color_code',
            $this->color_code
        ])->andFilterWhere([
            'like',
            'c.full_name',
            $this->created_by_id
        ]);
        
        return $dataProvider;
    }
}
