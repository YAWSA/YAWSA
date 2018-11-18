//
//  AutoComplete.swift
//  AutoCompleteIntegration
//
//  Created by Jaspreet Bhatia on 20/03/18.
//  Copyright © 2018 Jaspreet Bhatia. All rights reserved.
//

import UIKit
import GooglePlaces

class AutoComplete: NSObject,GMSAutocompleteViewControllerDelegate {
    
    
    var currentControll = UIViewController()
    func searchPlaces(_ currentController : UIViewController){
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        filter.country = "KWT"
        acController.autocompleteFilter = filter
        currentControll = currentController
        currentController.present(acController, animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        autoCompleteModel.latitude = Float(place.coordinate.latitude)
        autoCompleteModel.longitude = Float(place.coordinate.longitude)
        let arrPlace = place.addressComponents! as NSArray
        autoCompleteModel.addressVal = " "
        for i in 0..<arrPlace.count {
            let dics : GMSAddressComponent = arrPlace[i] as! GMSAddressComponent
            let str : NSString = dics.type as NSString
            if str == "sublocality_level_1"{
                autoCompleteModel.addressVal += " \(dics.name)"
                
            }
            if str == "sublocality_level_2" {
                autoCompleteModel.addressVal += "\(dics.name)"
                
            }
            if str == "sublocality_level_3" {
                autoCompleteModel.addressVal += "\(dics.name)"
                
            }
            if str == "locality" {
                autoCompleteModel.addressVal += "\(dics.name)"
                
            }
            if str == "route" {
                autoCompleteModel.addressVal += "\(dics.name)"
                
            }
        }
        currentControll.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        currentControll.dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        currentControll.dismiss(animated: true, completion: nil)
    }
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

