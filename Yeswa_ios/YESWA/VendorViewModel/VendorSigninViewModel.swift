//
//  VendorSigninViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 23/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit

class VendorSigninViewModel: NSObject {
    
    //MARK: Variables
    var emailValue = String()
    var passwordValue = String()
    
    //MARK:- Login Api Method
    func loginApiVendor(_ completion:@escaping() -> Void) {
        var deviceTokken =  ""
        if UserDefaults.standard.object(forKey: "device_token") == nil {
            deviceTokken = "000000000000000000000000000000000000000000000000000000000000055"
        } else {
            deviceTokken = UserDefaults.standard.object(forKey: "device_token")! as! String
        }
        
        let param = [
            "LoginForm[username]":"\(emailValue)" ,
            "LoginForm[password]" : "\(passwordValue)" ,
            "LoginForm[device_type]": "2" ,
            "LoginForm[device_token]" : deviceTokken ,
            "User[role_id]": "\(Role.RollVendor)"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KLogin)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let detailDict = JSON["detail"] as? NSDictionary
                {
                      KAppDelegate.profileDetaiVendor.userDict(dict: detailDict)
                    
                }
                if let auth = JSON["auth_code"] as? String {
                    UserDefaults.standard.set(auth, forKey: "auth_code")
                    UserDefaults.standard.synchronize()
                }
                completion()
                
            } else {
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
        })
    }
    
}
