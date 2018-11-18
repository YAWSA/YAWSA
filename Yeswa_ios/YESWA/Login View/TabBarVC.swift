//
//  TabBarVC.swift
//  LanguageLearning
//
//  Created by Nikita Kalra on 05/05/17.
//  Copyright © 2017 Nikita Kalra. All rights reserved.
//

import UIKit

class TabBarVC: UIViewController {
    //MARK:- Outlets
    @IBOutlet weak var imgviewHome: UIImageView!
    @IBOutlet weak var lblHome: UILabel!
    
    @IBOutlet weak var imgViewProfile: UIImageView!
    @IBOutlet weak var lblProfile: UILabel!
    
    @IBOutlet weak var imgViewLogout: UIImageView!
    @IBOutlet weak var lblLougout: UILabel!
    
    @IBOutlet weak var lblGeoLocation: UILabel!
    @IBOutlet weak var imgGeoLocaiotn: UIImageView!
    
    @IBOutlet weak var imgVwCategory: UIImageView!
    @IBOutlet weak var lblCategory: UILabel!
    var tab = String()
    //MARK:- LifeCccle
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabOption()
        setKeyVal()
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Set Tab Option
    func setTabOption()  {
        lblHome.textColor = UIColor.lightGray
        lblProfile.textColor = UIColor.lightGray
        lblLougout.textColor = UIColor.lightGray
        lblCategory.textColor = UIColor.lightGray
        lblGeoLocation.textColor = UIColor.lightGray
        
        
        imgviewHome.image = #imageLiteral(resourceName: "ic_grey_home")
        imgGeoLocaiotn.image = #imageLiteral(resourceName: "ic_grey_geoloacation")
        imgVwCategory.image = #imageLiteral(resourceName: "ic_grey_category")
        imgViewProfile.image = #imageLiteral(resourceName: "ic_grey_profile")
        imgViewLogout.image = #imageLiteral(resourceName: "ic_brand")
        
        switch tab {
        case TabTitle.TAB_Home:
            imgviewHome.image = #imageLiteral(resourceName: "ic_home")
            lblHome.textColor = AppInfo.AppColor
        case TabTitle.TAB_GeoLocaton:
            imgGeoLocaiotn.image = #imageLiteral(resourceName: "ic_geoloacation")
             lblGeoLocation.textColor = AppInfo.AppColor
        case TabTitle.TAB_Category :
            imgVwCategory.image = #imageLiteral(resourceName: "ic_category")
           lblCategory.textColor = AppInfo.AppColor
        case TabTitle.TAB_Profile :
            imgViewProfile.image = #imageLiteral(resourceName: "ic_profile")
            lblProfile.textColor = AppInfo.AppColor
        case TabTitle.TAB_Brand :
            imgViewLogout.image = #imageLiteral(resourceName: "ic_selected_brand")
            lblLougout.textColor = AppInfo.AppColor
        default:
            break
        }
    }
    //MARK:- SetText
    func setKeyVal()  {
        lblHome.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.home)
        lblGeoLocation.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.geoLocation)
        lblCategory.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.categoty)
        lblProfile.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.profile)
        lblLougout.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.brands)
        
    }
    //MARK:-Actions
    @IBAction func homeAction(_ sender: Any) {
        if tab != TabTitle.TAB_Home {
            RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "HomeVC")
        }
    }
    @IBAction func profileAction(_ sender: Any) {
        if tab != TabTitle.TAB_Profile {
            let auth = Proxy.shared.authNil()
            if auth == "" {
                let alertController = UIAlertController(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.loginPlease), message: Proxy.shared.languageSelectedStringForKey(ConstantValue.sureToLogin), preferredStyle: .alert)
                
                
                let cancelAction = UIAlertAction(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.cancel), style: .default) { (action:UIAlertAction!) in
                    
                }
                alertController.addAction(cancelAction)
                
                let OKAction = UIAlertAction(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.ok), style: .cancel) { (action:UIAlertAction!) in
                 KAppDelegate.isComeFrom = "HomeVC"
                Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.mainStoryboard, identifier: "SignInVC", isAnimate: true, currentViewController: self)

                }
                alertController.addAction(OKAction)
                
                self.present(alertController, animated: true, completion:nil)
            }else{
              RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier:"ProfileVC")
            }
        }
    }
    @IBAction func logoutAction(_ sender: Any) {
        KAppDelegate.bottomTabOption = Proxy.shared.languageSelectedStringForKey(ConstantValue.brands)
        if tab != TabTitle.TAB_Brand {
            RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier:"ItemsListVC")
        }
    }
    @IBAction func actionGeoLocation(_ sender: UIButton) {
        if tab != TabTitle.TAB_GeoLocaton {
            RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "GeoLocationVC")
        }
    }
    
    @IBAction func actionCategory(_ sender: UIButton) {
         KAppDelegate.bottomTabOption = Proxy.shared.languageSelectedStringForKey(ConstantValue.categoty)
        if tab != TabTitle.TAB_Category {
            RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "ItemsListVC")
        }
    }
}
