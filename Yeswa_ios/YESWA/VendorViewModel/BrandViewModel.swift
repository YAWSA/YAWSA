//
//  File.swift
//  YeshwaVendor
//
//  Created by Babita Chauhan on 17/03/18.
//  Copyright © 2018 Desh Raj Thakur. All rights reserved.
//

import Foundation
import UIKit

class BrandViewModel {
    
    var pageNumber = 0
    var totalPageCount = Int()
    var currentLat = String ()
    var currentLong  = String ()
    var brandListArr = [BrandVCModel]()
    var categoryId = Int()
    
    func getBrandList(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KgetBrandList)?catid=\(categoryId)&page=\(pageNumber)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                if JSON["pageCount"] != nil  {
                    self.totalPageCount = JSON["pageCount"] as! Int
                }
                if self.pageNumber == 0{
                    self.brandListArr = []
                }
                if  let listArray = JSON["list"] as? NSArray {
                        for i in 0 ..< listArray.count{
                            let dictProudctList = listArray.object(at: i) as! NSDictionary
                            let objBrandVCModel = BrandVCModel()
                            objBrandVCModel.brandListDict(dict: dictProudctList)
                        self.brandListArr.append(objBrandVCModel)
                    }
                }
            }else{
                self.brandListArr = []
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
            completion()
        }
    }
}
//MARK:- Extension Class ----

extension BrandVC:UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- TableView DataSource Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brandViewModelObj.brandListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewBrand.dequeueReusableCell(withIdentifier: "BrandTVC") as? BrandTVC
        let brandDict =  brandViewModelObj.brandListArr[indexPath.row]
        cell?.lblTitle.text = brandDict.brandTitle
        cell?.lblDescription.text = brandDict.brandDescription
        
        DispatchQueue.main.async {
            cell?.imgVwBrand.sd_setImage(with: URL(string: brandDict.brandFile), completed: nil)
        }
        cell?.btnEdit.tag = indexPath.row
        cell?.btnEdit.addTarget(self, action: #selector(self.actionBtnEdit(_:)), for: .touchUpInside)
        cell?.btnDelete.tag = indexPath.row
        cell?.btnDelete.addTarget(self, action: #selector(self.actionBtnDelete(_:)), for: .touchUpInside)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictCategory = brandViewModelObj.brandListArr[indexPath.row]
        let brandVCObj =  self.storyboard?.instantiateViewController(withIdentifier: "ProductVC") as! ProductVC
        brandVCObj.categoryId =  categoryIdVal
        brandVCObj.brandId = dictCategory.brandId
        self.navigationController?.pushViewController(brandVCObj, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == brandViewModelObj.brandListArr.count-1 {
            if brandViewModelObj.pageNumber+1 < brandViewModelObj.totalPageCount {
                brandViewModelObj.pageNumber =  brandViewModelObj.pageNumber + 1
                brandViewModelObj.getBrandList {
                    self.tblViewBrand.reloadData()
                }
            }
        }
    }
     //MARK:- Button Actoin - Edit Brand
    @IBAction func actionBtnEdit(_ sender: UIButton) {
        print("Edit button Tapped")
        let addBrandVCObj = storyboard?.instantiateViewController(withIdentifier: "AddBrandVC") as! AddBrandVC
         addBrandVCObj.categoryID = categoryIdVal
         addBrandVCObj.btnTapped = "EditButton"
         addBrandVCObj.selectdItemDict = brandViewModelObj.brandListArr[sender.tag]
         self.navigationController?.pushViewController(addBrandVCObj, animated: true)
        //self.present(addBrandVCObj, animated: true, completion: nil)
        
    }
    //MARK:- Button Actoin - Delete Brand
    @IBAction func actionBtnDelete(_ sender: UIButton) {
        let dictCell = brandViewModelObj.brandListArr[sender.tag]
        let  selectedId = dictCell.brandId
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KDeleteBrand)?id=\(selectedId!)", params: nil, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.deletebrandsuccesfully))
                
                self.brandViewModelObj.getBrandList {
                    self.tblViewBrand.reloadData()
                }
            } else {
                if let error = JSON["error"] as? String {
                Proxy.shared.displayStatusCodeAlert(error)
                }
            }
        })
    }
}
