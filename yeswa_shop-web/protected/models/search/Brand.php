<?php

/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
namespace app\models\search;

use Yii;
use yii\base\Model;
use yii\data\ActiveDataProvider;
use app\models\Brand as BrandModel;

/**
 * Brand represents the model behind the search form about `app\models\Brand`.
 */
class Brand extends BrandModel {
	
	/**
	 * @inheritdoc
	 */
	public function rules() {
		return [ 
				[ 
						[ 
								'id',
								'state_id',
								'type_id',
								'category_id' 
						],
						'integer' 
				],
				[ 
						[ 
								'title',
								'description',
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
	public function scenarios() {
		// bypass scenarios() implementation in the parent class
		return Model::scenarios ();
	}
	public function beforeValidate() {
		return true;
	}
	
	/**
	 * Creates data provider instance with search query applied
	 *
	 * @param array $params        	
	 *
	 * @return ActiveDataProvider
	 */
	public function search($params) {
		$query = BrandModel::find ()->alias ( 'b' )->joinWith ( [ 
				'createdBy as c' 
		] );
		
		$dataProvider = new ActiveDataProvider ( [ 
				'query' => $query,
				'sort' => [ 
						'defaultOrder' => [ 
								'id' => SORT_DESC 
						] 
				] 
		] );
		
		if (! ($this->load ( $params ) && $this->validate ())) {
			return $dataProvider;
		}
		
		$query->andFilterWhere ( [ 
				'b.id' => $this->id,
				'b.state_id' => $this->state_id,
				'b.category_id' => $this->category_id,
				'b.type_id' => $this->type_id,
				'b.created_on' => $this->created_on,
				'b.updated_on' => $this->updated_on 
		] );
		
		$query->andFilterWhere ( [ 
				'like',
				'b.title',
				$this->title 
		] )->andFilterWhere ( [ 
				'like',
				'b.description',
				$this->description 
		] )->andFilterWhere ( [ 
				'like',
				'c.full_name',
				$this->created_by_id 
		] );
		
		return $dataProvider;
	}
	public function searchFilter($params, $page) {
		$query = BrandModel::find ();
		
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
