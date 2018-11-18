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
        self.navigationController?.navigationBar.isHidden = true
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        UIApplication.shared.statusBarStyle = .lightContent
        Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.mainStoryboard, identifier: "SelectRoleVC", isAnimate: true, currentViewController: self)
        
        //RootControllerProxy.shared.rootWithoutDrawer(StoryboardChnage.mainStoryboard, identifier: "SelectRoleVC")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
