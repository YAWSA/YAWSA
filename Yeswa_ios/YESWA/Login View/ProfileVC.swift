//
//  ProfileVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 16/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController,passImageDelegate {
    // MARK:- Outlet
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var imgVwUserProfile: SetCornerImageView!
    @IBOutlet weak var tblVwUserDetails: UITableView!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var lblUserName: UILabel!
     @IBOutlet weak var lblHi: UILabel!
    @IBOutlet weak var btnDrawer: UIButton!
    @IBOutlet weak var imgVwUserProfileLarge: UIImageView!
    var clickEditBtn = Int ()
    
    //MARK: - variable

    var galleryFunctions =  GalleryCameraImage()

    var userPersonalDetailArr =     [(Proxy.shared.languageSelectedStringForKey(ConstantValue.myOrder),#imageLiteral(resourceName: "ic_orders") ),
                          (Proxy.shared.languageSelectedStringForKey(ConstantValue.myProfile),#imageLiteral(resourceName: "ic_details")),
                          (Proxy.shared.languageSelectedStringForKey(ConstantValue.wishList),#imageLiteral(resourceName: "ic_cart") ),
                          (Proxy.shared.languageSelectedStringForKey(ConstantValue.changePass),#imageLiteral(resourceName: "ic_password")),
                          (Proxy.shared.languageSelectedStringForKey(ConstantValue.switchTovendor),#imageLiteral(resourceName: "ic_switch")),
                          (Proxy.shared.languageSelectedStringForKey(ConstantValue.changeLanguage), #imageLiteral(resourceName: "ic_language")),
                          (Proxy.shared.languageSelectedStringForKey(ConstantValue.help), #imageLiteral(resourceName: "ic_help")),
                          (Proxy.shared.languageSelectedStringForKey(ConstantValue.tellTinkYeswa),#imageLiteral(resourceName: "ic_logout")),
                          (Proxy.shared.languageSelectedStringForKey(ConstantValue.signOut),#imageLiteral(resourceName: "ic_logout"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        btnDrawer.isHidden = true
        clickEditBtn = 0
        //check for image
    if  KAppDelegate.profileDetailCustomer.profileImage != "" {
            DispatchQueue.main.async {
                self.imgVwUserProfile.sd_setImage(with: URL(string:  KAppDelegate.profileDetailCustomer.profileImage), placeholderImage: #imageLiteral(resourceName: "ic_user-1"), completed: nil)
                self.imgVwUserProfileLarge.sd_setImage(with: URL(string:  KAppDelegate.profileDetailCustomer.profileImage), placeholderImage: #imageLiteral(resourceName: "ic_user-1"), completed: nil)
            }
        }
        else {
            imgVwUserProfile.image = #imageLiteral(resourceName: "ic_user-1")
        }
        Proxy.shared.addTabBottom(vwBottom, tabNumber: TabTitle.TAB_Profile, currentViewController: self, currentStoryboard: StoryboardChnage.mainStoryboard)
        self.tblVwUserDetails.reloadData()
         galleryCameraImageObj = self
        btnCamera.isUserInteractionEnabled = false
    btnEdit.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.edit), for: .normal)
       lblHi.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.hi)
        lblHeader.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.myAccount)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.lblUserName.text = KAppDelegate.profileDetailCustomer.fullName
    }
    //MARK:- Action Camera/Gallery
    @IBAction func actionCamera(_ sender: UIButton) {
           galleryFunctions.customActionSheet()
    }
    
    func passSelectedimage(selectImage: UIImage) {
        imgVwUserProfile.image = selectImage
        imgVwUserProfileLarge.image = selectImage
    }
    
    @IBAction func ActionEdit(_ sender: UIButton) {
        if clickEditBtn == 0 {
            btnCamera.isUserInteractionEnabled = true
            btnEdit.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.save), for: .normal)
            self.clickEditBtn = 1
        }else {
            let paramImage = [
                "User[profile_file]": imgVwUserProfile.image
            ]
            let updateUrl = "\(Apis.KServerUrl)\(Apis.KProfileImageUpdate)"
            WebServiceProxy.shared.uploadImageWithImage(parametersImage: paramImage as! [String : UIImage], addImageUrl: updateUrl, showIndicator: true){ (jsonResponse) in
                print("jsonResponse",jsonResponse)
                if jsonResponse["status"] as! Int == 200 {
                    if let detailDict = jsonResponse["detail"] as? NSDictionary {
                        KAppDelegate.profileDetailCustomer.userDict(dict: detailDict)
                        Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.profileUpdate))
                        self.btnEdit.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.edit), for: .normal)
                        self.clickEditBtn = 0
                        self.btnCamera.isUserInteractionEnabled = false
                    }
                } else {
                    if let error = jsonResponse["error"] as? String {
                        Proxy.shared.displayStatusCodeAlert(error)
                    }
                }
            }
        }
    }
    
    @IBAction func actionDrawer(_ sender: UIButton) {
        self.revealViewController().revealToggle(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}
