//
//  SplashVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 13/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
       // UIApplication.shared.statusBarStyle = .lightContent
        //sleep(2)
        checkAuthcode()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    

}
