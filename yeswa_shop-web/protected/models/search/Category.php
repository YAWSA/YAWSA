<?php
/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
namespace app\models\search;

use Yii;
use yii\base\Model;
use yii\data\ActiveDataProvider;
use app\models\Category as CategoryModel;

/**
 * Category represents the model behind the search form about `app\models\Category`.
 */
class Category extends CategoryModel
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
        $query = CategoryModel::find()->alias('ca')->joinWith([
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
            'ca.id' => $this->id,
            'ca.state_id' => $this->state_id,
            'ca.type_id' => $this->type_id,
            'ca.created_on' => $this->created_on,
            'ca.updated_on' => $this->updated_on,
            
        ]);
        
        $query->andFilterWhere([
            'like',
            'ca.title',
            $this->title
        ]) ->andFilterWhere([
            'like',
            'c.full_name',
            $this->created_by_id
        ]);
        
        return $dataProvider;
    }
    
    public function searchFilter($params, $page) {
    	$query = CategoryModel::find ();
    	
    	$dataProvider = new ActiveDataProvider ( [
    			'query' => $query,
    			'sort' => [
    					'defaultOrder' => [
    							'id' => SORT_DESC
    					]
    			],
    			'pagination' => [
    					'pageSize' => '20',
    					'page' => $page
    			]
    	] );
    	
    	if (! ($this->load ( $params ) && $this->validate ())) {
    		return $dataProvider;
    	}
    	
    	$query = $query->andFilterWhere ( [
    			'like',
    			'title',
    			$this->title . '%',
    			false
    	] );
    	
    	return $dataProvider;
    }
}
