//
//  ChangePasswordVCCustomer.swift
//  YESWA
//
//  Created by Sonu Sharma on 19/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class ChangePasswordVCCustomer: UIViewController {
    
    
    //MARK:- Outlet
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txtFieldNewPassword: UITextField!
    @IBOutlet weak var txtFieldConfirmPassword: UITextField!
    
    @IBOutlet weak var btnSave: SetCornerButton!
    //variable
    var objChanagePasswordCustomerViewModel = ChanagePasswordCustomerViewModel ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtFieldNewPassword.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.newPassword))
        txtFieldConfirmPassword.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.confirmPassword))
        
        lblHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.changePass)
   
        btnSave.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.saveChanges), for: .normal)
        
        
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
            Proxy.shared.displayStatusCodeAlert( Proxy.shared.languageSelectedStringForKey(AlertValue.confirmPassword))
        }
        else if txtFieldNewPassword.text! != txtFieldConfirmPassword.text! {
            Proxy.shared.displayStatusCodeAlert( Proxy.shared.languageSelectedStringForKey(AlertValue.samePassword))
        }else {
            
            objChanagePasswordCustomerViewModel.newPasswordValue = txtFieldNewPassword.text!
            objChanagePasswordCustomerViewModel.ConfirmPasswordValue = txtFieldConfirmPassword.text!
            
            objChanagePasswordCustomerViewModel.changePassword {
            Proxy.shared.displayStatusCodeAlert( Proxy.shared.languageSelectedStringForKey(AlertValue.passwordupdatedSuccessfully))
                
                Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
                }
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
