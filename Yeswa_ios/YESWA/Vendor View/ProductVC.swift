//
//  ProductVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 27/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class ProductVC: UIViewController {
    //MARK:- Outlet
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblAddNew: UILabel!
    @IBOutlet weak var tblViewProductList: UITableView!
      var productViewModelObj =  ProductViewModel()
    var brandId = Int ()
    var categoryId = Int ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productViewModelObj.brandID = self.brandId
          productViewModelObj.getProductList {
          self.tblViewProductList.reloadData()
        }
        
        lblHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.product)
        lblAddNew.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.addNewProdouct)
        
       
    }
    //MARK:- Action Back
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func actionBtnAddNewProduct(_ sender: UIButton) {
        
        let brandVCObj =  self.storyboard?.instantiateViewController(withIdentifier: "AddCategoryVC") as! AddCategoryVC
        brandVCObj.objSelectCategoryViewModel.selectCategoryId =  categoryId
        brandVCObj.objSelectCategoryViewModel.selectBrandId = brandId
        self.navigationController?.pushViewController(brandVCObj, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   

}
