//
//  AllVendorProductListModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 27/06/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
class AllVendorProductListModel: NSObject {
    
    var brandId,brandStateId :Int!
    var productDescription,productTitle :String!
     var imgProductArray = [ImgFileProductModel] ()
    
    func productListDict(dict: NSDictionary)  {
        productDescription = dict["description"] as? String ?? ""
        productTitle = dict["title"] as? String  ?? ""
        brandId = dict["id"] as? Int ?? 0
        brandStateId = dict["state_id"] as? Int ?? 0
        
        imgProductArray = []
        if let cartList = dict["file_list"] as? NSArray
        {
            for i in 0..<cartList.count{
                let dictImgProduct = cartList.object(at: i) as! NSDictionary
                let imgFileProductObjct = ImgFileProductModel()
                imgFileProductObjct.imgPrdouctDict(dict: dictImgProduct)
                imgProductArray.append(imgFileProductObjct)
            }
        }
       
        
      
    }
}
