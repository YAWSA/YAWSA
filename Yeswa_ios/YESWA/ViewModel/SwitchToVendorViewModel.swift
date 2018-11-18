//
//  SwitchToVendorViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 13/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import  UIKit

class SwitchToVendorViewModel: NSObject {
    
    var firstName = String()
    var lastName = String ()
    var whatupNumber = String ()
    var civilId = String()
    var shopName = String()
    var loctaion = String ()
    var contactNumber = String()
    var contactNubmer2 = String ()
    var city = String ()
    var area = String ()
    var block = String()
    var street = String()
    var house = String ()
    var apartment = String()
    var office = String()
    var shopLogo = UIImage ()
    var islocationTrack = Int ()
    
    //MARK:- Signup Api Method
    func switchUser(_ completion:@escaping() -> Void) {
        
        let param = [
            "VendorProfile[first_name]:":"\(firstName)" ,
            "VendorProfile[last_name]" : "\(lastName)" ,
            "VendorProfile[whats_app_no]:":"\(whatupNumber)" ,
            "VendorProfile[civil_id]" : "\(civilId)" ,
            "VendorProfile[shopname]": "\(shopName)" ,
            "VendorAddress[location]" : "\(loctaion)" ,
            "VendorLocation[latitude]" : "\(autoCompleteModel.latitude)" ,
            "VendorLocation[longitude]" : "\(autoCompleteModel.longitude)",
            "User[contact_no]:":"\(contactNumber)" ,
            "User[contact_no_1]]:":"\(contactNubmer2)" ,
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
        let updateUrl = "\(Apis.KServerUrl)\(Apis.KSwitchUser)"
        WebServiceProxy.shared.uploadImage(param, parametersImage: paramImage, addImageUrl: updateUrl, showIndicator: true) { (jsonResponse) in
            print("jsonResponse",jsonResponse)
            if jsonResponse["status"] as! Int == 200 {
                if let detailDict = jsonResponse["detail"] as? NSDictionary{
                    KAppDelegate.profileDetaiVendor.userDict(dict: detailDict)
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



