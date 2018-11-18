//
//  changePasswordViewModelVendor.swift
//  YESWA
//
//  Created by Ankita Thakur on 30/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit

class changePasswordViewModelVendor: NSObject {
    
    var newPasswordValue = String ()
    var ConfirmPasswordValue = String ()
    
    func changePassword (_ completion:@escaping() -> Void) {
        
        //User[newPassword] User[confirm_password]
        let param = [
            "User[newPassword]:":"\(newPasswordValue)" ,
            "User[confirm_password]" : "\(ConfirmPasswordValue)" ,
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KchangePasswordCustomer)", params: param, showIndicator: true, completion: { (JSON) in
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

//MARK:- Extension Class

extension ChangePasswordVCVendor : UITextFieldDelegate{
    
    //MARK:- UITextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFieldNewPassword {
            txtFieldConfirmPassword.becomeFirstResponder()
        }
        else {
            txtFieldConfirmPassword.resignFirstResponder()
        }
        return true
    }
}
