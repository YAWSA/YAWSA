//
//  PaymentVCVendorModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 14/08/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import Foundation

class PaymentVCVendorModel: NSObject {
    
    var categoryId,stateId,typeId :Int!
    var title,subTitle,categoryImg :String!
    
    func categoryListDict(dict: NSDictionary)  {
        
        title = dict["title"] as? String ?? ""
        categoryId = dict["id"] as? Int ?? 0
        title = dict["title"] as? String  ?? ""
        stateId = dict["state_id"] as? Int ?? 0
        typeId = dict["type_id"] as? Int ?? 0
        categoryImg = dict["image_file"] as? String  ?? ""
    }
}
