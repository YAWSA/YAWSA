//
//  UserModelVendor.swift
//  YESWA
//
//  Created by Sonu Sharma on 27/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation

class UserModelVendor: NSObject {
    
var idUser,roleIDUser,typeId,isCustomer, isVendor,isOnOff :Int!
var firstName,lastName, fullName,contactNumber,contactNumber2,address,emailId,latitute,langitute,zipCode,profileImage,logoImage,civilId,shopLocation,whatsUpNo,city :String!
    
    
    func userDict(dict: NSDictionary)  {
        if let locTrack = dict["location_tracking"] as? Int{
          isOnOff = locTrack
        }else if let locTrack = dict["location_tracking"] as? String{
            isOnOff = Int (locTrack)
        }
        isCustomer = dict["is_customer"] as? Int ?? 0
        isVendor = dict["is_vendor"] as? Int ?? 0
        fullName = dict["full_name"] as? String ?? ""
        firstName = dict["first_name"] as? String ?? ""
        lastName = dict["last_name"] as? String ?? ""
        contactNumber = dict["contact_no"] as? String ?? ""
        contactNumber2 = dict["contact_no_1"] as? String ?? ""
        idUser = dict["id"] as? Int ?? 0
        roleIDUser = dict["role_id"] as? Int ?? 0
        address  = dict["address"] as? String ?? ""
        city  = dict["city"] as? String ?? ""
        emailId = dict["email"] as? String ?? ""
        latitute = dict["latitude"] as? String ?? ""
        langitute = dict["longitude"] as? String ?? ""
        zipCode = dict["zipcode"] as? String ?? ""
        profileImage = dict["profile_file"] as? String ?? ""
        
        if let profileDict = dict["vendorProfile"] as? NSDictionary {
            civilId = profileDict["civil_id"] as? String ?? ""
            whatsUpNo = profileDict["whats_app_no"] as? String ?? ""
            logoImage = profileDict["shop_logo"] as? String ?? ""
        }
    if let profileDict = dict["vendorLocation"] as? NSDictionary {
            shopLocation = profileDict["location"] as? String ?? ""
        }
    }
}
