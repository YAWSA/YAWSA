//
//  VendorProfileVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 20/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit
import Alamofire
import ReachabilitySwift

class VendorProfileVC: UIViewController,passImageDelegate {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var imgVwUserProfile: SetCornerImageView!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var txtfieldLastName: UITextField!
    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldCivilIdNumber: UITextField!
    @IBOutlet weak var txtFieldMobileNumber1: UITextField!
    @IBOutlet weak var txtFieldMobileNumber2: UITextField!
    @IBOutlet weak var txtFieldAddress: UITextField!
    @IBOutlet weak var txtFieldShopNumber: UITextField!
    @IBOutlet weak var btnSwitchLocation: UISwitch!
    
    //MARK: - variable
    var galleryFunctions =  GalleryCameraImage()
    var clickEditBtn = Int ()
     let objAutoComplete = AutoComplete ()
    var objVendorProfileVM = VendorProfileViewModel ()
    override func viewDidLoad() {
        super.viewDidLoad()
    clickEditBtn = 0
    galleryCameraImageObj = self
        
        
    Proxy.shared.addTabBottomForVendor(vwBottom, tabNumber: TabTitleVendor.TAB_Profile,currentViewController: self, currentStoryboard: StoryboardChnage.vendorStoryboard)
        if KAppDelegate.profileDetaiVendor.shopLocation != ""{
        autoCompleteModel.addressVal = KAppDelegate.profileDetaiVendor.shopLocation
        }
      self.userInteactionDisable ()
      self.showVendorDetails()
        
        setUpStaticsValue()
    }
    func setUpStaticsValue() {
        lblHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.myAccount)
        txtFieldFirstName.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.firstName))
        txtfieldLastName.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.lastName))
        txtFieldEmail.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.Email))
         txtFieldCivilIdNumber.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.civilid))
        txtFieldMobileNumber1.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.mobile1))
        txtFieldMobileNumber2.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.mobile2))
        txtFieldShopNumber.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.shopMobNo))
        txtFieldAddress.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.shopAddress))
             btnEdit.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.edit), for: .normal)
        lblLocation.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.location)
        lblLanguage.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.changeLanguage)
        
    }
    override func viewWillAppear(_ animated: Bool) {
         txtFieldAddress.text = autoCompleteModel.addressVal
        if KAppDelegate.profileDetaiVendor.isOnOff == 0 {
            self.btnSwitchLocation.setOn(false, animated:true)
        }else{
            self.btnSwitchLocation.setOn(true, animated:true)
        }
    }
    //MARK: - Action Camera
    @IBAction func actionCamera(_ sender: UIButton) {
          galleryFunctions.customActionSheet()
    }
    @IBAction func actionChangeLanguage(_ sender: UIButton) {
        customVendorActionSheetLanguage()
    }
    
    func customVendorActionSheetLanguage() {
        let myActionSheet = UIAlertController(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.selectLanguage), message: "", preferredStyle: .actionSheet)
        
        let englishAction = UIAlertAction(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.english), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            UserDefaults.standard.set("0", forKey: "LanguageSelect")
            UserDefaults.standard.synchronize()
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            RootControllerProxy.shared.rootWithoutDrawer(StoryboardChnage.vendorStoryboard, identifier: "CategoryVC")
        })
        let otherAction = UIAlertAction(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.Other), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            UserDefaults.standard.set("1", forKey: "LanguageSelect")
            UserDefaults.standard.synchronize()
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            RootControllerProxy.shared.rootWithoutDrawer(StoryboardChnage.vendorStoryboard, identifier: "CategoryVC")
            
        })
        
        let cancelAction = UIAlertAction(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.cancel), style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        myActionSheet.addAction(englishAction)
        myActionSheet.addAction(otherAction)
        myActionSheet.addAction(cancelAction)
        KAppDelegate.window?.currentViewController()?.present(myActionSheet, animated: true, completion: nil)
    }
    // Function PassSelectedImage
    func passSelectedimage(selectImage: UIImage) {
        imgVwUserProfile.image = selectImage
    }
    
    //MARK:- ActionEdit
    @IBAction func ActionEdit(_ sender: UIButton) {
        if clickEditBtn == 0 {
            UserInteactionEnble ()
            btnEdit.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.save), for: .normal)
            self.clickEditBtn = 1
        }else {
            let param = [
                "VendorProfile[first_name]":"\(txtFieldFirstName.text!)" ,
                "VendorProfile[last_name]" : "\(txtfieldLastName.text!)" ,
                "User[email]": "\(txtFieldEmail.text!)" ,
                "VendorProfile[whats_app_no]":"\(txtFieldShopNumber.text!)" ,
                "VendorProfile[civil_id]" : "\(txtFieldCivilIdNumber.text!)" ,
                "VendorAddress[location]" : "\(txtFieldAddress.text!)" ,
                "VendorLocation[latitude]" : "\(autoCompleteModel.latitude)" ,
                "VendorLocation[longitude]" : "\(autoCompleteModel.longitude)",
                "User[contact_no]":"\(txtFieldMobileNumber1.text!)" ,
                "User[contact_no_1]":"\(txtFieldMobileNumber2.text!)" ,
                ] as [String:AnyObject]
            
            let paramImage = [
                "VendorProfile[shop_logo]": imgVwUserProfile.image!
            ]
            
            let updateUrl = "\(Apis.KServerUrl)\(Apis.KUpdateDetailsVendor)"
            WebServiceProxy.shared.uploadImage(param, parametersImage: paramImage, addImageUrl: updateUrl, showIndicator: true) { (jsonResponse) in
                print("jsonResponse",jsonResponse)
                if jsonResponse["status"] as! Int == 200 {
                    if let detailDict = jsonResponse["detail"] as? NSDictionary {
                        KAppDelegate.profileDetaiVendor.userDict(dict: detailDict)
                        Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.profileUpdate))
                        self.btnEdit.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.edit), for: .normal)
                        self.clickEditBtn = 0
                        self.userInteactionDisable ()
                    }
                } else {
                    if let error = jsonResponse["error"] as? String {
                        Proxy.shared.displayStatusCodeAlert(error)
                    }
                }
            }
        }
    }
    //MARK:- Action Switch
    @IBAction func actionSwitch(_ sender: UISwitch) {
        
          objVendorProfileVM.checkLocationOnOff{
            if self.btnSwitchLocation.isOn {
                self.btnSwitchLocation.setOn(true, animated:true)
            } else {
                self.btnSwitchLocation.setOn(false, animated:true)
            }
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   

}
