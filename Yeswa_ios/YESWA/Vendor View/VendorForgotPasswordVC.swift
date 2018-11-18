//
//  VendorForgotPasswordVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 22/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class VendorForgotPasswordVC: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnSend: SetCornerButton!
    @IBOutlet weak var lblEmailHeader: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var txtFieldEmail: UITextField!
    var forgotPasswordModelObj = VendorForgotPasswordViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStaticsValue()
    }
    func setUpStaticsValue() {

lblHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.forgotPass)
        txtFieldEmail.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.enterEmail))
        btnSend.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.send), for: .normal)
        
        lblDescription.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.enterEmailDes)
        
    lblEmailHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.Email)
        
    }
    
//MARK:- Textfield Delegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFieldEmail {
            txtFieldEmail.resignFirstResponder()
        }
        return true
    }
//MARK:- Action Back
    
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
// MARK:- Action Done
    @IBAction func actionDone(_ sender: UIButton) {
        if txtFieldEmail.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.email))
        }
        else if !Proxy.shared.isValidEmail(txtFieldEmail.trimmedValue) {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.validEmail))
        }else{
            forgotPasswordModelObj.emailValue = txtFieldEmail.text!
            forgotPasswordModelObj.forgotPasswordVendor(){
           Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.changePassSucc))
            Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
        }
    }
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    

}
