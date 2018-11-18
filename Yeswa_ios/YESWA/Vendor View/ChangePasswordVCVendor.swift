//
//  ChangePasswordVCVendor.swift
//  YESWA
//
//  Created by Sonu Sharma on 19/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class ChangePasswordVCVendor: UIViewController {
     @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txtFieldNewPassword: UITextField!
    @IBOutlet weak var txtFieldConfirmPassword: UITextField!
    
     var objChanagePasswordVendorViewModel = changePasswordViewModelVendor ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK:- Action Buttons
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func actionSave(_ sender: UIButton) {
        if txtFieldNewPassword.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.newPassword))
        }
        else if txtFieldConfirmPassword.text!.isEmpty {
        Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.confirmPassword))
        }
        else if txtFieldNewPassword.text! != txtFieldConfirmPassword.text! {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.samePassword))
        }else {
           
            objChanagePasswordVendorViewModel.newPasswordValue = txtFieldNewPassword.text!
            objChanagePasswordVendorViewModel.ConfirmPasswordValue = txtFieldConfirmPassword.text!
            
            objChanagePasswordVendorViewModel.changePassword {
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.passwordupdatedSuccessfully))
                
                Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
            }
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
