//
//  ForgotPasswordViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 23/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit

class ForgotPasswordViewModel: NSObject {
        var emailValue = String()
    
    func forgotPassword(_ completion:@escaping() -> Void) {
     
        
        let param = [
            "User[email]:":"\(emailValue)"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KForgotPassword)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                completion()
            } else {
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
        })
    }
    
}
