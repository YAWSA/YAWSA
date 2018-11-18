//
//  AllVendorProductListVM.swift
//  YESWA
//
//  Created by Sonu Sharma on 27/06/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import  UIKit

class AllVendorProductListVM: NSObject {
    
    var vendoridVal = Int ()
    var pageNumber = 0
    var totalPageCount = Int()
    var productListArr = [AddProductWithoutVarientModel]()

    func getVendorProudctList(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KGetVendorProductsList)?id=\(vendoridVal)&page=\(pageNumber)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                
                if JSON["totalPage"] != nil  {
                    self.totalPageCount = JSON["totalPage"] as! Int
                }
                if self.pageNumber == 0{
                    self.productListArr = []
                }
                
                if  let categoryListArray = JSON["detail"] as? NSArray {
                    for i in 0 ..< categoryListArray.count{
                        let dictProudctList = categoryListArray.object(at: i) as! NSDictionary
                        let objBrandVCModel = AddProductWithoutVarientModel()
                        objBrandVCModel.proudctListDict(dict: dictProudctList)
                    self.productListArr.append(objBrandVCModel)
                    }
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

extension AllVendorProductListVC:UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- TableView DataSource Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  objAllVendorProductListVM.productListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllVendorProductListTVC") as! AllVendorProductListTVC
        
        let dictCell = objAllVendorProductListVM.productListArr[indexPath.row]
        
        cell.lblProductName.text =  dictCell.productTitle
        cell.lblDesecription.text = "\(dictCell.productDescription!)"
        
        if dictCell.imgProductArray.count == 0 {
             cell.imgVwProduct.image = #imageLiteral(resourceName: "ic_product")
        }else {
            cell.imgVwProduct.sd_setImage(with: URL(string:  dictCell.imgProductArray[0].productImg), completed: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        if indexPath.row == objAllVendorProductListVM.productListArr.count-1 {
            if objAllVendorProductListVM.pageNumber+1 < objAllVendorProductListVM.totalPageCount {
                objAllVendorProductListVM.pageNumber =  objAllVendorProductListVM.pageNumber + 1
                objAllVendorProductListVM.getVendorProudctList {
                    self.tblVwProductList.reloadData()
                }
            }
        }
    }
    
// MARK:- TableView Did Select--
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productDetailDict = objAllVendorProductListVM.productListArr[indexPath.row]
        if   productDetailDict.varientMultipleSizeModelArr.count != 0{
            let productDetailVCObj =  self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVCCustomer") as! ProductDetailVCCustomer
            productDetailVCObj.productDetailDict = objAllVendorProductListVM.productListArr[indexPath.row]
            self.navigationController?.pushViewController(productDetailVCObj, animated: true)
        }else{
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.noAvailble))
            
        }
    }
}
