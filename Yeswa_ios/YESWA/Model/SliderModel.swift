//
//  SliderModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 20/08/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
class SliderModel : NSObject {
    
    // Sale Product data
    var id,stateId: Int!
    var titleItem,discount,modelId,getProductLimit,typeId : String!
    
    var productImg = String ()
    var productImgID = Int ()
    var productTitle = String ()
    
   var productModelObj =  AddProductWithoutVarientModel ()
    func imgPrdouctDict (dict: NSDictionary){
        
        //Model Id
        if let modelIdVal = dict["model_id"] as? Int
        {
            modelId = "\(modelIdVal)"
        }else if let modelIdValStr = dict["model_id"] as? String
        {
            modelId = modelIdValStr
        }
        else if let modelIdValFloat = dict["model_id"] as? Float
        {
            modelId = "\(modelIdValFloat)"
        }
        else if let modelIdValDouble = dict["model_id"] as? Double
        {
            modelId = "\(modelIdValDouble)"
        }
        
        // Discount
        if let discountVal = dict["discount"] as? Int
        {
            discount = "\(discountVal)"
        }else if let discountValStr = dict["discount"] as? String
        {
            discount = discountValStr
        }
        else if let discountValFloat = dict["discount"] as? Float
        {
            discount = "\(discountValFloat)"
        }
        else if let discountValDouble = dict["discount"] as? Double
        {
            discount = "\(discountValDouble)"
        }
        
        if let getProductLimitVal = dict["min_limit"] as? Int
        {
            getProductLimit = "\(getProductLimitVal)"
        }else if let getProductLimitStr = dict["min_limit"] as? String
        {
            getProductLimit = getProductLimitStr
        }
        
        if let typeIdVal = dict["type_id"] as? Int
        {
            typeId = "\(typeIdVal)"
        }else if let typeIdValStr = dict["type_id"] as? String
        {
            typeId = typeIdValStr
        }
        
        id = dict["id"] as? Int ?? 0
        stateId = dict["state_id"] as? Int ?? 0
        titleItem = dict["title"] as? String ?? ""
        productImg = dict["image_file"] as? String ?? ""
        productImgID = dict["id"] as? Int ?? 0
        productTitle = dict["title"] as? String ?? ""
        
        if let prodDict = dict["product"] as? NSDictionary {
            productModelObj.handelProductDict(dict: prodDict)
        }
    }
}
