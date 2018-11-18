//
//  ChanagePasswordCustomerViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 23/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit

class ChanagePasswordCustomerViewModel: NSObject {
    
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

extension ChangePasswordVCCustomer : UITextFieldDelegate{
    
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
