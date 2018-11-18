//
//  CheckOutViewModel.swift
//  YESWA
//
//  Created by Ankita Thakur on 02/05/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit

class CheckOutViewModel: NSObject {
    
// MARK:- Place an order Api Interaction
    func placeOrderApi(_ houseAddress: String,streetAddres : String ,country:String ,state:String,MobileNo1: String,state_id: Int , mobileNo2 : String ,  completion:@escaping() -> Void)   {

        let param = [
            "ShippingAddress[state_id]"  : state_id,
            "ShippingAddress[house_address]" : houseAddress ,
            "ShippingAddress[street]" : streetAddres ,
            "ShippingAddress[country]" :  country,
            "ShippingAddress[state]" :state,
            "ShippingAddress[phone_number1]" :MobileNo1,
            "ShippingAddress[phone_number2]" : mobileNo2 ,
            "ShippingAddress[payment_mode]" : PaymentMode.CASH
            ] as [String:AnyObject]

        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KPlaceOrder)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                completion()
            } else {
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
        })
    }
}


