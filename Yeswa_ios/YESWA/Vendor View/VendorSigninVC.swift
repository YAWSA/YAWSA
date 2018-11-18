//
//  VendorSigninVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 20/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class VendorSigninVC: UIViewController,UITextFieldDelegate {
    //Oultet
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var imgVwLogo: UIImageView!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    
    @IBOutlet weak var btnSignIn: SetCornerButton!
    @IBOutlet weak var lblCreateAccounts: UILabel!
    //Variable
    var signiInVendorModelObj  = VendorSigninViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpStaticsValue()
       
    }
    func setUpStaticsValue() {
        
        txtFieldPassword.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.password))
        txtFieldEmail.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.Email))
  lblCreateAccounts.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.newCreateAccount)
btnSignIn.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.signin), for: .normal)
        
btnForgot.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.forgotPassword), for: .normal)
        
    }
    
    //MARK:- UITextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFieldEmail {
            txtFieldPassword.becomeFirstResponder()
        }
        else {
            txtFieldPassword.resignFirstResponder()
        }
        return true
    }
    //MARK:- Action Back
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    // Action Forgot Password
    @IBAction func actionForgotPassword(_ sender: UIButton) {
        Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.vendorStoryboard, identifier: "VendorForgotPasswordVC", isAnimate: true, currentViewController:self)
    }
    
   
    
    //MARK:- Action Signin
    @IBAction func actionSignIn(_ sender: UIButton) {
        if txtFieldEmail.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.email))
        }else if !Proxy.shared.isValidEmail(txtFieldEmail.trimmedValue) {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.validEmail))
        }else if txtFieldPassword.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.password))
        } else {
            signiInVendorModelObj.emailValue = txtFieldEmail.text!
            signiInVendorModelObj.passwordValue = txtFieldPassword.text!
            signiInVendorModelObj.loginApiVendor(){
                RootControllerProxy.shared.rootWithoutDrawer(StoryboardChnage.vendorStoryboard, identifier: "CategoryVC")
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.loginsuccesfully))
            }
        }
    }
    
    // MARK:- Action Creat New Account Btn
    @IBAction func actionCreateNewAccount(_ sender: UIButton) {
        Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.vendorStoryboard, identifier: "SignUpVC", isAnimate: true, currentViewController:self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
