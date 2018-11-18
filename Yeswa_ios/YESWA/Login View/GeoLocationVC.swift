//
//  GeoLocationVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 17/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class GeoLocationVC: UIViewController,GMSMapViewDelegate {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var VwMap: GMSMapView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var txtFieldSearch: UITextField!
    @IBOutlet weak var btnDrawer: UIButton!
    
    var objGeoLocationViewModel = GeoLocationViewModel ()
    override func viewDidLoad() {
        super.viewDidLoad()
         lblHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.geoLocation)
         txtFieldSearch.placeholder = Proxy.shared.languageSelectedStringForKey(ConstantValue.searchbyName)
        btnDrawer.isHidden = true
        Proxy.shared.addTabBottom(bottomView, tabNumber: TabTitle.TAB_GeoLocaton, currentViewController: self, currentStoryboard: StoryboardChnage.mainStoryboard)
        VwMap.delegate = self
      
        setCurrentLocation ()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        objGeoLocationViewModel.locationManager.delegate = self as? CLLocationManagerDelegate
    objGeoLocationViewModel.locationManager.requestWhenInUseAuthorization()
    objGeoLocationViewModel.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    objGeoLocationViewModel.locationManager.startUpdatingLocation()
    self.VwMap.settings.compassButton = true
    self.VwMap.isMyLocationEnabled = true
    }
    
   

    @IBAction func drawerAction(_ sender: Any) {
        self.revealViewController().revealToggle(animated: true)

    }
    
    @IBAction func actionCross(_ sender: UIButton) {
        txtFieldSearch.text = ""
        txtFieldSearch.resignFirstResponder()
        
    }
    
  
    @IBAction func actionAddCart(_ sender: UIButton) {
          Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.mainStoryboard, identifier: "CartVC", isAnimate: true, currentViewController: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
