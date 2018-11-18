
//  GeoLocationModel.swift
//  YESWA

//  Created by Ankita Thakur on 30/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.


import Foundation
class GeoLocationModel: NSObject {
    
    var vendorLat = String ()
    var vendorLong = String ()
    var vendorName = String ()
    var vendorId = Int ()
    
    func VendorListDict(dict: NSDictionary)  {
        vendorName = dict["full_name"] as? String ?? ""
        
        if let productDic = dict["vendorLocation"] as? NSDictionary {
            vendorId = productDic["vendor_id"] as? Int ?? 0
            vendorLat = productDic["latitude"] as? String ?? ""
            vendorLong = productDic["longitude"] as? String ?? ""
        }
    }
}


