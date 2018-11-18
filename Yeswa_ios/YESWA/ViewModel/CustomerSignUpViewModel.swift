//
//  CustomerSignUpViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 22/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
class CustomerSignUpViewModel: NSObject {
    
    var firstNameValue = String()
    var emailValue = String ()
    var lastNameValue = String ()
    var passwordValue = String()
    var confirmPasswordValue = String()
    
    //MARK:- Signup Api Method
    func signupApi(_ completion:@escaping() -> Void) {
        var deviceTokken =  ""
        if UserDefaults.standard.object(forKey: "device_token") == nil {
            deviceTokken = "000000000000000000000000000000000000000000000000000000000000055"
        } else {
            deviceTokken = UserDefaults.standard.object(forKey: "device_token")! as! String
        }
        let param = [
            "User[first_name]:":"\(firstNameValue)" ,
            "User[last_name]:":"\(lastNameValue)",
            "User[email]" : "\(emailValue)" ,
            "User[password]": "\(passwordValue)" ,
            "User[role_id]": "\(Role.RollCustomer)" ,
            ] as [String:AnyObject]

        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KSignUp)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let detailDict = JSON["detail"] as? NSDictionary
                {
                     KAppDelegate.profileDetailCustomer.userDict(dict: detailDict)
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


