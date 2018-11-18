//
//  VarientCVC.swift
//  YESWA
//
//  Created by Ankita Thakur on 13/07/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class VarientCVC: UICollectionViewCell,UITextFieldDelegate {
    
    @IBOutlet var lblTitle : UITextField!
   
    
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
        print(getsection,getRow)
      
        let mainArrDict = KAppDelegate.listVariantArr.object(at: getsection) as! NSMutableDictionary
          let dictVariant = NSMutableDictionary()
        dictVariant.setValue(mainArrDict["color_id"], forKey: "color_id")
        dictVariant.setValue(mainArrDict["color"], forKey: "color")
        dictVariant.setValue(mainArrDict["amount"], forKey: "amount")
       
        
        let sizeQuantityArr = mainArrDict["detail"] as! NSMutableArray
        let sizeArrDict = sizeQuantityArr.object(at: getRow) as! NSMutableDictionary

        let sizeQuantityDict = NSMutableDictionary()
        sizeQuantityDict.setValue(lblTitle.text, forKey: "quantity")
        sizeQuantityDict.setValue(sizeArrDict["size_id"], forKey: "size_id")
        sizeQuantityDict.setValue(sizeArrDict["size"], forKey: "size")
        sizeQuantityArr.replaceObject(at: getRow, with: sizeQuantityDict)
        
        dictVariant.setValue(sizeQuantityArr, forKey: "detail")
   
        KAppDelegate.listVariantArr.replaceObject(at: getsection, with: dictVariant)
        return true
    }

}
