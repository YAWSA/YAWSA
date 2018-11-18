//
//  ProuductListVCCustomer.swift
//  YESWA
//
//  Created by Sonu Sharma on 05/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class ProuductListVCCustomer: UIViewController {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnAddCart: UIButton!
    @IBOutlet weak var tblVwPrdouctList: UITableView!
    var productListCustomerModelObj =  ProuctListCusomerViewModel()
    var brandId = Int ()
    var categoryId = Int ()
    var isFromController = ""
    override func viewDidLoad() {
        super.viewDidLoad()
         lblHeader.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.product)
        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        //check
        if isFromController == "ProfileVC" {
            productListCustomerModelObj.productListArr = []
            productListCustomerModelObj.pageNumber = 0
            productListCustomerModelObj.getFavouriteList {
                 self.tblVwPrdouctList.reloadData()
            }
        } else if isFromController == "HomeVC" {
            productListCustomerModelObj.getAllProductList {
                self.tblVwPrdouctList.reloadData()
            }
        }
        else if isFromController == "HomeVCNewProduct" {
            productListCustomerModelObj.getNewProductList {
                self.tblVwPrdouctList.reloadData()
            }
        }
        else {
            productListCustomerModelObj.brandID = brandId
            productListCustomerModelObj.productListArr = []
            productListCustomerModelObj.pageNumber = 0
            if brandId == 0{
                productListCustomerModelObj.filterCategory {
                     self.tblVwPrdouctList.reloadData()
                }
            }else{
            productListCustomerModelObj.getProductList {
                self.tblVwPrdouctList.reloadData()
            }
        }
       }
    
}
        
//MARK:- Action Back
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    //MARK:- Action Add Cart btn
    @IBAction func actionbtnCart(_ sender: UIButton) {
        Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.mainStoryboard, identifier: "CartVC", isAnimate: true, currentViewController: self)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
