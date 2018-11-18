<?php
/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
namespace app\models\search;

use Yii;
use yii\base\Model;
use yii\data\ActiveDataProvider;
use app\models\Sale as SaleModel;

/**
 * Sale represents the model behind the search form about `app\models\Sale`.
 */
class Sale extends SaleModel
{
    /**
     * @inheritdoc
     */
    public function rules()
    {
        return [
            [['id', 'model_id', 'type_id', 'state_id', 'created_by_id'], 'integer'],
            [['model_type', 'title', 'discount', 'min_limit', 'comment', 'created_on'], 'safe'],
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
    public function beforeValidate(){
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
        $query = SaleModel::find();

		        $dataProvider = new ActiveDataProvider([
            'query' => $query,
            'sort' => [
						'defaultOrder' => [
								'id' => SORT_DESC
						]
				]
        ]);

        if (!($this->load($params) && $this->validate())) {
            return $dataProvider;
        }

        $query->andFilterWhere([
            'id' => $this->id,
            'model_id' => $this->model_id,
            'type_id' => $this->type_id,
            'state_id' => $this->state_id,
            'created_on' => $this->created_on,
            'created_by_id' => $this->created_by_id,
        ]);

        $query->andFilterWhere(['like', 'model_type', $this->model_type])
            ->andFilterWhere(['like', 'title', $this->title])
            ->andFilterWhere(['like', 'discount', $this->discount])
            ->andFilterWhere(['like', 'min_limit', $this->min_limit])
            ->andFilterWhere(['like', 'comment', $this->comment]);

        return $dataProvider;
    }
}
