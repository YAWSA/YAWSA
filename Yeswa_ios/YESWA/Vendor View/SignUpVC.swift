//
//  SignUpVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 13/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

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
    @IBOutlet weak var btnNext: SetCornerButton!
    @IBOutlet weak var lblAlreadyAccount: UILabel!
    @IBOutlet weak var btnAlreadyAccount: UIButton!
    let objAutoComplete = AutoComplete ()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocation()
        setUpStaticsValue()
        if let emailStrVal = UserDefaults.standard.object(forKey: "LanguageSelect")
        {
            if  emailStrVal as! String == "0"
            {
                btnNext.semanticContentAttribute = .forceRightToLeft
            }
            else if emailStrVal as! String == "1"{
                btnNext.semanticContentAttribute = .forceLeftToRight
            }
            else{
                btnNext.semanticContentAttribute = .forceRightToLeft
            }
        }
    }
    func setUpStaticsValue() {
    
        txtFieldFirstName.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.firstName))
        txtFieldLastName.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.lastName))
        txtFieldPassword.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.password))
        txtFieldConfirmPassword.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.confirmPassword))
        txtFieldEmail.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.Email))
        txtFieldWhatUpNumber.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.whatsAppNumber))
        txtFieldCivilId.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.civilid))
        txtFieldShopName.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.shopName))
        txtFieldLocation.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.location))
        
     btnNext.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.next), for: .normal)
    btnNext.semanticContentAttribute = .forceRightToLeft
        
        lblAlreadyAccount.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.alreadyLogin)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        txtFieldLocation.text = autoCompleteModel.addressVal
        
    }
   func setLocation(){
    
    autoCompleteModel.latitude = Float(Proxy.shared.getLatitude())!
     autoCompleteModel.longitude = Float(Proxy.shared.getLongitude())!
    
    let location = CLLocation(latitude: Double( autoCompleteModel.latitude), longitude: Double( autoCompleteModel.longitude)) //changed!!!
    CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
        if error != nil {
            return
        }
        else  {
            
            let address  = placemarks?.first?.addressDictionary!["FormattedAddressLines"] as? NSArray
            self.txtFieldLocation.text = address?.componentsJoined(by: ",")
        }
    })
    }
  
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtFieldLocation {
            objAutoComplete.searchPlaces(self)
            return false
        }else{
            return true
        }

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
        else if txtFieldWhatUpNumber.isBlank {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.whatAppNumber))
            
        }
        else if txtFieldCivilId.isBlank {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.civilId))
            
        }
        else if txtFieldShopName.isBlank {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.shopName))
            
        } else if txtFieldLocation.isBlank {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.selectLocation))
        } else {
            
            txtFieldFirstName.text! = (txtFieldFirstName.text?.trimmingCharacters(in: .whitespaces))!
            txtFieldLastName.text! = (txtFieldLastName.text?.trimmingCharacters(in: .whitespaces))!
            
            saveSignUpVal.firstName = txtFieldFirstName.text!
            saveSignUpVal.lastName = txtFieldLastName.text!
            saveSignUpVal.password = txtFieldPassword.text!
            saveSignUpVal.email = txtFieldEmail.text!
            saveSignUpVal.WhatsAppNumber = txtFieldWhatUpNumber.text!
            saveSignUpVal.civilId = txtFieldCivilId.text!
            saveSignUpVal.shopname = txtFieldShopName.text!
            saveSignUpVal.location = txtFieldLocation.text!
            
            Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.vendorStoryboard, identifier: "VendorSignUpVC", isAnimate: true, currentViewController: self)
            
            self.txtFieldFirstName.text = ""
            self.txtFieldLastName.text = ""
            self.txtFieldPassword.text = ""
            self.txtFieldConfirmPassword.text = ""
            self.txtFieldEmail.text = ""
            self.txtFieldWhatUpNumber.text = ""
            self.txtFieldCivilId.text = ""
            self.txtFieldShopName.text = ""
            self.txtFieldLocation.text = ""
            //autoCompleteModel = AutoCompleteModel()
        }
    }
    
    @IBAction func actionAlreadyAccontLogin(_ sender: UIButton) {
          Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.vendorStoryboard, identifier: "VendorSigninVC", isAnimate: true, currentViewController: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

