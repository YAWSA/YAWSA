//
//  SelectAreaModel.swift
//  YESWA
//
//  Created by Ankita Thakur on 10/05/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation

class SelectAreaModel: NSObject {
    
    
    var regionId,stateId :Int!
    var regionTitle :String!
    
    
    func regionDict(dict: NSDictionary)  {
        
        regionTitle = dict["state"] as? String  ?? ""
        stateId = dict["state_id"] as? Int ?? 0
        regionId = dict["id"] as? Int ?? 0
    }
}
