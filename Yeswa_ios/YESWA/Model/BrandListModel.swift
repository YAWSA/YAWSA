//
//  BrandListModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 04/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
class BrandListModel: NSObject {
    
    //let layer = UIView(frame: CGRect(x: 89, y: 105, width: 199.53, height: 131))self.view.addSubview(layer)
    
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
