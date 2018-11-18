//
//  SignInVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 13/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class SignInVC: UIViewController,UITextFieldDelegate {
    //MRK:- Outlet
    @IBOutlet weak var imgVwLogo: UIImageView!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var vwCreateNewAccount: UIView!
    @IBOutlet weak var btnSignin: SetCornerButton!
    @IBOutlet weak var btnForgot: UIButton!
    @IBOutlet weak var lblCreateAccounts: UILabel!
    var signiInModelObj = SignInViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUpStaticsValue()
    }
    func setUpStaticsValue() {
        txtFieldPassword.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.password))
        txtFieldEmail.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.Email))
        lblCreateAccounts.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.newCreateAccount)
        btnSignin.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.signin), for: .normal)
        
        btnForgot.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.forgotPassword), for: .normal)
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        if KAppDelegate.isComeFrom == "HomeVC" {
        RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "HomeVC")
            KAppDelegate.isComeFrom = ""
        }
         else if KAppDelegate.isComeFrom == "ProductDetailCustomer"{
             Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
          }
       
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
    
// MARK:- Action Buttons ----
    @IBAction func actionForgotPassword(_ sender: UIButton) {
          Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.mainStoryboard, identifier: "ForgotPasswordVC", isAnimate: true, currentViewController:self)
    }
    
   
    
    //MARK:- Action Signin Btn
    @IBAction func actionSignIn(_ sender: UIButton) {
        if txtFieldEmail.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.email))
        }else if !Proxy.shared.isValidEmail(txtFieldEmail.trimmedValue) {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.validEmail))
        }else if txtFieldPassword.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.password))
        } else{
            signiInModelObj.emailValue = txtFieldEmail.text!
            signiInModelObj.passwordValue = txtFieldPassword.text!
            
            signiInModelObj.loginApi(){
                 RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "HomeVC")
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.loginsuccesfully))
            }
    }
}
    // MARK:- Action Creat New Account Btn
    @IBAction func actionCreateNewAccount(_ sender: UIButton) {
            Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.mainStoryboard, identifier: "CustomerSignUpDetailVC", isAnimate: true, currentViewController:self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
//MARK:- TextFieldExtension
extension UITextField {
    var isBlank : Bool {
        return (self.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
    }
    var trimmedValue : String {
        return (self.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
    }
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
}
