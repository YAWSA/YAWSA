//
//  SwitchToVendorVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 13/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class SwitchToVendorVC: UIViewController,UITextFieldDelegate,passImageDelegate {
    //Outlet
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var txtFieldLastName: UITextField!
    @IBOutlet weak var txtFieldWhatUpNumber: UITextField!
    @IBOutlet weak var txtFieldCivilId: UITextField!
    @IBOutlet weak var txtFieldShopName: UITextField!
    @IBOutlet weak var txtFieldLocation: UITextField!
    @IBOutlet weak var txtFieldPhoneNumber1: UITextField!
    @IBOutlet weak var txtFieldPhoneNumber2: UITextField!
    
    @IBOutlet weak var txtFieldCity: UITextField!
    @IBOutlet weak var txtFieldArea: UITextField!
    @IBOutlet weak var txtFieldBlock: UITextField!
    @IBOutlet weak var txtFieldStreet: UITextField!
    @IBOutlet weak var txtFieldApartment: UITextField!
    @IBOutlet weak var txtFieldHouse: UITextField!
    @IBOutlet weak var txtFieldOffice: UITextField!
    @IBOutlet weak var imgVwShopLogo: UIImageView!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    // Variable
    var galleryFunctions =  GalleryCameraImage()
    var objSwitchToVendorVwModel = SwitchToVendorViewModel ()
    let objAutoComplete = AutoComplete ()
    
    
    override func viewDidLoad() {
     super.viewDidLoad()
       
       galleryCameraImageObj = self
        setUpStaticsValue()
    }
    func setUpStaticsValue() {
        
        txtFieldFirstName.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.firstName))
        txtFieldLastName.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.lastName))
        txtFieldWhatUpNumber.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.whatsAppNumber))
        txtFieldCivilId.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.civilid))
        txtFieldShopName.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.shopName))
        txtFieldLocation.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.location))
        txtFieldPhoneNumber1.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.mobile1))
        txtFieldPhoneNumber2.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.mobile2))
        txtFieldCity.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.city))
        txtFieldArea.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.area))
        txtFieldBlock.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.block))
         txtFieldStreet.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.street))
        
         txtFieldApartment.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.appartment))
         txtFieldHouse.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.house))
        txtFieldOffice.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.office))
       
       
       lblHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.swichUser)
        btnSignup.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.save), for: .normal)
       
        
    }
    override func viewWillAppear(_ animated: Bool) {
    txtFieldLocation.text = autoCompleteModel.addressVal
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtFieldLocation {
            objAutoComplete.searchPlaces(self)
            return false
        }else{
            return true
        }
    }
    
    //MARK:- UITextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFieldFirstName {
            txtFieldLastName.becomeFirstResponder()
        } else if  textField == txtFieldLastName{
            txtFieldWhatUpNumber.becomeFirstResponder ()
        }
        else if  textField == txtFieldWhatUpNumber{
            txtFieldCivilId.becomeFirstResponder ()
        }
        else if  textField == txtFieldCivilId{
            txtFieldShopName.becomeFirstResponder ()
        }else if  textField == txtFieldShopName{
            txtFieldLocation.becomeFirstResponder ()
        }else if  textField == txtFieldLocation{
            txtFieldPhoneNumber1.becomeFirstResponder ()
        }
        else if  textField == txtFieldPhoneNumber1{
            txtFieldPhoneNumber2.becomeFirstResponder ()
        }
        else if  textField == txtFieldPhoneNumber2{
            txtFieldCity.becomeFirstResponder ()
        }
        else if  textField == txtFieldCity{
            txtFieldArea.becomeFirstResponder ()
        }
        
        else if  textField == txtFieldArea{
            txtFieldBlock.becomeFirstResponder ()
        }
        else if  textField == txtFieldBlock{
            txtFieldStreet.becomeFirstResponder ()
        }
        else if  textField == txtFieldStreet{
            txtFieldApartment.becomeFirstResponder ()
        }
        else if  textField == txtFieldApartment{
            txtFieldHouse.becomeFirstResponder ()
        }
        else if  textField == txtFieldHouse{
            txtFieldOffice.becomeFirstResponder ()
        }
        else {
            txtFieldOffice.resignFirstResponder()
        }
        return true
    }
    
   
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    //AMRK:- Action Camera
    @IBAction func actionCamera(_ sender: UIButton) {
        galleryFunctions.customActionSheet()
    }
    
    func passSelectedimage(selectImage: UIImage) {
        imgVwShopLogo.image = selectImage
    }
    
    // Action Signup
    @IBAction func actionSignup(_ sender: UIButton) {
        removeBoarder()
        
        if txtFieldFirstName.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.firstname))
            addBoarder(txtFieldFirstName)

        }
        else if txtFieldLastName.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.lastName))
            addBoarder(txtFieldLastName)

            
        } else if txtFieldWhatUpNumber.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.whatAppNumber))
            addBoarder(txtFieldWhatUpNumber)

            
        }
        else if txtFieldCivilId.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.civilId))
            addBoarder(txtFieldCivilId)

            
        }
        else if txtFieldShopName.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.shopName))
            addBoarder(txtFieldShopName)

            
        } else if txtFieldLocation.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.selectLocation))
            addBoarder(txtFieldLocation)

            
        } else if txtFieldPhoneNumber1.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.phoneNumber))
            addBoarder(txtFieldPhoneNumber1)

        }
        else if txtFieldPhoneNumber2.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.phoneNumber))
            addBoarder(txtFieldPhoneNumber2)

        }
        else if txtFieldCity.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.city))
            addBoarder(txtFieldCity)

        }
        else if txtFieldArea.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.area))
            addBoarder(txtFieldArea)

            
        }
        else if txtFieldBlock.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.block))
           addBoarder(txtFieldBlock)
            
        }
            
        else if txtFieldStreet.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.street))
            addBoarder(txtFieldStreet)

           
        }
            
        else if txtFieldHouse.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.house))
            addBoarder(txtFieldHouse)

            
        }
        else if txtFieldApartment.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.appartment))
          
            addBoarder(txtFieldApartment)

        }
        else if txtFieldOffice.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.office))
           addBoarder(txtFieldOffice)
            
        }else{
            
            objSwitchToVendorVwModel.firstName = txtFieldFirstName.text!
            objSwitchToVendorVwModel.lastName = txtFieldLastName.text!
            objSwitchToVendorVwModel.whatupNumber = txtFieldWhatUpNumber.text!
            objSwitchToVendorVwModel.civilId = txtFieldCivilId.text!
            objSwitchToVendorVwModel.shopName = txtFieldShopName.text!
            objSwitchToVendorVwModel.loctaion = txtFieldLocation.text!
            objSwitchToVendorVwModel.contactNumber = txtFieldPhoneNumber1.text!
            objSwitchToVendorVwModel.contactNubmer2 = txtFieldPhoneNumber2.text!
            objSwitchToVendorVwModel.city = txtFieldCity.text!
            objSwitchToVendorVwModel.area = txtFieldArea.text!
            objSwitchToVendorVwModel.block = txtFieldBlock.text!
            objSwitchToVendorVwModel.street =  txtFieldStreet.text!
            objSwitchToVendorVwModel.house =  txtFieldHouse.text!
            objSwitchToVendorVwModel.apartment =  txtFieldApartment.text!
            objSwitchToVendorVwModel.office =  txtFieldOffice.text!
            objSwitchToVendorVwModel.shopLogo = imgVwShopLogo.image!
            
            let alertController = UIAlertController(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.locationSetting), message: Proxy.shared.languageSelectedStringForKey(ConstantValue.showLocation), preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.no), style: .default) { (action:UIAlertAction!) in
                self.objSwitchToVendorVwModel.islocationTrack = 0
                self.hitApi()
                
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.yes), style: .cancel) { (action:UIAlertAction!) in
                self.objSwitchToVendorVwModel.islocationTrack = 1
                self.hitApi()
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    func  hitApi () {
        objSwitchToVendorVwModel.switchUser {
            RootControllerProxy.shared.rootWithoutDrawer(StoryboardChnage.vendorStoryboard, identifier: "CategoryVC")
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.switchRollSuccessfully))
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func removeBoarder(){
        self.txtFieldCivilId.layer.borderWidth = 0
        self.txtFieldFirstName.layer.borderWidth = 0
        self.txtFieldLastName.layer.borderWidth = 0
        self.txtFieldWhatUpNumber.layer.borderWidth = 0
        self.txtFieldShopName.layer.borderWidth = 0
        self.txtFieldLocation.layer.borderWidth = 0
        self.txtFieldPhoneNumber1.layer.borderWidth = 0
        self.txtFieldPhoneNumber2.layer.borderWidth = 0
        self.txtFieldCity.layer.borderWidth = 0
        self.txtFieldArea.layer.borderWidth = 0
        self.txtFieldBlock.layer.borderWidth = 0
        self.txtFieldStreet.layer.borderWidth = 0
        self.txtFieldHouse.layer.borderWidth = 0
        self.txtFieldApartment.layer.borderWidth = 0
        self.txtFieldOffice.layer.borderWidth = 0
    }
    
    func addBoarder(_ txtFldEmpty: UITextField){
        //txtFldEmpty.becomeFirstResponder()
        txtFldEmpty.layer.borderColor = UIColor.red.cgColor
        txtFldEmpty.layer.borderWidth = 1.0
        txtFldEmpty.setLeftPaddingPoints(5)
        txtFldEmpty.setRightPaddingPoints(5)
    }
    

}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

