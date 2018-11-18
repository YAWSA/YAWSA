//
//  SelectGovernentModel.swift
//  YESWA
//
//  Created by Ankita Thakur on 10/05/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
class SelectGovernentModel: NSObject {
    
    
    var governorateId,stateId :Int!
    var governorateTitle :String!
    
    
    func governorateDict(dict: NSDictionary)  {
        
        governorateTitle = dict["country_name"] as? String  ?? ""
        stateId = dict["state_id"] as? Int ?? 0
        governorateId = dict["id"] as? Int ?? 0
    }
}
