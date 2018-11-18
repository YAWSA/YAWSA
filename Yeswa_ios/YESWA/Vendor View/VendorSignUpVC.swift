//
//  VendorSignUpVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 16/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class VendorSignUpVC: UIViewController,UITextFieldDelegate,passImageDelegate {
    //Outlet
    @IBOutlet weak var btnAlreadyAccount: UILabel!
    @IBOutlet weak var btnSignup: SetCornerButton!
    @IBOutlet weak var txtFieldPhoneNumber1: UITextField!
    @IBOutlet weak var txtFieldPhoneNumber2: UITextField!
    @IBOutlet weak var txtFieldCity: UITextField!
    @IBOutlet weak var txtFieldBlock: UITextField!
    @IBOutlet weak var txtFieldArea: UITextField!
    @IBOutlet weak var txtFieldStreet: UITextField!
    @IBOutlet weak var txtFieldHouse: UITextField!
    @IBOutlet weak var txtFieldApartment: UITextField!
    @IBOutlet weak var txtFieldOffice: UITextField!
    @IBOutlet weak var imgVwShopLogo: UIImageView!
    
    //variable
    var signUpVendorModelObj = VendorSignupViewModel()
    var galleryFunctions =  GalleryCameraImage()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCameraImageObj = self
        setUpStaticsValue()
    }
    func setUpStaticsValue() {
btnAlreadyAccount.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.alreadyLogin)

btnSignup.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.signup), for: .normal)
txtFieldPhoneNumber1.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.mobile1))
txtFieldPhoneNumber2.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.mobile2))
txtFieldCity.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.city))
txtFieldBlock.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.block))
txtFieldArea.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.area))
txtFieldStreet.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.street))
txtFieldHouse.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.house))
txtFieldApartment.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.appartment))
txtFieldOffice.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.office))
        
    }
    
//MARK:- UITextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFieldPhoneNumber1 {
            txtFieldPhoneNumber2.becomeFirstResponder()
        }
        else if  textField == txtFieldPhoneNumber2{
            txtFieldCity.becomeFirstResponder ()
        }else if  textField == txtFieldCity{
            txtFieldArea.becomeFirstResponder ()
        }
        else if  textField == txtFieldArea{
            txtFieldBlock.becomeFirstResponder ()
        }
        else if  textField == txtFieldBlock{
            txtFieldStreet.becomeFirstResponder ()
        }else if  textField == txtFieldStreet{
            txtFieldHouse.becomeFirstResponder ()
        }else if  textField == txtFieldHouse{
            txtFieldApartment.becomeFirstResponder ()
        }
        else if  textField == txtFieldApartment{
            txtFieldOffice.becomeFirstResponder ()
        }
        else {
            txtFieldOffice.resignFirstResponder()
        }
        return true
    }
    //AMRK:- Action Buttons
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    //MARK:- Action Camera
    @IBAction func actionCamera(_ sender: UIButton) {
         galleryFunctions.customActionSheet()
    }
    
    func passSelectedimage(selectImage: UIImage) {
        imgVwShopLogo.image = selectImage
    }
    
    //MARK:- Actoin Buttons
    @IBAction func actionSignUp(_ sender: UIButton) {
        
        if txtFieldPhoneNumber1.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.phoneNumber))
        }
        else if txtFieldPhoneNumber2.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.phoneNumber))
        }
        else if txtFieldCity.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.city))
        }
        else if txtFieldArea.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.area))

        }
        else if txtFieldBlock.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.block))
        }

        else if txtFieldStreet.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.street))
        }

        else if txtFieldHouse.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.house))

        }
        else if txtFieldApartment.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.appartment))
        }
        else if txtFieldOffice.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.office))

        } else{
            signUpVendorModelObj.contactNumber1 = txtFieldPhoneNumber1.text!
             signUpVendorModelObj.contactNumber2 = txtFieldPhoneNumber2.text!
            signUpVendorModelObj.city = txtFieldCity.text!
            signUpVendorModelObj.area = txtFieldArea.text!
            signUpVendorModelObj.block = txtFieldBlock.text!
            signUpVendorModelObj.street =  txtFieldStreet.text!
            signUpVendorModelObj.house =  txtFieldHouse.text!
            signUpVendorModelObj.apartment =  txtFieldApartment.text!
            signUpVendorModelObj.office =  txtFieldOffice.text!
            signUpVendorModelObj.shopLogo = imgVwShopLogo.image!
            
            let alertController = UIAlertController(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.locationSetting), message: Proxy.shared.languageSelectedStringForKey(ConstantValue.showLocation), preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.no), style: .default) { (action:UIAlertAction!) in
                self.signUpVendorModelObj.islocationTrack = 0
                 self.hitApi()
                
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.yes), style: .cancel) { (action:UIAlertAction!) in
                self.signUpVendorModelObj.islocationTrack = 1
                self.hitApi()
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
       }
    }
    
    func hitApi (){
        signUpVendorModelObj.signupApi {
            Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.vendorStoryboard, identifier: "VendorSigninVC", isAnimate: true, currentViewController: self)
            Proxy.shared.displayStatusCodeAlert( Proxy.shared.languageSelectedStringForKey(AlertValue.signupsuccesfully))
            
            self.txtFieldPhoneNumber1.text = ""
            self.txtFieldPhoneNumber2.text = ""
            self.txtFieldCity.text = ""
            self.txtFieldBlock.text = ""
            self.txtFieldArea.text = ""
            self.txtFieldStreet.text = ""
            self.txtFieldHouse.text = ""
            self.txtFieldApartment.text = ""
            self.txtFieldOffice.text = ""
            self.imgVwShopLogo.image = UIImage(named: "ic_signin_logo")
            autoCompleteModel = AutoCompleteModel()
        }
    }
    //MARK:- Action AlreadyAnAccount Btn
    @IBAction func actionAlreadyAnAcccount(_ sender: UIButton) {
         Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.vendorStoryboard, identifier: "VendorSigninVC", isAnimate: true, currentViewController: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
