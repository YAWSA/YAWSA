//
//  LeftMenuVC.swift
//  Here App
//
//  Created by Tushar Verma on 29/07/17.
//  Copyright © 2017 Toxsl technologies. All rights reserved.
//

import UIKit
import SWRevealViewController

protocol handleDrawerNavigation {
    func dismissDrawer()
    func openDrawer()
}
var protocolDrawerNav : handleDrawerNavigation?
class LeftMenuVC: UIViewController , UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var VwUserDetails: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var imgViewUser: UIImageView!
    
    @IBOutlet weak var VwUserDetailHeightCnst: NSLayoutConstraint!
    @IBOutlet var tblView: UITableView!
    
    var arrTitle = ["Home" , "Profile", "Geo Location", "Categories" ,"Switch to Vendor","Change Language"]
    var arrImg = [#imageLiteral(resourceName: "ic_dr_home"),#imageLiteral(resourceName: "ic_dr_profile"),#imageLiteral(resourceName: "ic_geoloc"),#imageLiteral(resourceName: "ic_dr_categry"),#imageLiteral(resourceName: "ic_switch"),#imageLiteral(resourceName: "ic_language")]
    var withoutLoginArr = ["Home", "Geo Location", "Categories" ,"Change Language","Login"]
    var withoutLoginArrImg = [#imageLiteral(resourceName: "ic_dr_home"),#imageLiteral(resourceName: "ic_geoloc"),#imageLiteral(resourceName: "ic_dr_categry"),#imageLiteral(resourceName: "ic_language"),#imageLiteral(resourceName: "ic_logout")]
    var withoutLogin = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.separatorStyle = UITableViewCellSeparatorStyle.none
      
    }
    
    
    //MARK:- ViewWill Appear Method
    override func viewWillAppear(_ animated: Bool) {
        
        let auth = Proxy.shared.authNil()
        if auth == "" {
            withoutLogin = true
            arrTitle = withoutLoginArr
            arrImg = withoutLoginArrImg
            VwUserDetailHeightCnst.constant = 0
        }else{
            VwUserDetailHeightCnst.constant = 160
            withoutLogin = false
            self.lblName.text = KAppDelegate.profileDetailCustomer.fullName
            self.lblEmail.text = KAppDelegate.profileDetailCustomer.emailId
            
            if  KAppDelegate.profileDetailCustomer.profileImage != "" {
                DispatchQueue.main.async {
                    self.imgViewUser.sd_setImage(with: URL(string:  KAppDelegate.profileDetailCustomer.profileImage), completed: nil)
                }
            }
            else {
                imgViewUser.image = #imageLiteral(resourceName: "ic_user-1")
            }
        }
        tblView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        protocolDrawerNav?.openDrawer()
    }
    override func viewWillDisappear(_ animated: Bool) {
        protocolDrawerNav?.dismissDrawer()
    }

//MARK:- Action Profile
    @IBAction func profileAction(_ sender: Any) {

    }
    
//MARK :- UITableView Datasource Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrTitle.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuTVC") as! LeftMenuTVC
        cell.selectionStyle = .none
        cell.lblItem.text = arrTitle[indexPath.row]
        cell.imgItem.image = arrImg[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if withoutLogin{
            
            
            switch  indexPath.row {
            case 0:
                RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "HomeVC")
                
            case 1:
                RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "GeoLocationVC")
                
            case 2:
       RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "ItemsListVC")
            case 3:
            // Proxy.shared.customActionSheetLanguage()
                break
            case 4 :
            RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "SignInVC")
           
            default:
                break
            }
            
            
            
        }else{
      
        switch  indexPath.row {
        case 0:
            self.revealViewController().revealToggle(animated: true)
             RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "HomeVC")
            break
        case 1:
            self.revealViewController().revealToggle(animated: true)
            RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "ProfileVC")
            
        case 2:
          RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "GeoLocationVC")
        case 3:
            
            self.revealViewController().revealToggle(animated: true)
             RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "ItemsListVC")
            
        case 4 :
            if KAppDelegate.profileDetailCustomer.isVendor == 1 {
               switchToVendor ()
            }else {
              RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "SwitchToVendorVC")
            }
        case 5 :
            break
               //Proxy.shared.customActionSheetLanguage()
        default:
            break
          }
        }
    }
    
    // MARK:- Add Brand Api Interaction
    func switchToVendor() {
        let param = [
            "User[role_id]" : "\(Role.RollVendor)" ,
            ] as [String:AnyObject]
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KSwitchUser)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let detailDict = JSON["detail"] as? NSDictionary {
                    KAppDelegate.profileDetaiVendor.userDict(dict: detailDict)
                }
            RootControllerProxy.shared.rootWithoutDrawer(StoryboardChnage.vendorStoryboard, identifier: "CategoryVC")
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.loginsuccesfully))
                
            } else {
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
