//
//  CustomerSignUpDetailVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 16/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class CustomerSignUpDetailVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var txtFieldLastName: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var txtFieldConfirmPassword: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var btnSignUp: SetCornerButton!
    @IBOutlet weak var lblAlreadyAccount: UILabel!
    var signUpModelObj = CustomerSignUpViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpStaticsValue()
    }
    func setUpStaticsValue() {
        
        txtFieldFirstName.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.firstName))
        txtFieldLastName.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.lastName))
        txtFieldPassword.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.password))
        txtFieldConfirmPassword.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.confirmPassword))
        txtFieldEmail.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.Email))
        
        btnSignUp.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.next), for: .normal)
        
        lblAlreadyAccount.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.alreadyLogin)
        
    }
    
    //MARK:- UITextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFieldFirstName {
            txtFieldLastName.becomeFirstResponder()
        } else if  textField == txtFieldLastName{
            txtFieldPassword.becomeFirstResponder ()
        }
        else if  textField == txtFieldPassword{
            txtFieldConfirmPassword.becomeFirstResponder ()
        }
        else if  textField == txtFieldConfirmPassword{
            txtFieldEmail.becomeFirstResponder ()
        }
        else {
            txtFieldEmail.resignFirstResponder()
        }
        return true
    }
    //MARK:- Action Back
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    //MARK:- Action Buttons ---
    @IBAction func actionNext(_ sender: UIButton) {
       
       if txtFieldFirstName.isBlank {
   Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.firstname))
        }
        else if txtFieldLastName.isBlank {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.lastName))
        }
        else if txtFieldPassword.isBlank {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.password))
        }
        else if txtFieldConfirmPassword.isBlank {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.confirmPassword))
        }
        else if txtFieldConfirmPassword.text! != txtFieldPassword.text!{
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.samePassword))
        }
     
        else if txtFieldEmail.isBlank {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.email))
        }
        else if !Proxy.shared.isValidEmail(txtFieldEmail.trimmedValue) {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.validEmail))
        }
        else {
            txtFieldFirstName.text! = (txtFieldFirstName.text?.trimmingCharacters(in: .whitespaces))!
            txtFieldLastName.text! = (txtFieldLastName.text?.trimmingCharacters(in: .whitespaces))!

            signUpModelObj.firstNameValue = txtFieldFirstName.text!
            signUpModelObj.lastNameValue = txtFieldLastName.text!
            signUpModelObj.passwordValue = txtFieldPassword.text!
            signUpModelObj.confirmPasswordValue = txtFieldConfirmPassword.text!
            signUpModelObj.emailValue = txtFieldEmail.text!
            signUpModelObj.signupApi {
             Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.mainStoryboard, identifier: "SignInVC", isAnimate: true, currentViewController: self)
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.signupsuccesfully))
                self.txtFieldFirstName.text = ""
                self.txtFieldLastName.text = ""
                self.txtFieldPassword.text = ""
                self.txtFieldConfirmPassword.text = ""
                self.txtFieldEmail.text = ""
            }
        }
    }
    @IBAction func actionAlreadyAccount(_ sender: UIButton) {
         Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.mainStoryboard, identifier: "SignInVC", isAnimate: true, currentViewController: self)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  

}
