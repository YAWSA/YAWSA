//
//  ProuctListCusomerViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 05/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit


class ProuctListCusomerViewModel: NSObject {
    
    var pageNumber = 0
    var totalPageCount = Int()
    var currentLat = String ()
    var currentLong  = String ()
    var productListArr = [AddProductWithoutVarientModel]()
    var brandID = Int()
    var colorIdsArr = String()
    var sizeIdsArr = String()
    var brandIdsArr = String()
    var filterViewModelObj = FilterViewModel()
    
    
    func getProductList(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KGetAllProduct)?page=\(pageNumber)&brand_id=\(brandID)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                if JSON["pageCount"] != nil  {
                    self.totalPageCount = JSON["pageCount"] as! Int
                }
                if self.pageNumber == 0{
                    self.productListArr = []
                }
                        let listArray = JSON["list"] as! NSArray
                        for i in 0 ..< listArray.count{
                            let dictProudctList = listArray.object(at: i) as! NSDictionary
                            let objBrandVCModel = AddProductWithoutVarientModel()
                            objBrandVCModel.proudctListDict(dict: dictProudctList)
                            self.productListArr.append(objBrandVCModel)
                      }
                  }else{
                  if let error = JSON["error"] as? String {
                 
             }
            }
            completion()
        }
    }
    
    func getNewProductList(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KGetLatestProdcut)?page=\(pageNumber)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                if JSON["pageCount"] != nil  {
                    self.totalPageCount = JSON["pageCount"] as! Int
                }
                if self.pageNumber == 0{
                    self.productListArr = []
                }
                let listArray = JSON["list"] as! NSArray
                for i in 0 ..< listArray.count{
                    let dictProudctList = listArray.object(at: i) as! NSDictionary
                    let objBrandVCModel = AddProductWithoutVarientModel()
                    objBrandVCModel.proudctListDict(dict: dictProudctList)
                    self.productListArr.append(objBrandVCModel)
                }
            }else{
                if let error = JSON["error"] as? String {
                }
            }
            completion()
        }
    }
    
    func getAllProductList(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KGetAllProduct)?page=\(pageNumber)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                if JSON["pageCount"] != nil  {
                    self.totalPageCount = JSON["pageCount"] as! Int
                }
                if self.pageNumber == 0{
                    self.productListArr = []
                }
                let listArray = JSON["list"] as! NSArray
                for i in 0 ..< listArray.count{
                    let dictProudctList = listArray.object(at: i) as! NSDictionary
                    let objBrandVCModel = AddProductWithoutVarientModel()
                    objBrandVCModel.proudctListDict(dict: dictProudctList)
                    self.productListArr.append(objBrandVCModel)
                }
            }else{
                if let error = JSON["error"] as? String {
                  
                }
            }
            completion()
        }
    }
    
    func filterCategory(completion:@escaping() -> Void)   {
        pageNumber = 0
        sizeIdsArr =  filterViewModelObj.appendParam(arr: KAppDelegate.sizeFilterArr, appendFor: "id")
        colorIdsArr = filterViewModelObj.appendParam(arr: KAppDelegate.colorFilterArr, appendFor: "id")
        brandIdsArr = filterViewModelObj.appendParam(arr: KAppDelegate.brandListFilterArr, appendFor: "id")
        let param = [
            "size" :sizeIdsArr,
            "color" :"\(colorIdsArr)",
            "brand" : brandIdsArr,
            "start_price" : "\(KAppDelegate.sliderMinVal)",
            "end_price" : "\(KAppDelegate.sliderMaxVal)"
            
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KFilter)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                if JSON["pageCount"] != nil  {
                    self.totalPageCount = JSON["pageCount"] as! Int
                }
                if self.pageNumber == 0{
                    self.productListArr = []
                }
                let listArray = JSON["list"] as! NSArray
                
                for i in 0 ..< listArray.count{
                    let dictProudctList = listArray.object(at: i) as! NSDictionary
                    let objBrandVCModel = AddProductWithoutVarientModel()
                    objBrandVCModel.proudctListDict(dict: dictProudctList)
                    self.productListArr.append(objBrandVCModel)
                }
                
            } else {
                let error = JSON["error"] as? String ?? "error"
                Proxy.shared.displayStatusCodeAlert(error)
            }
            completion()
        })
        
    }
    
    //MARK:- Get Product Favourite List
    func getFavouriteList(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KGetWishListProduct)?page=\(pageNumber)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                if JSON["pageCount"] != nil  {
                    self.totalPageCount = JSON["pageCount"] as! Int
                }
                if self.pageNumber == 0{
                    self.productListArr = []
                }
                let listArray = JSON["list"] as! NSArray
                
                for i in 0 ..< listArray.count{
                    let dictProudctList = listArray.object(at: i) as! NSDictionary
                    let objBrandVCModel = AddProductWithoutVarientModel()
                    objBrandVCModel.proudctListDict(dict: dictProudctList)
                    self.productListArr.append(objBrandVCModel)
                }
                
            }else{
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
            completion()
        }
    }
}
//MARK:- Extension Class
extension ProuductListVCCustomer:UITableViewDelegate,UITableViewDataSource {
    
//MARK:- TableView DataSource Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  productListCustomerModelObj.productListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListTVCCustomer") as! ProductListTVCCustomer
        let dict = productListCustomerModelObj.productListArr[indexPath.row]
        cell.lblProductName.text = dict.productTitle
        cell.lblDesecription.text = dict.productDescription
        if dict.imgProductArray.count != 0
        {
            let imgStr = dict.imgProductArray[0].productImg
            cell.imgVwProduct.sd_setImage(with: URL(string:  imgStr), completed: nil)
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
 }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFromController == "ProfileVC" {
            let productDetailDict = productListCustomerModelObj.productListArr[indexPath.row]
            if   productDetailDict.varientMultipleSizeModelArr.count != 0{
                let productDetailVCObj =  self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVCCustomer") as! ProductDetailVCCustomer
                productDetailVCObj.isFromController = "ProfileVC"
                productDetailVCObj.productDetailDict = productListCustomerModelObj.productListArr[indexPath.row]
                self.navigationController?.pushViewController(productDetailVCObj, animated: true)
            }else{
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.noAvailble))
            }
            
        }else{
            let productDetailDict = productListCustomerModelObj.productListArr[indexPath.row]
            if   productDetailDict.varientMultipleSizeModelArr.count != 0{
                let productDetailVCObj =  self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVCCustomer") as! ProductDetailVCCustomer
                
                productDetailVCObj.productDetailDict = productListCustomerModelObj.productListArr[indexPath.row]
                self.navigationController?.pushViewController(productDetailVCObj, animated: true)
            }else{
                
                 Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.noAvailble))
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == productListCustomerModelObj.productListArr.count-1 {
            if productListCustomerModelObj.pageNumber+1 < productListCustomerModelObj.totalPageCount {
                productListCustomerModelObj.pageNumber =  productListCustomerModelObj.pageNumber + 1
                
            if isFromController == "ProfileVC" {
                productListCustomerModelObj.getFavouriteList {
                    self.tblVwPrdouctList.reloadData()
                }
            } else if isFromController == "HomeVC" {
                productListCustomerModelObj.getAllProductList {
                    self.tblVwPrdouctList.reloadData()
                }
            }
            else if isFromController == "HomeVCNewProduct" {
                productListCustomerModelObj.getAllProductList {
                    self.tblVwPrdouctList.reloadData()
                }
            }
        }
        }
    }
}
