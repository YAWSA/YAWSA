//
//  GeoLocationViewModel.swift
//  YESWA
//
//  Created by Ankita Thakur on 30/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import GooglePlaces

class GeoLocationViewModel: NSObject,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    
    var locationManager = CLLocationManager()
    let currentLoctionmarker = GMSMarker()
    var currentLat = String ()
    var currentLong = String ()
    var vendorListArr = [GeoLocationModel]()
    var pageNumber = 0
    var totalPageCount = Int()
    
    func nearByVendorList (_ completion:@escaping() -> Void) {
        
        let param = [
            "User[latitude]:":"\(currentLat)" ,
            "User[longitude]" : "\(currentLong)" ,
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KNearbyVendor)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                let listArray = JSON["detail"] as! NSArray
                for i in 0 ..< listArray.count{
                    let dictVendorList = listArray.object(at: i) as! NSDictionary
                    let objgeoLocationModel = GeoLocationModel()
                    objgeoLocationModel.VendorListDict(dict: dictVendorList)
                    self.vendorListArr.append(objgeoLocationModel)
                }
                  completion()
            } else {
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
        })
    }
    //MARK:- Search Vendor
    func searchVendor(searchString: String , _ completion:@escaping() -> Void)   {
        pageNumber = 0
        let param = [
            "Category[title]" : searchString  //param
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KSearchVendor)?page=\(pageNumber)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                let listPageArr = JSON["details"] as! NSArray
                if listPageArr.count>0
                {
                    if  self.pageNumber > self.totalPageCount
                    {
                    }else{
                        let listArray = JSON["detail"] as! NSArray
                        for i in 0 ..< listArray.count{
                            let dictVendorList = listArray.object(at: i) as! NSDictionary
                            let objgeoLocationModel = GeoLocationModel()
                            objgeoLocationModel.VendorListDict(dict: dictVendorList)
          self.vendorListArr.append(objgeoLocationModel)
                        }
                    }
                }
                
            } else {
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
            completion()
        })
    }
}



//MARK:- Extension Class

extension GeoLocationVC : UITextFieldDelegate{
    
  
    func setCurrentLocation() {
        if UserDefaults.standard.object(forKey: "lat") != nil &&  UserDefaults.standard.object(forKey: "long") != nil {
            
             objGeoLocationViewModel.currentLat = UserDefaults.standard.value(forKey: "lat") as! String
           objGeoLocationViewModel.currentLong = UserDefaults.standard.value(forKey: "long") as! String
            
            let sourceLocation = CLLocationCoordinate2D(latitude: Double(objGeoLocationViewModel.currentLat)! as CLLocationDegrees, longitude: Double(objGeoLocationViewModel.currentLong)! as CLLocationDegrees)
            objGeoLocationViewModel.currentLoctionmarker.position = sourceLocation
            objGeoLocationViewModel.currentLoctionmarker.icon = #imageLiteral(resourceName: "ic_customer")
            let camera = GMSCameraPosition.camera(withLatitude: Double(objGeoLocationViewModel.currentLat)!, longitude: Double(objGeoLocationViewModel.currentLong)!, zoom: 15.0)
            VwMap.isMyLocationEnabled = true
            VwMap.camera = camera
            
               objGeoLocationViewModel.nearByVendorList {
                self.setStoreLocation(self.objGeoLocationViewModel.vendorListArr)
            }
        }
    }
    
    
    func setStoreLocation(_ vendorArr : [GeoLocationModel]) {
        for i in 0..<vendorArr.count {
            let storeLat = vendorArr[i].vendorLat
            let storeLong = vendorArr[i].vendorLong
            let sourceLocation = CLLocationCoordinate2D(latitude: Double(storeLat)! as CLLocationDegrees, longitude: Double(storeLong)! as CLLocationDegrees)
            let nearByVendor = GMSMarker()
            nearByVendor.position = sourceLocation
            nearByVendor.icon = #imageLiteral(resourceName: "ic_user")
            nearByVendor.map = VwMap
            nearByVendor.userData = i
            nearByVendor.title =  vendorArr[i].vendorName
            nearByVendor.appearAnimation = .pop
            VwMap.setRegion(sourceLocation: sourceLocation)
            self.VwMap.delegate = self
        }
    }

    // MARK:- Delegate Method GMS Mapiview
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("Did Tap Marker")
        let dictVendor =  objGeoLocationViewModel.vendorListArr[marker.userData as!Int]
    let vendorProductListVCObj = self.storyboard?.instantiateViewController(withIdentifier: "AllVendorProductListVC") as! AllVendorProductListVC
        
    vendorProductListVCObj.objAllVendorProductListVM.vendoridVal =  dictVendor.vendorId
  self.navigationController?.pushViewController(vendorProductListVCObj, animated: true)
        return true
    }
}
