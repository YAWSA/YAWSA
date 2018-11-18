//
//  SignUpVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 13/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit
class SignUpVC: UIViewController,UITextFieldDelegate {
    //MARK:- Outlet
    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var txtFieldLastName: UITextField!
    @IBOutlet weak var txtFieldPassword: UITextField!
    @IBOutlet weak var txtFieldConfirmPassword: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldWhatUpNumber: UITextField!
    @IBOutlet weak var txtFieldCivilId: UITextField!
    @IBOutlet weak var txtFieldShopName: UITextField!
    @IBOutlet weak var txtFieldLocation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .lightContent
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
        }else if  textField == txtFieldEmail{
            txtFieldWhatUpNumber.becomeFirstResponder ()
        }else if  textField == txtFieldWhatUpNumber{
            txtFieldCivilId.becomeFirstResponder ()
        }
        else if  textField == txtFieldCivilId{
            txtFieldShopName.becomeFirstResponder ()
        }
        else if  textField == txtFieldShopName{
            txtFieldLocation.becomeFirstResponder ()
        }
        else {
            txtFieldLocation.resignFirstResponder()
        }
        return true
    }
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    //MARK:- Buttons Actions
    @IBAction func actionSignUp(_ sender: UIButton) {
        if txtFieldFirstName.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(AlertValue.lastName)
        }
        else if txtFieldLastName.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(AlertValue.lastName)
        }
        else if txtFieldPassword.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(AlertValue.password)
        }
        else if txtFieldConfirmPassword.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(AlertValue.confirmPassword)
            
        }
        else if txtFieldConfirmPassword.text! != txtFieldPassword.text!{
                Proxy.shared.displayStatusCodeAlert(AlertValue.samePass)
        }
        else if txtFieldEmail.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(AlertValue.email)
        }
        else if !Proxy.shared.isValidEmail(txtFieldEmail.trimmedValue) {
            Proxy.shared.displayStatusCodeAlert(AlertValue.validEmail)
        }
        else if txtFieldWhatUpNumber.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(AlertValue.whatAppNumber)
            
        }
        else if txtFieldCivilId.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(AlertValue.civilId)
            
        }
        else if txtFieldShopName.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(AlertValue.shopName)
            
        }
        else if txtFieldLocation.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(AlertValue.selectLocation)
        }
        
        else {
             RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "HomeVC")
        }
        
    }
    
    @IBAction func actionAlreadyAccontLogin(_ sender: UIButton) {
          Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.mainStoryboard, identifier: "SignInVC", isAnimate: true, currentViewController: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

   

}
