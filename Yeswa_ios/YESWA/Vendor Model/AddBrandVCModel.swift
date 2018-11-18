//
//  AddBrandVCModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 28/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
class AddBrandVCModel: NSObject {
    
    
    var categoryId,stateId,typeId :Int!
    var title,subTitle :String!
    
    func categoryListDict(dict: NSDictionary)  {
        
        title = dict["title"] as? String ?? ""
        categoryId = dict["id"] as? Int ?? 0
        title = dict["title"] as? String  ?? ""
        stateId = dict["state_id"] as? Int ?? 0
        typeId = dict["type_id"] as? Int ?? 0
  }
}
