//
//  AppDelegate.swift
//  YESWA
//
//  Created by Sonu Sharma on 13/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit
import GoogleMaps
import  GooglePlaces
import UserNotifications
import SWRevealViewController
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,SWRevealViewControllerDelegate,UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var swRevealViewController: SWRevealViewController!
    var bottomTabOption = String()
    var listVariantArr = NSMutableArray()
    var idColor = Int ()
    var idSize = Int ()
    var profileDetaiVendor = UserModelVendor()
    var profileDetailCustomer =  UserModel ()

    var colorFilterArr = [AddVarientColorModel] ()
    var sizeFilterArr = [AddVarientSizeModel]()
    var brandListFilterArr = [BrandListModel] ()
    var sliderMinVal = String()
    var sliderMaxVal = String()
    var didStartFromNotification = Bool()
     var currentViewCont = UIViewController()
    let storyBoard = UIStoryboard(name: "Vendor", bundle: nil)
    var orderStatus = String ()
    var orderID = Int ()
    let splashView = UIImageView()
     var isComeFrom = ""


    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        self.registerForPushNotifications(application: application)
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        UITextField.appearance().tintColor = .black
        GMSServices.provideAPIKey("AIzaSyCiHqK_6R84F6ynwZKaVGAv32PQraNj-I0")
        GMSPlacesClient.provideAPIKey("AIzaSyCiHqK_6R84F6ynwZKaVGAv32PQraNj-I0")
        locationManagerClass.sharedLocationManager().startStandardUpdates()
          
        if let emailStrVal = UserDefaults.standard.object(forKey: "LanguageSelect")
        {
            if  emailStrVal as! String == "0"
            {
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            }
            else if emailStrVal as! String == "1"{
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
            else{
                 UIView.appearance().semanticContentAttribute = .forceLeftToRight
            }
        }
        
        didStartFromNotification = false
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let dummyController:UIViewController = UIViewController()
        self.window!.rootViewController = dummyController
        self.window!.makeKeyAndVisible()
        splashView.frame = CGRect(x: 0,y: 0,width: (self.window?.frame.width)!,height: (self.window?.frame.height)!)
        splashView.image = UIImage(named: "splash")
        dummyController.view.addSubview(splashView)
        sleep(UInt32(1.0))
        
        
        let authCode: String = Proxy.shared.authNil()
        if((authCode == "" )) {
       RootControllerProxy.shared.rootWithoutDrawer(StoryboardChnage.mainStoryboard, identifier: "SelectRoleVC")
        } else
        {
            if let options = launchOptions {
                
                if let notification = options[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary {
                    didStartFromNotification = true
            
                   checkApiWithNotification(userInfo: notification)
                } else {
                    didStartFromNotification = false
                   checkAuthcode()
                }
            }
            else {
                didStartFromNotification = false
                checkAuthcode()
            }
        }
        // initialize for used
        return true
    }
    
    @objc func postNotificationIfLaunchedFromAppIcon(_ notification: NSDictionary) {
        handleNotifications(userInfo: notification)
    }
    //MARK: Check Authcode
    func checkAuthcode()
    {
        let auth = Proxy.shared.authNil()
        if auth == "" {
            RootControllerProxy.shared.rootWithoutDrawer(StoryboardChnage.mainStoryboard, identifier: "SelectRoleVC")
        } else {
            checkApiMethodWithoutNotification()
        }
    }
    
    //MARK:- Check Api Without Notification
    func checkApiMethodWithoutNotification() {
        
        let auth = UserDefaults.standard.value(forKey: "auth_code") as! String
        WebServiceProxy.shared.getData("\(Apis.KCheckUser)\(auth)", showIndicator: false) { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let detailDict = JSON["detail"] as? NSDictionary
                {
                    KAppDelegate.profileDetailCustomer.userDict(dict: detailDict)
                    if  KAppDelegate.profileDetailCustomer.roleIDUser == (Role.RollCustomer)
                    {
                        RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "HomeVC")
                    }else{
                        KAppDelegate.profileDetaiVendor.userDict(dict: detailDict)
                        Proxy.shared.displayStatusCodeAlert("checkApiMethodWithoutNotification")
                        RootControllerProxy.shared.rootWithoutDrawer(StoryboardChnage.vendorStoryboard, identifier: "CategoryVC")
                    }
                }
            } else {
                RootControllerProxy.shared.rootWithoutDrawer(StoryboardChnage.mainStoryboard, identifier: "SelectRoleVC")
            }
        }
    }
    
    //MARK:- Check Api With Notification
   
    func checkApiWithNotification(userInfo: NSDictionary) {
        let auth = UserDefaults.standard.value(forKey: "auth_code") as! String
        WebServiceProxy.shared.getData("\(Apis.KCheckUser)\(auth)", showIndicator: false) { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let detail = JSON["detail"] as? NSDictionary {
                    KAppDelegate.profileDetaiVendor.userDict(dict: detail)
                    RootControllerProxy.shared.rootWithoutDrawer(StoryboardChnage.vendorStoryboard, identifier: "CategoryVC")
                    
                    Proxy.shared.displayStatusCodeAlert("checkApiWithNotification")
                    self.handleNotifications(userInfo: userInfo)
                } else {
                    RootControllerProxy.shared.rootWithoutDrawer(StoryboardChnage.mainStoryboard, identifier: "SelectRoleVC")
                }
            } else {
                RootControllerProxy.shared.rootWithoutDrawer(StoryboardChnage.mainStoryboard, identifier: "SelectRoleVC")
            }
        }
    }
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("Device Token: \(tokenString)")
        UserDefaults.standard.set(tokenString, forKey: "device_token")
        UserDefaults.standard.synchronize()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        UserDefaults.standard.set("00000000000055", forKey: "device_token")
        UserDefaults.standard.synchronize()
    }
    
    func registerForPushNotifications(application: UIApplication) {
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted) {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            })
        } else {
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if !didStartFromNotification {
            handleNotifications(userInfo: userInfo as NSDictionary)
        } else {
            didStartFromNotification = false
        }
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (_ options: UNNotificationPresentationOptions) -> Void) {
        var userInfo = NSDictionary()
        userInfo = notification.request.content.userInfo as NSDictionary
            handleNotifications(userInfo: userInfo)
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        var userInfo = NSDictionary()
       
        userInfo = response.notification.request.content.userInfo as NSDictionary

        if !didStartFromNotification {
            handleNotifications(userInfo: userInfo)
        } else {
            didStartFromNotification = false
        }
    }
    
    //MARK:- Handle Notification Method 
    func handleNotifications(userInfo: NSDictionary) {
        print(userInfo)
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        self.currentViewCont = UIWindow.getVisibleViewControllerFrom(vc: rootVC!)
        orderStatus = (userInfo["message"] as? String)!
        
        if let orderIDVal = userInfo["task_id"] as? Int {
            orderID = orderIDVal
        }
        else if let orderIDVal = userInfo["task_id"] as? String {
            orderID = Int(orderIDVal)!
        }
        if ((userInfo["controller"]! as AnyObject).isEqual("product") && (userInfo["action"]! as AnyObject).isEqual("add-to-order") ) {
            
            if (currentViewCont.isKind(of: YourOrderVC.self)){
                
                let alertController = UIAlertController(title: "Alert", message: "\(orderStatus)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    alert -> Void in
                    NotificationCenter.default.post(name: NSNotification.Name("RefershOrderList"), object: nil)
                }))
               
                currentViewCont.present(alertController, animated: true, completion: nil)
            }else{
                let alertController = UIAlertController(title: "Message", message: "\(orderStatus)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                    alert -> Void in
                    
                    let orderDetailVCObj = self.storyBoard.instantiateViewController(withIdentifier: "OrderDetailsVenderVC") as? OrderDetailsVenderVC
                    
                    orderDetailVCObj?.orderDetailsModelViewObj.orderID = KAppDelegate.orderID
                    self.currentViewCont.navigationController?.pushViewController(orderDetailVCObj!, animated: true)
                }))
                currentViewCont.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
         UIApplication.shared.applicationIconBadgeNumber = 0
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
}

