//
//  BrandVC.swift
//  YeshwaVendor
//
//  Created by Babita Chauhan on 17/03/18.
//  Copyright © 2018 Desh Raj Thakur. All rights reserved.
//

import UIKit
import SDWebImage
class BrandVC: UIViewController {
     //Outlet
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tblViewBrand: UITableView!
    @IBOutlet weak var lblAddNew: UILabel!
    // Variable
    var brandViewModelObj =  BrandViewModel()
    var categoryIdVal = Int ()
    
    //MARK:- Button Add New Action
    
    override func viewDidLoad() {
        super.viewDidLoad()
         lblHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.brands)
         lblAddNew.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.addnewbrand)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
        self.brandViewModelObj.categoryId = self.categoryIdVal
        brandViewModelObj.getBrandList {
            self.tblViewBrand.reloadData()
        }
    }
    //MARK:- Action BtnAction
    @IBAction func btnAddNewItem(_ sender: Any) {
        let addBrandVCObj = storyboard?.instantiateViewController(withIdentifier: "AddBrandVC") as! AddBrandVC
        addBrandVCObj.categoryID = categoryIdVal
        self.navigationController?.pushViewController(addBrandVCObj, animated: true)
    }
   
    @IBAction func actionBack(_ sender: UIButton) {
         Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
