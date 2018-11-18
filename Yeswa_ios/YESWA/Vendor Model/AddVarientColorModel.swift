//
//  AddVarientColorModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 29/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
class AddVarientColorModel: NSObject {
    
    var title = String ()
    var Id = Int ()
    
    func colorListDict(dict: NSDictionary)  {
        title = dict["title"] as? String ?? ""
        Id = dict["id"] as? Int ?? 0
    }
}
