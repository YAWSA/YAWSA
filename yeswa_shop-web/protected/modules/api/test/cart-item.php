<?php  
 

return [
	"cart-item" => [
		"add" => [
			"CartItem[vendor_id]" => 1,
			"CartItem[product_variant_id]" => 1,
			"CartItem[quantity]" => \Faker\Factory::create()->text(10),
			"CartItem[amount]" => \Faker\Factory::create()->text(10),
			"CartItem[state_id]" => 0,
			"CartItem[type_id]" => 0,
			"CartItem[created_on]" => "2018-03-21 10:03:57",
			"CartItem[updated_on]" => "2018-03-21 10:03:57",
			"CartItem[created_by_id]" => 1,
			],
		"update?id={id}"=>  [
			"CartItem[vendor_id]" => 1,
			"CartItem[product_variant_id]" => 1,
			"CartItem[quantity]" => \Faker\Factory::create()->text(10),
			"CartItem[amount]" => \Faker\Factory::create()->text(10),
			"CartItem[state_id]" => 0,
			"CartItem[type_id]" => 0,
			"CartItem[created_on]" => "2018-03-21 10:03:57",
			"CartItem[updated_on]" => "2018-03-21 10:03:57",
			"CartItem[created_by_id]" => 1,
			],
		"index" => [],
		"get?id={}" => [],
		"delete?id={}" => []
	]
];
?>
