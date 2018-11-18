//
//  ProductListcustomerModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 05/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
class ProductListcustomerModel: NSObject {
    
    var productId,productStateId :Int!
    var productDescription,productTitle,amount : String!
    
    func productListDict(dict: NSDictionary)  {
        
        productId = dict["id"] as? Int ?? 0
        productStateId = dict["state_id"] as? Int ?? 0
        amount = dict["amount"] as? String ?? ""
        
        if   let productDic = dict["Product"] as? NSDictionary {
            productTitle = productDic["title"] as? String ?? ""
            productDescription = productDic["description"] as? String ?? ""
        }
    }
}
