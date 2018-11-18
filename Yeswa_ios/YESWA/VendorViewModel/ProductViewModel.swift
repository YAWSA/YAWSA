//
//  ProductViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 27/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit


class ProductViewModel {
    
    var pageNumber = 0
    var totalPageCount = Int()
    var currentLat = String ()
    var currentLong  = String ()
    var productListArr = [AddProductWithoutVarientModel]()
    var brandID = Int()
    
    func getProductList(_ completion:@escaping() -> Void) {
        self.pageNumber = 0
        self.productListArr = []
       
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KgetProductList)?brandid=\(brandID)&page=\(pageNumber)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                
                if JSON["pageCount"] != nil  {
                    self.totalPageCount = JSON["pageCount"] as! Int
                }
                
                if self.pageNumber == 0{
                    self.productListArr = []
                }
                
                if  let listArray = JSON["list"] as? NSArray {
                    for i in 0 ..< listArray.count{
                        let dictProudctList = listArray.object(at: i) as! NSDictionary
                        
                        let addProductWithoutVarientModelObj = AddProductWithoutVarientModel()
                        addProductWithoutVarientModelObj.proudctListDict(dict: dictProudctList)
                        self.productListArr.append(addProductWithoutVarientModelObj)
                        
                    }
                }
                
                
            }else{
                if let error = JSON["error"] as? String {
                }
            }
            completion()
        }
        
    }
    
}
//MARK:- Extension Class ----

extension ProductVC:UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- TableView DataSource Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  productViewModelObj.productListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTVC") as? ProductTVC
        let productListDict = productViewModelObj.productListArr[indexPath.row]
        cell?.lblTitle.text = productListDict.productTitle
        cell?.lblDescription.text = productListDict.productDescription
       
        
        
        if productListDict.imgProductArray.count != 0
        {
            let imgStr = productListDict.imgProductArray[0].productImg
             cell?.imgVwProduct.sd_setImage( with: URL(string: (imgStr)), placeholderImage: #imageLiteral(resourceName: "ic_product"))
        }
        cell?.btnEdit.tag = productListDict.productId
        cell?.btnEdit.addTarget(self, action: #selector(self.actionBtnEdit(_:)), for: .touchUpInside)
        cell?.btnDelete.tag =  productListDict.productId
        cell?.btnDelete.addTarget(self, action: #selector(self.actionBtnDelete(_:)), for: .touchUpInside)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productListDict = productViewModelObj.productListArr[indexPath.row]
        let brandVCObj =  self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVCVendor") as! ProductDetailVCVendor
        
        brandVCObj.objDetailVendorViewModel.productID = productViewModelObj.productListArr[indexPath.row].productId
        self.navigationController?.pushViewController(brandVCObj, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == productViewModelObj.productListArr.count-1 {
            if productViewModelObj.pageNumber+1 < productViewModelObj.totalPageCount {
                productViewModelObj.pageNumber =  productViewModelObj.pageNumber + 1
                productViewModelObj.getProductList {
                    self.tblViewProductList.reloadData()
                }
            }
        }
    }
    

    // MARK:- Action Edit Product
    @objc func actionBtnEdit(_ sender: UIButton) {
    }
    
    //MARK:- Button Actoin - Delete Product
    @objc func actionBtnDelete(_ sender: UIButton) {
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KDeleteProduct)?id=\(sender.tag)", params: nil, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.deleteProductSuccessfully))
                self.productViewModelObj.getProductList {
                    self.tblViewProductList.reloadData()
                }
            } else {
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
        })
    }
}
