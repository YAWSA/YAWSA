<?php

/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
namespace app\models\search;

use Yii;
use yii\base\Model;
use yii\data\ActiveDataProvider;
use app\models\Order as OrderModel;

/**
 * Order represents the model behind the search form about `app\models\Order`.
 */
class Order extends OrderModel {
	/**
	 * @inheritdoc
	 */
	public function rules() {
		return [ 
				[ 
						[ 
								'id',
								'super_order_id',
								'state_id',
								'type_id',
						],
						'integer' 
				],
				[ 
						[ 
								'shipping_charge',
								'created_on',
								'updated_on',
								'vendor_id',
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
		$query = OrderModel::find ();
		
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
		
		if ($this->created_by_id) {
			$query->joinWith ( 'createdBy as cb' );
			$query->andFilterWhere ( [ 
					'like',
					'cb.full_name',
					$this->created_by_id 
			] );
		}
		
		if ($this->vendor_id) {
			$query->joinWith ( 'vendor as v' );
			$query->andFilterWhere ( [ 
					'like',
					'v.full_name',
					$this->vendor_id 
			] );
		}
		$query->andFilterWhere ( [ 
				'id' => $this->id,
				'super_order_id' => $this->super_order_id,
				'state_id' => $this->state_id,
				'type_id' => $this->type_id,
				'created_on' => $this->created_on,
				'updated_on' => $this->updated_on 
		] );
		
		$query->andFilterWhere ( [ 
				'like',
				'shipping_charge',
				$this->shipping_charge 
		] );
		
		return $dataProvider;
	}
}
