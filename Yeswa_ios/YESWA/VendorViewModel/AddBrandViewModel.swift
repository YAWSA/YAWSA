//
//  AddBrandViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 28/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit

class AddBrandViewModel {
    
// MARK:- Add Brand Api Interaction
    func addBrand(_ title:String, categoryID: Int, brandImg : UIImage , completion:@escaping() -> Void) {

        let param = [
            "Brand[title]":"\(title)" ,
            "Brand[category_id]" : "\(categoryID)" ,
            ] as [String:AnyObject]
        
        let paramImage = [
            "File[filename]": brandImg
        ]
        
        let updateUrl = "\(Apis.KServerUrl)\(Apis.KAddBrand)"
        WebServiceProxy.shared.uploadImage(param, parametersImage: paramImage, addImageUrl: updateUrl, showIndicator: true) { (jsonResponse) in
            if jsonResponse["status"] as! Int == 200 {
                completion()
            } else {
                if let error = jsonResponse["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
        }
    }
    
    // MARK:- Edit Brand  Api Interaction
    func editBrand(_ title:String, categoryID: Int,brandID : Int ,brandImg : UIImage , completion:@escaping() -> Void) {
    let param = [
            "Brand[title]":"\(title)" ,
            "Brand[category_id]" : "\(categoryID)" ,
            ] as [String:AnyObject]
        
        let paramImage = [
            "File[filename]": brandImg
        ]
          let updateUrl = "\(Apis.KServerUrl)\(Apis.KEditBrand)?id=\(brandID)"
         WebServiceProxy.shared.uploadImage(param, parametersImage: paramImage, addImageUrl: updateUrl, showIndicator: true) { (jsonResponse) in
        
            if jsonResponse["status"] as! Int == 200 {
                completion()
            } else {
                if let error = jsonResponse["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
        }
    }
}

