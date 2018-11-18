<?php
/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
namespace app\models\search;

use Yii;
use yii\base\Model;
use yii\data\ActiveDataProvider;
use app\models\Size as SizeModel;

/**
 * Size represents the model behind the search form about `app\models\Size`.
 */
class Size extends SizeModel
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
                    'type_id'
                ],
                'integer'
            ],
            [
                [
                    'title',
                    'symbol',
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
        $query = SizeModel::find()->alias('s')->joinWith([
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
            's.id' => $this->id,
            's.state_id' => $this->state_id,
            's.type_id' => $this->type_id,
            's.created_on' => $this->created_on,
            's.updated_on' => $this->updated_on
        ]);
        
        $query->andFilterWhere([
            'like',
            's.title',
            $this->title
        ])
            ->andFilterWhere([
            'like',
            's.symbol',
            $this->symbol
        ])
            ->andFilterWhere([
            'like',
            'c.full_name',
            $this->created_by_id
        ]);
        
        return $dataProvider;
    }
}
