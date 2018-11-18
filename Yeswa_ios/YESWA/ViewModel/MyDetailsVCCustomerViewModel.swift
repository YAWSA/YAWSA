//
//  MyDetailsVCCustomerViewModel.swift
//  YESWA
//
//  Created by Ankita Thakur on 30/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit

class MyDetailsVCCustomerViewModel: NSObject {
    
    var firstNameVal = String ()
    var lastNameVal = String ()
    var EmailVal = String ()
    
    func updateDetails (_ completion:@escaping() -> Void) {
        
        let param = [
            "User[first_name]:":"\(firstNameVal)" ,
            "User[last_name]" : "\(lastNameVal)" ,
            "User[email]" : "\(EmailVal)" ,
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KUpdateCustomerDetails)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let detailDict = JSON["detail"] as? NSDictionary {
                    KAppDelegate.profileDetailCustomer.userDict(dict: detailDict)
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
extension MyDetailsVCCustomer: UITextFieldDelegate {
    
    //MARK:- UITextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFieldFirstName {
            txtFieldLastName.becomeFirstResponder()
        } else if  textField == txtFieldLastName{
            txtFieldEmail.becomeFirstResponder ()
        }
        else {
            txtFieldEmail.resignFirstResponder()
        }
        return true
    }
}
