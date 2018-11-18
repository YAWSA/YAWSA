<?php
/**
 *@copyright : ToXSL Technologies Pvt. Ltd. < www.toxsl.com >
 *@author	 : Shiv Charan Panjeta < shiv@toxsl.com >
 */
namespace app\models\search;

use Yii;
use yii\base\Model;
use yii\data\ActiveDataProvider;
use app\models\ProductVariant as ProductVariantModel;

/**
 * ProductVariant represents the model behind the search form about `app\models\ProductVariant`.
 */
class ProductVariant extends ProductVariantModel
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
                    'product_id',
                    'category_id',
                    'brand_id',
                    'color_id',
                    'size_id',
                    'quantity',
                    'state_id',
                    'type_id',
                    'created_by_id'
                ],
                'integer'
            ],
            [
                [
                    'amount',
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
        $query = ProductVariantModel::find()->alias('p')->joinWith([
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
            'p.id' => $this->id,
            'p.product_id' => $this->product_id,
            'p.category_id' => $this->category_id,
            'p.brand_id' => $this->brand_id,
            'p.color_id' => $this->color_id,
            'p.size_id' => $this->size_id,
            'p.quantity' => $this->quantity,
            'p.state_id' => $this->state_id,
            'p.type_id' => $this->type_id,
            'p.created_on' => $this->created_on,
            'p.updated_on' => $this->updated_on
        ]);
        
        $query->andFilterWhere([
            'like',
            'p.amount',
            $this->amount
        ]) ->andFilterWhere([
            'like',
            'c.full_name',
            $this->created_by_id
        ]);
        
        return $dataProvider;
    }
}
