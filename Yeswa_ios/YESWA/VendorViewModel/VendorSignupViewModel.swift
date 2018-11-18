//
//  VendorSignupViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 23/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import  UIKit

class VendorSignupViewModel: NSObject {
    
    var contactNumber1 = String()
    var contactNumber2 = String()
    var city = String ()
    var area = String ()
    var block = String()
    var street = String()
    var house = String ()
    var apartment = String()
    var office = String()
    var shopLogo = UIImage ()
    var currentLat = String ()
    var currentLong = String ()
    var islocationTrack = Int ()
    
    //MARK:- Signup Api Method
    func signupApi(_ completion:@escaping() -> Void) {
        var deviceTokken =  ""
        
        if UserDefaults.standard.object(forKey: "device_token") == nil {
            deviceTokken = "000000000000000000000000000000000000000000000000000000000000055"
        } else {
            deviceTokken = UserDefaults.standard.object(forKey: "device_token")! as! String
        }
        
        if UserDefaults.standard.object(forKey: "lat") != nil &&  UserDefaults.standard.object(forKey: "long") != nil {
         currentLat = UserDefaults.standard.value(forKey: "lat") as! String
         currentLong = UserDefaults.standard.value(forKey: "long") as! String
        
        }
        
        let param = [
        "VendorProfile[first_name]:":"\(saveSignUpVal.firstName)" ,
        "VendorProfile[last_name]" : "\(saveSignUpVal.lastName)" ,
        "User[password]": "\(saveSignUpVal.password)" ,
        "User[email]": "\(saveSignUpVal.email)" ,
        "VendorProfile[whats_app_no]:":"\(saveSignUpVal.WhatsAppNumber)" ,
        "VendorProfile[civil_id]" : "\(saveSignUpVal.civilId)" ,
        "VendorProfile[shopname]": "\(saveSignUpVal.shopname)" ,
        "VendorAddress[location]" : "\(saveSignUpVal.location)" ,
        "VendorLocation[latitude]" : "\(autoCompleteModel.latitude)" ,
        "VendorLocation[longitude]" : "\(autoCompleteModel.longitude)",
        "User[contact_no]:":"\(contactNumber1)" ,
        "User[contact_no_1]:":"\(contactNumber2)" ,
        "VendorAddress[city]" : "\(city)" ,
        "VendorAddress[area]": "\(area)" ,
        "VendorAddress[block]": "\(block)" ,
        "VendorAddress[street]" : "\(street)" ,
        "VendorAddress[house]": "\(house)" ,
        "VendorAddress[apartment]": "\(apartment)" ,
        "VendorAddress[office]": "\(office)" ,
        "User[role_id]" : "\(Role.RollVendor)" ,
        "User[location_tracking]" : "\(islocationTrack)",
        ] as [String:AnyObject]
        let paramImage = [
            "VendorProfile[shop_logo]": shopLogo
        ]
       
        let updateUrl = "\(Apis.KServerUrl)\(Apis.KSignUpVendor)"
        WebServiceProxy.shared.uploadImage(param, parametersImage: paramImage, addImageUrl: updateUrl, showIndicator: true) { (jsonResponse) in
            print("jsonResponse",jsonResponse)
            if jsonResponse["status"] as! Int == 200 {
                if let detailDict = jsonResponse["detail"] as? NSDictionary
                {
                    KAppDelegate.profileDetaiVendor.userDict(dict: detailDict)
                }
                if let auth = jsonResponse["auth_code"] as? String {
                    UserDefaults.standard.set(auth, forKey: "auth_code")
                    UserDefaults.standard.synchronize()
                }
                completion()
                
            } else {
                if let error = jsonResponse["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
            
            
        }
        
 }
    
   
}

