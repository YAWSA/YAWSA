<?php
use app\models\User;
?>
     <?php
    return [
        'user' => [
            'login' => [
                'LoginForm[username]' => 'harman',
                'LoginForm[password]' => 'admin',
                'LoginForm[device_token]' => '12131313',
                'LoginForm[device_type]' => '1',
                'User[role_id]' => User::ROLE_USER
            ],
            'signup' => [
                'User[full_name]' => 'Test String',
                'User[email]' => 'Trand' . rand(0, 499) . 'est@' . rand(0, 499) . 'String.com',
                'User[password]' => 'Test String',
                'User[contact_no]' => 'Test String',
                'User[role_id]' => '2'
            ],
            'vendor-signup' => [
                'VendorProfile[first_name]' => \Faker\Factory::create()->firstName,
                'VendorProfile[last_name]' => \Faker\Factory::create()->lastName,
                'VendorProfile[whats_app_no]' => \Faker\Factory::create()->phoneNumber,
                'VendorProfile[civil_id]' => \Faker\Factory::create()->company,
                'VendorProfile[shopname]' => \Faker\Factory::create()->name,
                'VendorAddress[location]' => \Faker\Factory::create()->text,
                'VendorLocation[latitude]' => '30.7046',
                'VendorLocation[longitude]' => '76.7179',
                'User[contact_no]' => \Faker\Factory::create()->numberBetween(10, 10),
                'User[contact_no_1]' => \Faker\Factory::create()->numberBetween(10, 10),
                'VendorAddress[city]' => \Faker\Factory::create()->city,
                'VendorAddress[area]' => \Faker\Factory::create()->address,
                'VendorAddress[block]' => \Faker\Factory::create()->name,
                'VendorAddress[street]' => \Faker\Factory::create()->name,
                'VendorAddress[house]' => \Faker\Factory::create()->name,
                'VendorAddress[apartment]' => \Faker\Factory::create()->name,
                'VendorAddress[office]' => \Faker\Factory::create()->name,
                'User[email]' => \Faker\Factory::create()->email,
                'User[password]' => 'admin@123',
                'VendorProfile[shop_logo]' => '',
                'User[role_id]' => '2'
            ],
            'change-password' => [
                'User[oldPassword]' => 'Test String',
                'User[newPassword]' => 'Test String',
                'User[confirm_password]' => 'Test String'
            ],
            'recover' => [
                'User[email]' => 'Trand' . rand(0, 499) . 'est@' . rand(0, 499) . 'String.com'
            ],
            'switch-role' => [
                'User[role_id]' => 'Test String'
            ],
            'instagram' => [
                "User[email]" => '',
                "User[userId]" => '',
                "User[provider]" => '',
                "User[full_name]" => '',
                // "User[image_url]"=>'',
                "User[device_token]" => '',
                "User[device_type]" => ''
            ],
            'update-profile' => [
              //  "User[full_name]" => Yii::$app->user->identity->full_name,
             //   "User[contact_no]" => Yii::$app->user->identity->contact_no
            ],
            'update-profile-image' => [
                "User[profile_file]" => ""
            ],
            'update-vendor-logo' => [
                "VendorProfile[shop_logo]" => ""
            ]
        ]
    ];
    ?>