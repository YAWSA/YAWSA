<?php  
 

return [
	"order" => [
		"add" => [
			"Order[super_order_id]" => "1",
			"Order[vendor_id]" => "1",
			"Order[shipping_charge]" => "\Helper::faker()->text(10)",
			"Order[state_id]" => "0",
			"Order[type_id]" => "0",
			"Order[created_on]" => "2018-04-10 18:16:12",
			"Order[updated_on]" => "2018-04-10 18:16:12",
			"Order[created_by_id]" => "1",
			],
		"update?id={id}"=>  [
			"Order[super_order_id]" => "1",
			"Order[vendor_id]" => "1",
			"Order[shipping_charge]" => "\Helper::faker()->text(10)",
			"Order[state_id]" => "0",
			"Order[type_id]" => "0",
			"Order[created_on]" => "2018-04-10 18:16:12",
			"Order[updated_on]" => "2018-04-10 18:16:12",
			"Order[created_by_id]" => "1",
			],
		"index" => [],
	    "order-cancel?id={}" => [],
	    "order-list?state_id={}" => [],
		"get?id={}" => [],
		"delete?id={}" => []
	]
];
?>
