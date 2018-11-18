//
//  AddCategoryVCModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 27/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation

class AddCategoryVCModel: NSObject {
    
    var id :Int!
    var brandDescription,title :String!
    
func ProductListDict(dict: NSDictionary)  {
        
        brandDescription = dict["description"] as? String ?? ""
        id = dict["id"] as? Int ?? 0
        title = dict["title"] as? String  ?? ""
    }
}
