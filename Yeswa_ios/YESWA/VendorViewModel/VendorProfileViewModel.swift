//
//  VendorProfileViewModel.swift
//  YESWA
//
//  Created by Ankita Thakur on 17/05/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
class VendorProfileViewModel {
    
    func checkLocationOnOff(_ completion:@escaping() -> Void) {
        
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KChangeLocationSetting)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let detailDict = JSON["detail"] as? NSDictionary
                {
                    KAppDelegate.profileDetaiVendor.userDict(dict: detailDict)
                }
                 completion()
                
            }else{
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
           
        }
        
    }
    
}






//MARK:- Extension Class
extension VendorProfileVC: UITextFieldDelegate {
    
    func showVendorDetails (){
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
        txtFieldFirstName.text = KAppDelegate.profileDetaiVendor.firstName
        txtfieldLastName.text = KAppDelegate.profileDetaiVendor.lastName
        txtFieldEmail.text = KAppDelegate.profileDetaiVendor.emailId
        txtFieldMobileNumber1.text = KAppDelegate.profileDetaiVendor.contactNumber
        txtFieldMobileNumber2.text = KAppDelegate.profileDetaiVendor.contactNumber2
        txtFieldShopNumber.text = KAppDelegate.profileDetaiVendor.whatsUpNo
        txtFieldAddress.text = autoCompleteModel.addressVal
        txtFieldCivilIdNumber.text = KAppDelegate.profileDetaiVendor.civilId
        self.imgVwUserProfile.sd_setImage(with: URL(string:  KAppDelegate.profileDetaiVendor.logoImage), completed: nil)
    }
    func userInteactionDisable () {
        txtFieldFirstName.isUserInteractionEnabled = false
        txtfieldLastName.isUserInteractionEnabled = false
        txtFieldEmail.isUserInteractionEnabled = false
        txtFieldMobileNumber1.isUserInteractionEnabled = false
        txtFieldMobileNumber2.isUserInteractionEnabled = false
        txtFieldShopNumber.isUserInteractionEnabled = false
        txtFieldAddress.isUserInteractionEnabled = false
        txtFieldCivilIdNumber.isUserInteractionEnabled = false
        btnCamera.isUserInteractionEnabled = false
    }
    
    func UserInteactionEnble () {
        txtFieldFirstName.isUserInteractionEnabled = true
        txtfieldLastName.isUserInteractionEnabled = true
        txtFieldEmail.isUserInteractionEnabled = true
        txtFieldMobileNumber1.isUserInteractionEnabled = true
        txtFieldMobileNumber2.isUserInteractionEnabled = true
        txtFieldShopNumber.isUserInteractionEnabled = true
        txtFieldAddress.isUserInteractionEnabled = true
        txtFieldCivilIdNumber.isUserInteractionEnabled = true
        btnCamera.isUserInteractionEnabled = true
    }
    
    //MARK:- UITextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFieldFirstName {
            txtfieldLastName.becomeFirstResponder()
        } else if  textField == txtfieldLastName{
            txtFieldEmail.becomeFirstResponder ()
        }
        else if  textField == txtFieldEmail{
            txtFieldMobileNumber1.becomeFirstResponder ()
        }
        else if  textField == txtFieldMobileNumber1{
            txtFieldMobileNumber2.becomeFirstResponder ()
        }else if  textField == txtFieldMobileNumber2{
            txtFieldCivilIdNumber.becomeFirstResponder ()
        }else if  textField == txtFieldCivilIdNumber{
            txtFieldShopNumber.becomeFirstResponder ()
        }
        else if  textField == txtFieldShopNumber{
            txtFieldAddress.becomeFirstResponder ()
        }
        else {
            txtFieldAddress.resignFirstResponder()
        }
        return true
    }
// MARK:- Textfield should Begin Editing
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtFieldAddress {
            objAutoComplete.searchPlaces(self)
            return false
        }else{
            return true
        }
    }
}

