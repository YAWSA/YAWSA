//
//  signUpModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 23/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation

var objuserModel = UserModel ()

class UserModel: NSObject {
    
var idUser,roleIDUser,typeId,isUser,isVendor :Int!
var firstName,lastName,fullName,contactNumber,address,contactNo,emailId,latitute,langitute,zipCode,profileImage,logoImage,city :String!
    
    
    func userDict(dict: NSDictionary)  {
        isUser = dict["is_customer"] as? Int ?? 0
        isVendor = dict["is_vendor"] as? Int ?? 0
        firstName = dict["first_name"] as? String ?? ""
        lastName = dict["last_name"] as? String ?? ""
        fullName = dict["full_name"] as? String ?? ""
        contactNumber = dict["contact_no"] as? String ?? ""
        idUser = dict["id"] as? Int ?? 0
        roleIDUser = dict["role_id"] as? Int ?? 0
        address  = dict["address"] as? String ?? ""
        city  = dict["city"] as? String ?? ""
        contactNo  = dict["contact_no"] as? String ?? ""
        emailId = dict["email"] as? String ?? ""
        latitute = dict["latitude"] as? String ?? ""
        langitute = dict["longitude"] as? String ?? ""
        zipCode = dict["zipcode"] as? String ?? ""
        profileImage = dict["profile_file"] as? String ?? ""
        if let profileDict = dict["profile"] as? NSDictionary
        {
            logoImage = profileDict["logo_file"] as? String ?? ""
        }
    }
    
}
