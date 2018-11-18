//
//  AddVarientSelectColorSizeVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 29/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class AddVarientSelectColorSizeVC: UIViewController,UITextFieldDelegate {
    //MARK:- Outlet
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tableVwSelectcolorSize: UITableView!
     @IBOutlet weak var lblSelectField: UILabel!
    
    //variable
    var objSelectCategoryBrndViewModel =  SelectCategoryViewModel()
    var addVarientColorSizeViewModelObj =  AddVarientSelectColorSizeViewModel()
    var txtfieldCount = Int ()
    var isTextField =  ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if isTextField == "txtFieldColor" {
            txtfieldCount = 1
            lblSelectField.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.selectColor)
            addVarientColorSizeViewModelObj.getColor {
                self.tableVwSelectcolorSize.reloadData()
            }
        }else if isTextField == "txtFieldSize"{
            txtfieldCount = 2
            lblSelectField.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.selectSize)
            addVarientColorSizeViewModelObj.getSize {
                self.tableVwSelectcolorSize.reloadData()
            }
        }
    }
    //MARK :- Action Cross
    @IBAction func actionCross(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
        })
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
