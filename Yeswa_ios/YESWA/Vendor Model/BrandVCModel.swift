//
//  BrandVCModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 27/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
var objbrandVcModel = BrandVCModel ()
class BrandVCModel: NSObject {

    var brandId,brandStateId :Int!
    var brandDescription,brandTitle,brandFile :String!
    
    func brandListDict(dict: NSDictionary)  {
        brandDescription = dict["description"] as? String ?? ""
        brandTitle = dict["title"] as? String  ?? ""
        brandId = dict["id"] as? Int ?? 0
        brandStateId = dict["state_id"] as? Int ?? 0
        brandFile = dict["profile_file"] as? String  ?? ""
  }
}
