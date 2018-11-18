 //
 //  WebServiceProxy.swift
 //  Foosto
 //
 //  Created by Sukhpreet Kaur on 3/10/18.
 //  Copyright © 2018 Sukhpreet Kaur. All rights reserved.
 //
 import Foundation
 import Alamofire
 import UIKit
 import Photos
 import SwiftSpinner
 
 let KAppDelegate = UIApplication.shared.delegate as! AppDelegate
 let storyboardObj = UIApplication.shared.keyWindow?.rootViewController?.storyboard
 
 enum TrackOrderColor {
    static let Panding = 0
    static let Completed = 1
    static let Cancelled = 2
 }
 enum buttonBackgroundColor {
    
    static let ShowSelectedBtn = UIColor (red: 24.0/255.0, green: 24.0/255.0, blue: 24.0/255.0, alpha: 1.0)
    static let ShowUnselectedBtn = UIColor (red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
 }
 
 
 class Proxy {
    static var shared: Proxy {
        return Proxy()
    }
    fileprivate init(){}
    
    //MARK:- Common Methods
    func authNil() -> String {
        if let authCode = UserDefaults.standard.object(forKey: "auth_code") as? String {
            return authCode
        } else {
            return ""
        }
    }
    func addTabBottom(_ bottomContainerView:UIView , tabNumber:String,currentViewController: UIViewController,currentStoryboard:UIStoryboard)
    {
        let tabbarVc = currentStoryboard.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
        tabbarVc.tab = tabNumber
        currentViewController.addChildViewController(tabbarVc)
        tabbarVc.view.frame = CGRect(x: 0, y: 0, width: bottomContainerView.frame.size.width, height: bottomContainerView.frame.size.height)
        bottomContainerView.addSubview(tabbarVc.view)
        tabbarVc.didMove(toParentViewController: currentViewController)
    }
    
    func addTabBottomForVendor(_ bottomContainerView:UIView , tabNumber:String,currentViewController: UIViewController,currentStoryboard:UIStoryboard)
    {
        let tabbarVc = currentStoryboard.instantiateViewController(withIdentifier: "VendorTabBarVC") as! VendorTabBarVC
        tabbarVc.tab = tabNumber
        currentViewController.addChildViewController(tabbarVc)
        tabbarVc.view.frame = CGRect(x: 0, y: 0, width: bottomContainerView.frame.size.width, height: bottomContainerView.frame.size.height)
        bottomContainerView.addSubview(tabbarVc.view)
        tabbarVc.didMove(toParentViewController: currentViewController)
    }
    
    //MARK:- Push Method
    func pushToNextVC(storyborad: UIStoryboard,identifier:String, isAnimate:Bool , currentViewController: UIViewController) {
        let pushControllerObj = storyborad.instantiateViewController(withIdentifier: identifier)
        currentViewController.navigationController?.pushViewController(pushControllerObj, animated: isAnimate)
    }
    
    //MARK:- logout Method
    func logout(){
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KLogout)", showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                UserDefaults.standard.set("", forKey: "auth_code")
                UserDefaults.standard.synchronize()
                RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "SelectRoleVC")
                
            } else {
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
            Proxy.shared.hideActivityIndicator()
        })
    }

    //MARK:- Pop Method
    func popToBackVC(isAnimate:Bool , currentViewController: UIViewController) {
        currentViewController.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- Display Toast
    func displayStatusCodeAlert(_ userMessage: String) {
        UIView.hr_setToastThemeColor(AppInfo.AppColor)
        KAppDelegate.window!.makeToast(message: userMessage)
        
    }
    //MARK:- Check Valid Email Method
    func isValidEmail(_ testStr:String) -> Bool  {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        return (testStr.range(of: emailRegEx, options:.regularExpression) != nil)
    }
    
    //MARK:- Check Valid Password Method
    func isValidPassword(_ testStr:String) -> Bool  {
        let emailRegEx = "^.*(?=.{8})(?=.*[a-zA-Z])(?=.*\\d)(?=.*[!@#$%&*_.()])[a-zA-Z0-9!@#$%&*_.]+$"
        return (testStr.range(of: emailRegEx, options:.regularExpression) != nil)
    }
    
    //MARK: - LANGAUGE METHOD
    func languageSelectedStringForKey(_ key: String) -> String
    {
        var path = String()
        if let emailStrVal = UserDefaults.standard.object(forKey: "LanguageSelect")
        {
            if  emailStrVal as! String == "0"
            {
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
          
                path = Bundle.main.path(forResource: "en", ofType: "lproj")!
             
            }
            else if emailStrVal as! String == "1"
                
            {
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
              
                path = Bundle.main.path(forResource:"ar", ofType: "lproj")!
              
            }
        }
        else
        {
            // KAppDelegate.preferredLanguage = "en"
              UIView.appearance().semanticContentAttribute = .forceLeftToRight
            path = Bundle.main.path(forResource:"en", ofType: "lproj")!
       
        }
        let languageBundle: Bundle = Bundle(path: path)!
        let str: String = languageBundle.localizedString(forKey: key, value: "", table: nil)

        return str
    }
    
    
    //MARK: - HANDLE ACTIVITY
    func showActivityIndicator() {
        DispatchQueue.main.async
            {
            SwiftSpinner.show("Please wait..", animated: true)
         }
    }
    
    func hideActivityIndicator()  {
        DispatchQueue.main.async {
            SwiftSpinner.hide()
        }
    }
    //MARK:- Latitude Method
    func getLatitude() -> String
    {
        if UserDefaults.standard.object(forKey: "lat") != nil {
            let currentLat =  UserDefaults.standard.object(forKey: "lat") as! String
            return currentLat
        }
        return "00.00"
    }
    //MARK:- Longitude Method
    func getLongitude() -> String
    {
        if UserDefaults.standard.object(forKey: "long") != nil {
            let currentLong =  UserDefaults.standard.object(forKey: "long") as! String
            return currentLong
        }
        return "00.00"
        
    }
    
    
    func openSettingApp() {
        let settingAlert = UIAlertController(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.connectionProblem), message: Proxy.shared.languageSelectedStringForKey(ConstantValue.checkConnection), preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.cancel), style: UIAlertActionStyle.default, handler: nil)
        settingAlert.addAction(okAction)
        let openSetting = UIAlertAction(title:Proxy.shared.languageSelectedStringForKey(ConstantValue.settings), style:UIAlertActionStyle.default, handler:{ (action: UIAlertAction!) in
            let url:URL = URL(string: UIApplicationOpenSettingsURLString)!
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (success) in })
            } else {
                guard UIApplication.shared.openURL(url) else {
                    Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.pleaseReviewyournetworksettings))
                    return
                }
            }
        })
        settingAlert.addAction(openSetting)
        UIApplication.shared.keyWindow?.rootViewController?.present(settingAlert, animated: true, completion: nil)
    }
    //MARK:- LOCATION SETTING
    func openLocationSettingApp() {
        let settingAlert = UIAlertController(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.locationProblem), message: Proxy.shared.languageSelectedStringForKey(ConstantValue.enableLocation), preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.cancel), style: UIAlertActionStyle.default, handler: nil)
        settingAlert.addAction(okAction)
        let openSetting = UIAlertAction(title:Proxy.shared.languageSelectedStringForKey(ConstantValue.settings), style:UIAlertActionStyle.default, handler:{ (action: UIAlertAction!) in
            let url:URL = URL(string: UIApplicationOpenSettingsURLString)!
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (success) in })
            } else {
                guard UIApplication.shared.openURL(url) else {
                    Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.pleaseReviewyournetworksettings))
                    return
                }
            }
        })
        settingAlert.addAction(openSetting)
        UIApplication.shared.keyWindow?.rootViewController?.present(settingAlert, animated: true, completion: nil)
    }
    func getAddressForLatLng(latitude: String, longitude: String) -> String {
        
        // change key before live its is foosto app
        
        let url = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=\("AIzaSyBPTA4S6LHWp_l_prbWBND1C3w1PLbB_Ik")")
        let data = NSData(contentsOf: url! as URL)
        if data != nil {
            let json = try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            if let result = json["results"] as? NSArray   {
                if result.count > 0 {
                    if let addresss:NSDictionary = result[0] as! NSDictionary {
                        if let address = addresss["address_components"] as? NSArray {
                            var newaddress = ""
                            var fullAddress = ""
                            fullAddress = addresss["formatted_address"] as! String
                            newaddress = "\(fullAddress)"
                            return newaddress
                        }
                        else {
                            return ""
                        }
                    }
                } else {
                    return ""
                }
            }
            else {
                return ""
            }
            
        }   else {
            return ""
        }
        
    }
    
 }
