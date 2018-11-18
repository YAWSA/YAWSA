//
//  VendorTabBarVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 20/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class VendorTabBarVC: UIViewController {
    
    @IBOutlet weak var imgviewHome: UIImageView!
    @IBOutlet weak var lblHome: UILabel!
    
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var lblProfile: UILabel!
    
    @IBOutlet weak var imgViewLogout: UIImageView!
    @IBOutlet weak var lblLougout: UILabel!
    
    @IBOutlet weak var lblOrders: UILabel!
    @IBOutlet weak var imgOrders: UIImageView!
    
    @IBOutlet weak var imgVwPayment: UIImageView!
    @IBOutlet weak var lblPayment: UILabel!
    
    var tab = String()

    override func viewDidLoad() {
        super.viewDidLoad()
         setTabOption()
        setKeyVal()
    }
    func setKeyVal()  {
        
        lblHome.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.home)
        lblPayment.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.Payment)
        lblOrders.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.order)
        lblProfile.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.profile)
        lblLougout.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.logOut)
        
    }
    //MARK:- Set Tab Option
    func setTabOption()  {
        
        switch tab {
        case TabTitleVendor.TAB_Home:
            imgviewHome.image = #imageLiteral(resourceName: "ic_home")
            imgOrders.image = #imageLiteral(resourceName: "ic_grey_orders")
            imgVwPayment.image = #imageLiteral(resourceName: "ic_gray_payment")
            imgViewProfile.image = #imageLiteral(resourceName: "ic_grey_profile")
            imgViewLogout.image = #imageLiteral(resourceName: "ic_grey_logout")
            
            lblHome.textColor = AppInfo.AppColor
            lblProfile.textColor = UIColor.lightGray
            lblLougout.textColor = UIColor.lightGray
            lblPayment.textColor = UIColor.lightGray
            lblOrders.textColor = UIColor.lightGray
            
        case TabTitleVendor.TAB_Orders:
            imgviewHome.image = #imageLiteral(resourceName: "ic_grey_home")
            imgOrders.image = #imageLiteral(resourceName: "ic_orders")
            imgVwPayment.image = #imageLiteral(resourceName: "ic_gray_payment")
            imgViewProfile.image = #imageLiteral(resourceName: "ic_grey_profile")
            imgViewLogout.image = #imageLiteral(resourceName: "ic_grey_logout")
            
            lblOrders.textColor = AppInfo.AppColor
            lblHome.textColor = UIColor.lightGray
            lblProfile.textColor = UIColor.lightGray
            lblLougout.textColor = UIColor.lightGray
            lblPayment.textColor = UIColor.lightGray
            
            
        case TabTitleVendor.TAB_Payment :
            imgviewHome.image = #imageLiteral(resourceName: "ic_grey_home")
            imgOrders.image = #imageLiteral(resourceName: "ic_grey_orders")
            imgVwPayment.image = #imageLiteral(resourceName: "ic_payment")
            imgViewProfile.image = #imageLiteral(resourceName: "ic_grey_profile")
            imgViewLogout.image = #imageLiteral(resourceName: "ic_grey_logout")
            
            lblHome.textColor = UIColor.lightGray
            lblProfile.textColor = UIColor.lightGray
            lblLougout.textColor = UIColor.lightGray
            lblOrders.textColor = UIColor.lightGray
            lblPayment.textColor = AppInfo.AppColor
            
        case TabTitleVendor.TAB_Profile :
            imgviewHome.image = #imageLiteral(resourceName: "ic_grey_home")
            imgOrders.image = #imageLiteral(resourceName: "ic_grey_orders")
            imgVwPayment.image = #imageLiteral(resourceName: "ic_gray_payment")
            imgViewProfile.image = #imageLiteral(resourceName: "ic_profile")
            imgViewLogout.image = #imageLiteral(resourceName: "ic_grey_logout")
            
            lblHome.textColor = UIColor.lightGray
            lblProfile.textColor = AppInfo.AppColor
            lblLougout.textColor = UIColor.lightGray
            lblOrders.textColor = UIColor.lightGray
            lblPayment.textColor = UIColor.lightGray
            
        default:
            break
        }
    }

//MARK:- Action Buttosn
    @IBAction func homeAction(_ sender: Any) {
        if tab != TabTitleVendor.TAB_Home {
             RootControllerProxy.shared.rootWithoutDrawer(StoryboardChnage.vendorStoryboard, identifier: "CategoryVC")
            
        }
    }
    @IBAction func profileAction(_ sender: Any) {
        if tab != TabTitleVendor.TAB_Profile {
             RootControllerProxy.shared.rootWithoutDrawer(StoryboardChnage.vendorStoryboard, identifier: "VendorProfileVC")
        }
    }
    @IBAction func logoutAction(_ sender: Any) {
        if tab != TabTitleVendor.TAB_Logout {
           logout()
        }
        
    }
    @IBAction func actionOrders(_ sender: UIButton) {
        if tab != TabTitleVendor.TAB_Orders {
             RootControllerProxy.shared.rootWithoutDrawer(StoryboardChnage.vendorStoryboard, identifier: "YourOrderVC")
          
        }
    }
    
    @IBAction func actionPaymeny(_ sender: UIButton) {
        if tab != TabTitleVendor.TAB_Payment {
            RootControllerProxy.shared.rootWithoutDrawer(StoryboardChnage.vendorStoryboard, identifier: "PaymentsVC")
        }
    }
    
    //MARK:- logout Method
    func logout(){
        autoCompleteModel = AutoCompleteModel()
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
