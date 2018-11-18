 //
 //  RootControllerProxy.swift
 //  Foosto
 //
 //  Created by Sukhpreet Kaur on 3/10/18.
 //  Copyright © 2018 Sukhpreet Kaur. All rights reserved.
 //
 import Foundation
 import UIKit
 import SWRevealViewController
 
 class RootControllerProxy{
    static var shared: RootControllerProxy {
        return RootControllerProxy()
    }
    fileprivate init(){}
    
    func rootWithoutDrawer(_ storyboardVal:UIStoryboard,identifier: String){
       // Proxy.shared.displayStatusCodeAlert("rootWithoutDrawer")

        let blankController = storyboardVal.instantiateViewController(withIdentifier: identifier)
        var homeNavController:UINavigationController = UINavigationController()
        homeNavController = UINavigationController.init(rootViewController: blankController)
        homeNavController.isNavigationBarHidden = true
        KAppDelegate.window!.rootViewController = homeNavController
        KAppDelegate.window!.makeKeyAndVisible()
    }
    
        
    func rootWithDrawer(_ storyboardVal:UIStoryboard, identifier: String){
      //  Proxy.shared.displayStatusCodeAlert("rootWithDrawer")

        let frontViewController = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: identifier)
        let rearViewController = UIStoryboard(name: "Main",bundle: nil).instantiateViewController(withIdentifier: "LeftMenuVC") as! LeftMenuVC
        let mainNavController  = UINavigationController(rootViewController: frontViewController)
        let sideNavController = UINavigationController(rootViewController: rearViewController)
        let mainRevealController = SWRevealViewController(rearViewController: sideNavController, frontViewController: mainNavController)
        mainRevealController?.delegate = KAppDelegate
        KAppDelegate.swRevealViewController = mainRevealController
        
        
        
        let currentNavCont: UINavigationController = KAppDelegate.swRevealViewController.frontViewController as! UINavigationController
        KAppDelegate.window!.rootViewController = KAppDelegate.swRevealViewController
        KAppDelegate.window!.makeKeyAndVisible()
        mainNavController.isNavigationBarHidden = true
        sideNavController.isNavigationBarHidden = true
    }
    
 }
