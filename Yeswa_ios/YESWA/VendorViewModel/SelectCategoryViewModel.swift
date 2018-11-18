//
//  SelectCategoryViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 28/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit

class SelectCategoryViewModel: NSObject {
  
    var pageNumber = 0
    var totalPageCount = Int()
    var currentLat = String ()
    var currentLong  = String ()
    
    var categoryID = Int ()
    var brandID = Int ()
    var imagesArray = [UIImage]()
    
    var selectCategoryId = Int()
    var selectBrandId = Int ()

    
    
    // MARK:- AddBrand Api Interaction
    func addProductWithoutVarient(_ title:String, _titleDescription : String, completion:@escaping() -> Void) {
        
        let param = [
            "Product[category_id]":"\(selectCategoryId)" ,
            "Product[brand_id]":"\(selectBrandId)" ,
            "Product[title]":"\(title)" ,
            "Product[description]" : "\(_titleDescription)" ,
            ] as [String:AnyObject]
        
        var paramImage = [String:UIImage]()
        for i in 0..<self.imagesArray.count {
            paramImage["File[filename][\(i)]"] =  imagesArray[i]
        }
        
        let updateUrl = "\(Apis.KServerUrl)\(Apis.KAddProductWithoutVarient)"
        WebServiceProxy.shared.uploadImage(param, parametersImage: paramImage, addImageUrl: updateUrl, showIndicator: true) { (jsonResponse) in
            if jsonResponse["status"] as! Int == 200 {
                if  let dicProductList = jsonResponse["detail"] as? NSDictionary{
                    addProductWithoutVarientObj.proudctListDict(dict: dicProductList)
                }
                completion()
                
            } else {
                if let error = jsonResponse["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
        }
        
     
    }
}




