//
//  AddVarientTVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 29/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class AddVarientTVC: UITableViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var crossAction: UIButton!
    @IBOutlet weak var addColorAction: UIButton!
    @IBOutlet weak var addSizeAction: UIButton!
    @IBOutlet weak var txtFieldColor: UITextField!
    @IBOutlet weak var txtFieldSize: UITextField!
    @IBOutlet weak var txtFieldQuentity: UITextField!
    @IBOutlet weak var txtFieldPrice: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        txtFieldColor.delegate = self
        txtFieldSize.delegate = self
        txtFieldQuentity.delegate = self
        txtFieldPrice.delegate = self

        // Initialization cZZode
    }
     func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtFieldColor {
            txtFieldQuentity.resignFirstResponder()
         txtFieldPrice.resignFirstResponder()
             NotificationCenter.default.post(name: NSNotification.Name("ForColor"), object: txtFieldColor.tag)
            return false
            
        }else if textField == txtFieldSize {
            txtFieldQuentity.resignFirstResponder()
            txtFieldPrice.resignFirstResponder()
                NotificationCenter.default.post(name: NSNotification.Name("ForSize"), object: txtFieldSize.tag)
            return false
        }else{
            return true
        }
        
        
        
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        var indexVal = Int()
        switch textField {
        case txtFieldColor:
            indexVal = textField.tag-10
        case txtFieldSize:
            indexVal = textField.tag-20
        case txtFieldQuentity:
            indexVal = textField.tag-30
        case txtFieldPrice:
            indexVal = textField.tag-40
        default:
            indexVal = textField.tag
        }
        
        let dictVariant = NSMutableDictionary()
        dictVariant.setValue(KAppDelegate.idSize, forKey: "size_id")
        dictVariant.setValue(KAppDelegate.idColor, forKey: "color_id")
        dictVariant.setValue(txtFieldColor.text!, forKey: "color")
        dictVariant.setValue(txtFieldSize.text!, forKey: "size")
        dictVariant.setValue(txtFieldQuentity.text!, forKey: "quantity")
        dictVariant.setValue(txtFieldPrice.text!, forKey: "amount")
        KAppDelegate.listVariantArr.replaceObject(at: indexVal, with: dictVariant)
        
        return true
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
