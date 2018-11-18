<?php
return [
    "product" => [
        "add" => [
            "Product[title]" => \Faker\Factory::create()->text(10),
            "Product[description]" => \Faker\Factory::create()->text(10),
            "Product[category_id]" => 1,
            "Product[brand_id]" => 1,
            "Product[state_id]" => 1,
            "Product[type_id]" => 0,
            "Product[created_on]" => date('Y-m-d H:i:s'),
            "Product[updated_on]" => date('Y-m-d H:i:s'),
            "File[filename]" => '',
            "Product[created_by_id]" => Yii::$app->user->id
        ],
        "add-product-variant?id=" => [
            "ProductVariant[items]" => '[{"color_id":"1","amount":"555","detail":[{"size_id":"2","quantity":"5225"},{"size_id":"1","quantity":"555"}]}]',
            "ProductVariant[state_id]" => 1,
            "ProductVariant[type_id]" => 0,
            "ProductVariant[created_on]" => date('Y-m-d H:i:s'),
            "ProductVariant[updated_on]" => date('Y-m-d H:i:s'),
            "ProductVariant[created_by_id]" => Yii::$app->user->id
        ], // Product Variant ID
        'update-variant?id=' => [
            "ProductVariant[items]" => '[{"size_id":"1","amount":"555","quantity":"5225"}]',
            "ProductVariant[state_id]" => 1,
            "ProductVariant[type_id]" => 0,
            "ProductVariant[created_on]" => date('Y-m-d H:i:s'),
            "ProductVariant[updated_on]" => date('Y-m-d H:i:s'),
            "ProductVariant[created_by_id]" => Yii::$app->user->id
        ],
        "update?id={id}" => [
            "Product[title]" => \Faker\Factory::create()->text(10),
            "Product[description]" => \Faker\Factory::create()->text(10),
            "Product[category_id]" => 1,
            "Product[brand_id]" => 1,
            "ProductVariant[items]" => '[{"size_id":"1","color_id":"1","amount":"555","quantity":"5225"}]',
            "Product[state_id]" => 0,
            "Product[type_id]" => 0,
            "Product[created_on]" => "2018-03-19 10:39:52",
            "Product[updated_on]" => "2018-03-19 10:39:52",
            "Product[created_by_id]" => Yii::$app->user->id
        ],
        "update-brand?id={id}" => [
            "Brand[category_id]" => 1,
            "Brand[title]" => \Faker\Factory::create()->text(10),
            "File[filename]" => ''
        ],
        "add-to-cart" => [
            "Cart[state_id]" => 0,
            "Cart[type_id]" => 0,
            "Cart[created_on]" => "2018-03-21 10:03:00",
            "Cart[updated_on]" => "2018-03-21 10:03:00",
            "Cart[created_by_id]" => 1,
            "CartItem[product_variant_id]" => 1,
            "CartItem[quantity]" => 1,
            "CartItem[amount]" => 1
        ],
        "add-to-order" => [
            "ShippingAddress[state_id]" => 20,
            "ShippingAddress[house_address]" => 1234,
            "ShippingAddress[country]" => "capital governorate",
            "ShippingAddress[state]" => "AL Qudsiya",
            "ShippingAddress[phone_number1]" => 12341234,
            "ShippingAddress[phone_number2]" => 124564341234,
            "ShippingAddress[payment_mode]" => 0,
            "ShippingAddress[street]" => "fvgrkuegoue"
            // "ShippingAddress[house_address]" => \Faker\Factory::create()->text(10),
            // "ShippingAddress[country]" => \Faker\Factory::create()->text(10),
            // "ShippingAddress[state]" => \Faker\Factory::create()->text(10),
            // "ShippingAddress[zipcode]" => 123654
        ],
        "country" => [
            "Country[country]" => \Faker\Factory::create()->text(10)
        
        ],
        "add-brand" => [
            "Brand[category_id]" => 1,
            "Brand[title]" => \Faker\Factory::create()->text(10),
            "File[filename]" => ''
        ],
        "category-list" => [],
        "get-brand-list?catid=" => [],
        "get-myproduct-list?brandid=" => [],
        "get-all-brand-list" => [],
        "get-country" => [],
        "get-state?countryId=" => [],
        "get-all-product-list" => [],
        "index" => [],
        "get?id=" => [],
        "delete?id={}" => [],
        "delete-product-image?id=" => []
    ]
];
?>
