//
//  ProductVCModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 28/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation

class ProductVCModel: NSObject {
    

    var productId,productStateId :Int!
    
    func productListDict(dict: NSDictionary)  {
        
        productId = dict["id"] as? Int ?? 0
        productStateId = dict["state_id"] as? Int ?? 0
        
        if   let productDic = dict["product_detail"] as? NSDictionary {
          
        }
  }
}
