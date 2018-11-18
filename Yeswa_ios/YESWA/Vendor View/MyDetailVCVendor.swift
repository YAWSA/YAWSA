//
//  MyDetailVCVendor.swift
//  YESWA
//
//  Created by Sonu Sharma on 19/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class MyDetailVCVendor: UIViewController,passImageDelegate {
    
     @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var txtFieldLastName: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var txtFieldWhatUpNumber: UITextField!
    @IBOutlet weak var txtFieldCivilId: UITextField!
    @IBOutlet weak var txtFieldShopName: UITextField!
    @IBOutlet weak var txtFieldLocation: UITextField!
    @IBOutlet weak var txtFieldPhoneNumber: UITextField!
    @IBOutlet weak var txtFieldCity: UITextField!
    @IBOutlet weak var txtFieldArea: UITextField!
    @IBOutlet weak var txtFieldBlock: UITextField!
    @IBOutlet weak var txtFieldStreet: UITextField!
    @IBOutlet weak var txtFieldApartment: UITextField!
    @IBOutlet weak var txtFieldHouse: UITextField!
    @IBOutlet weak var txtFieldOffice: UITextField!
    @IBOutlet weak var imgVwShopLogo: UIImageView!
    @IBOutlet weak var btnsaveChange: UIButton!
    
    let objAutoComplete = AutoComplete ()
    var galleryFunctions =  GalleryCameraImage()

    override func viewDidLoad() {
        super.viewDidLoad()
       galleryCameraImageObj = self
    }
    
    
    //MARK:- Action Camera 
    @IBAction func actionCamera(_ sender: UIButton) {
        galleryFunctions.customActionSheet()
    }
    
    func passSelectedimage(selectImage: UIImage) {
        imgVwShopLogo.image = selectImage
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
            txtFieldEmail.becomeFirstResponder ()
        }
        else if  textField == txtFieldEmail{
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
            txtFieldPhoneNumber.becomeFirstResponder ()
        }
        else if  textField == txtFieldPhoneNumber{
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
    //MARK:- Action Back
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)

    }
    
    @IBAction func actionSaveChanges(_ sender: UIButton) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
