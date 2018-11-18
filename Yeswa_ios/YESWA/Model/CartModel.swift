//
//  CartModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 09/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
class CartModel: NSObject {
    
    var cartItemId,quantity :Int!
    var amount : String!
    var DeliveryDate = String ()
    var productVariantId = Int()
    var productObj = AddProductWithoutVarientModel()
    var productVariantModelDict = VarientModel()
    var state_id = Int()
    var orderId = Int()
    var discount = String ()

    func productListDict(dict: NSDictionary)  {
        state_id = dict["state_id"] as? Int ?? 0
        quantity = dict["quantity"] as? Int ?? 0
        productVariantId = dict["product_variant_id"] as? Int ?? 0
        cartItemId = dict["id"] as? Int ?? 0
        
        if let amountVal = dict["amount"] as? Int
        {
            amount = "\(amountVal)"
        }else if let amountValStr = dict["amount"] as? String
        {
            amount = amountValStr
        }
        DeliveryDate = dict ["expected_delivery_date"] as? String ?? ""
        orderId = dict["order_id"] as? Int ?? 0
        if let productVariantDict = dict["productVariant"] as? NSDictionary
        {
            productVariantModelDict.varientDict(dict: productVariantDict)
        }
        if   let productDic = dict["product"] as? NSDictionary {
            productObj.proudctListDict(dict: productDic)
        }
        if   let productDic = dict["shipping_address"] as? NSDictionary {
            productObj.proudctListDict(dict: productDic)
        }
    }
}
