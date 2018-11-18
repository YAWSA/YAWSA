//
//  HelpModelCustomer.swift
//  YESWA
//
//  Created by Sonu Sharma on 06/07/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
class HelpModelCustomer: NSObject {
    
    
   
    var contactTitle,contactDecrpiton  :String!
    
    
    func helpDict(dict: NSDictionary)  {
        
        contactTitle = dict["title"] as? String  ?? ""
         contactDecrpiton = dict["description"] as? String  ?? ""
        
    }
}
