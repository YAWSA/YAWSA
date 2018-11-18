//
//  OrderHistoryModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 09/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
class OrderHistoryModel: NSObject {
    
    var id = Int()
    var orderNumber = String ()
    var amount = String ()
    var houseNumber = String ()
    var country = String ()
    var state = String ()
    var zipcode = Int ()
    var street = String ()
    var orderItemArr = [CartModel]()
    var state_id = Int()
    var totalPrice = Int ()
   
    func orderListDict(dict: NSDictionary)  {
        id = dict["id"] as? Int ?? 0
        state_id = dict["state_id"] as? Int ?? 0
        orderNumber = dict["order_number"] as? String ?? ""
        amount = dict["amount"] as? String ?? ""
        
        if let CategoryList = dict["shipping_address"] as? NSDictionary {
            country = CategoryList["country"] as? String ?? ""
            houseNumber = CategoryList["house_address"] as? String ?? ""
            state  = CategoryList["state"] as? String ?? ""
            zipcode =  CategoryList["zipcode"] as? Int ?? 0
            street = CategoryList["street"] as? String ?? ""
        }
        
        if let orderItemsArray = dict["order"] as? NSArray {
            for i in 0 ..< orderItemsArray.count{
                let orderDict = orderItemsArray.object(at: i) as! NSDictionary
                let objOrderModel = CartModel()
                objOrderModel.productListDict(dict: orderDict)
                self.orderItemArr.append(objOrderModel)
            }
        }
        
        if let orderItemsArray = dict["order_items"] as? NSArray {
            for i in 0 ..< orderItemsArray.count{
                let orderDict = orderItemsArray.object(at: i) as! NSDictionary
                let objOrderModel = CartModel()
                objOrderModel.productListDict(dict: orderDict)
                self.orderItemArr.append(objOrderModel)
            }
        }
    }
}
