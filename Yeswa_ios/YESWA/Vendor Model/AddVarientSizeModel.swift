//
//  AddVarientSizeModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 29/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
class AddVarientSizeModel: NSObject {
    
    var title = String ()
    var Id = Int ()
    
    
    func sizeListDict(dict: NSDictionary)  {
        
        title = dict["title"] as? String ?? ""
        Id = dict["id"] as? Int ?? 0
}
}
