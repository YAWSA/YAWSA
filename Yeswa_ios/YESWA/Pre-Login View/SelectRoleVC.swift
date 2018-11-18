//
//  SelectRoleVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 16/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class SelectRoleVC: UIViewController {
    //MARK:- Outlet
    @IBOutlet weak var lblCustomer: UILabel!
    @IBOutlet weak var lblVendor: UILabel!
    @IBOutlet weak var btnVendor: UIButton!
    @IBOutlet weak var btnCustomer: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
      lblCustomer.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.customer)
         lblVendor.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.vendor)
    }
    //MARK:- Action Buttons
    @IBAction func actionBtnCustomer(_ sender: UIButton) {
    RootControllerProxy.shared.rootWithoutDrawer(StoryboardChnage.mainStoryboard, identifier: "HomeVC")
    }
    
    @IBAction func actionBtnVendor(_ sender: UIButton) {
          Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.vendorStoryboard, identifier: "SignUpVC", isAnimate: true, currentViewController:self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
