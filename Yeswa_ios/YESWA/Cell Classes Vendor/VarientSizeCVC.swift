//
//  VarientSizeCVC.swift
//  YESWA
//
//  Created by Ankita Thakur on 13/07/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class VarientSizeCVC: UICollectionViewCell,UITextFieldDelegate {
    @IBOutlet var lblTitle : UITextField!
    @IBOutlet var btnCross : UIButton!
    var mainIndexPath = Int()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblTitle.delegate = self
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        var getsection = Int()
        getsection = textField.tag/10000
        var getRow = Int()
        getRow = textField.tag%10000
        print("textFieldShouldEndEditing: ",getsection,getRow)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        var getRow = Int()
        getRow = textField.tag%10000
        print("GetRow: ",getRow)
        lblTitle.resignFirstResponder()
        NotificationCenter.default.post(name: NSNotification.Name("ForSize"), object: textField.tag)
        return false
    }

}
