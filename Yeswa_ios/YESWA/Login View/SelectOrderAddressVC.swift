//
//  SelectOrderAddressVC.swift
//  YESWA
//
//  Created by Ankita Thakur on 09/05/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class SelectOrderAddressVC: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txtFieldSelectGovernet: UITextField!
    @IBOutlet weak var txtFieldSelectRegion : UITextField!
    @IBOutlet weak var txtFieldhouse: UITextField!
    @IBOutlet weak var txtFieldStreet: UITextField!
    @IBOutlet weak var txtFieldZipcode: UITextField!
    @IBOutlet weak var btnDone: SetCornerButton!
    var selectedGovernorateId = Int()
    var selectedRegionId = Int ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFieldSelectGovernet.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.selectGovern))
        txtFieldSelectRegion.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.selectRegion))
        txtFieldhouse.setPlaceHolderColor(txtString: "\(Proxy.shared.languageSelectedStringForKey(ConstantValue.addressLine))1")
        txtFieldStreet.setPlaceHolderColor(txtString: "\(Proxy.shared.languageSelectedStringForKey(ConstantValue.addressLine))2")
        txtFieldZipcode.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.PhoneNumber))
        lblHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.address)
    btnDone.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.done), for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handelGovernorateSelectNotification(_:)), name: NSNotification.Name("GovernentSelect"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handelRegionSelectNotification(_:)), name: NSNotification.Name("AreaSelect"), object: nil)
        
        
       txtFieldhouse.text! =  objSelectOrderAddressModel.house 
       txtFieldStreet.text! = objSelectOrderAddressModel.street
       txtFieldSelectGovernet.text! = objSelectOrderAddressModel.governorate
       txtFieldSelectRegion.text! = objSelectOrderAddressModel.region
       txtFieldZipcode.text! = objSelectOrderAddressModel.mobileNo

    }
    
    //MARK:- Handle Notification
    @objc func handelGovernorateSelectNotification( _ notification: Notification)  {
        let dict = notification.object as! NSDictionary
        txtFieldSelectGovernet.text = dict["title"] as? String
        selectedGovernorateId = (dict["governentId"] as? Int)!
    }
    
    @objc func handelRegionSelectNotification( _ notification: Notification)  {
        let dict = notification.object as! NSDictionary
        txtFieldSelectRegion.text = dict["title"] as? String
        selectedRegionId = (dict["regionId"] as? Int)!
    }
    //MARK:- Actino Back
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    //MARK:- UITextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFieldhouse {
            txtFieldStreet.becomeFirstResponder()
        } else if  textField == txtFieldSelectGovernet{
            txtFieldSelectRegion.becomeFirstResponder ()
        }
        else if  textField == txtFieldSelectRegion{
            txtFieldhouse.becomeFirstResponder ()
        }
        else if  textField == txtFieldhouse{
            txtFieldStreet.becomeFirstResponder ()
        }
        else if  textField == txtFieldStreet{
            txtFieldZipcode.becomeFirstResponder ()
        }
        else {
            txtFieldZipcode.resignFirstResponder()
        }
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtFieldSelectGovernet {
            txtFieldSelectGovernet.resignFirstResponder()
            let selectGovernentAreaVCObj = storyboard?.instantiateViewController(withIdentifier: "SelectGovernentAreaVC") as! SelectGovernentAreaVC
              selectGovernentAreaVCObj.isTextField = 1
               selectGovernentAreaVCObj.isSelectGoverArea = "Select Governorate"
            self.present(selectGovernentAreaVCObj, animated: true, completion: nil)
            return false
            
        }else if textField == txtFieldSelectRegion {
            if txtFieldSelectGovernet.text != ""{
            txtFieldSelectRegion.resignFirstResponder()
            let selectGovernentAreaVCObj = storyboard?.instantiateViewController(withIdentifier: "SelectGovernentAreaVC") as! SelectGovernentAreaVC
             selectGovernentAreaVCObj.isTextField = 2
         selectGovernentAreaVCObj.isSelectGoverArea = "Select Region"
        selectGovernentAreaVCObj.objSelectGovernentAreaVM.selectedCountryId = selectedGovernorateId
            self.present(selectGovernentAreaVCObj, animated: true, completion: nil)
            return false
        }
        else{
                txtFieldSelectRegion.resignFirstResponder()
                
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.selectCountryFirst))
                
                return false
            }
        }
        else{
            return true
        }
    }
    
    // Action Done
    @IBAction func actionDone(_ sender: UIButton) {
        
        if txtFieldSelectGovernet.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.country))
        }
        else if txtFieldSelectRegion.text!.isEmpty {
              Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.state))
        }
        else if txtFieldhouse.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.house))
        }
        else if txtFieldStreet.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.street))
        }
        else if txtFieldZipcode.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.phoneNumber))
        }
        else {
            objSelectOrderAddressModel.house = txtFieldhouse.text!
            objSelectOrderAddressModel.street = txtFieldStreet.text!
            objSelectOrderAddressModel.governorate = txtFieldSelectGovernet.text!
            objSelectOrderAddressModel.region = txtFieldSelectRegion.text!
            objSelectOrderAddressModel.mobileNo = txtFieldZipcode.text!
            objSelectOrderAddressModel.regionId = selectedRegionId
            
            Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
        }
        
       
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

   
}
