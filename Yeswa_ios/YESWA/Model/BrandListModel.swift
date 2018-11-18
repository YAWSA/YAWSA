//
//  BrandListModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 04/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
class BrandListModel: NSObject {
    
    
    var brandId,stateId,typeId :Int!
    var title,subTitle,brandImg :String!
    
    
    func brandListDict(dict: NSDictionary)  {
        
        title = dict["title"] as? String ?? ""
        brandId = dict["id"] as? Int ?? 0
        title = dict["title"] as? String  ?? ""
        stateId = dict["state_id"] as? Int ?? 0
        typeId = dict["type_id"] as? Int ?? 0
        brandImg = dict["profile_file"] as? String  ?? ""
    }
}
