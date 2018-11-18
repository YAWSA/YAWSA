//
//  ItemListViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 15/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit

class ItemListViewModel: NSObject {
    var pageNumber = 0
    var totalPageCount = Int()
    var currentLat = String ()
    var currentLong  = String ()
    var catListArr = [ItemListModel] ()
    var brandListArr = [BrandListModel] ()
    var selectedBrandListArr = [BrandVCModel] ()
    var selectItemType = ""
  
    func getCategoryList(_ completion:@escaping() -> Void) {
        self.pageNumber = 0
        self.catListArr = []
        
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KgetCategoryList)?page=\(pageNumber)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                let listPageArr = JSON["list"] as! NSArray
                if JSON["pageCount"] != nil  {
                    self.totalPageCount = JSON["pageCount"] as! Int
                }

                        let categoryListArray = JSON["list"] as! NSArray
                        for i in 0 ..< categoryListArray.count{
                            let dictItemList = categoryListArray.object(at: i) as! NSDictionary
                            let objItemListModel = ItemListModel()
                            objItemListModel.categoryListDict(dict: dictItemList)
                            self.catListArr.append(objItemListModel)
                }
            }else{
                if let error = JSON["error"] as? String {
                }
            }
            completion()
        }
        
    }
    
    func getAllBrandList(_ completion:@escaping() -> Void) {
        self.pageNumber = 0
        self.brandListArr = []
        
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KGetAllBrand)?page=\(pageNumber)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                let listPageArr = JSON["list"] as! NSArray
                if JSON["pageCount"] != nil  {
                    self.totalPageCount = JSON["pageCount"] as! Int
                }
                if listPageArr.count>0
                {
                    if  self.pageNumber > self.totalPageCount
                    {
                    }else
                    {
                        self.pageNumber =  self.pageNumber + 1
                        let categoryListArray = JSON["list"] as! NSArray
                        for i in 0 ..< categoryListArray.count{
                            let dictItemList = categoryListArray.object(at: i) as! NSDictionary
                            let objItemListModel = BrandListModel()
                            objItemListModel.brandListDict(dict: dictItemList)
                        self.brandListArr.append(objItemListModel)
                        }
                    }
                }
            }else{
                if let error = JSON["error"] as? String {
                }
            }
            completion()
        }
    }
    func getBrandList(categoryID: Int, _ completion:@escaping() -> Void) {
        self.pageNumber = 0
        self.brandListArr = []
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KgetBrandList)?catid=\(categoryID)&page=\(pageNumber)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                if JSON["pageCount"] != nil  {
                    self.totalPageCount = JSON["pageCount"] as! Int
                }

                 let listArray = JSON["list"] as! NSArray
                        for i in 0 ..< listArray.count{
                            let dictProudctList = listArray.object(at: i) as! NSDictionary
                            let objBrandVCModel = BrandListModel()
                            objBrandVCModel.brandListDict(dict: dictProudctList)
                            self.brandListArr.append(objBrandVCModel)
                }
            }else{
                if let error = JSON["error"] as? String {
                }
            }
            completion()
        }
    }
    
    func searchBrand(searchString: String , _ completion:@escaping() -> Void)   {
        pageNumber = 0
        let param = [
            "Brand[title]" : searchString
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KSearchBrand)?page=\(pageNumber)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                
                let listPageArr = JSON["details"] as! NSArray
                if listPageArr.count>0
                {
                    if  self.pageNumber > self.totalPageCount
                    {
                    }else{
                        self.pageNumber =  self.pageNumber + 1
                        let listArray = JSON["details"] as! NSArray
                        for i in 0 ..< listArray.count{
                            let dictProudctList = listArray.object(at: i) as! NSDictionary
                            let objBrandVCModel = BrandListModel()
                            objBrandVCModel.brandListDict(dict: dictProudctList)
                            self.brandListArr.append(objBrandVCModel)
                        }
                    }
                }
                
            } else {
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
             completion()
        })
        
    }
  
    
    
    func searchCategory(searchString: String , _ completion:@escaping() -> Void)   {
        pageNumber = 0
        let param = [
            "Category[title]" : searchString
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KSearchCategory)?page=\(pageNumber)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                
                let listPageArr = JSON["details"] as! NSArray
                
                if listPageArr.count>0
                {
                    if  self.pageNumber > self.totalPageCount
                    {
                    }else{
                        self.pageNumber =  self.pageNumber + 1
                        let categoryListArray = JSON["details"] as! NSArray
                        for i in 0 ..< categoryListArray.count{
                            let dictItemList = categoryListArray.object(at: i) as! NSDictionary
                            let objItemListModel = ItemListModel()
                            objItemListModel.categoryListDict(dict: dictItemList)
                            self.catListArr.append(objItemListModel)
                        }
                    }
                }
                
            } else {
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
            completion()
        })
        
    }
}


extension ItemsListVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    //MARK:- UITextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFieldSearch {
            if KAppDelegate.bottomTabOption == "Brand" {
                txtFieldSearch.resignFirstResponder()
                itemsListViewModelObj.brandListArr = []
                itemsListViewModelObj.searchBrand(searchString: textField.text!) {
                    self.lblTotalItemCount.text = "\(self.itemsListViewModelObj.brandListArr.count) \(Proxy.shared.languageSelectedStringForKey(ConstantValue.items))"
                    self.itemsListViewModelObj.pageNumber = 0
                    self.collectinVwItemsList.reloadData()
                }
            }else {
                txtFieldSearch.resignFirstResponder()
                itemsListViewModelObj.catListArr = []
                itemsListViewModelObj.searchCategory(searchString: textField.text!) {
                    self.lblTotalItemCount.text = "\(self.itemsListViewModelObj.catListArr.count)  \(Proxy.shared.languageSelectedStringForKey(ConstantValue.items))"
                    self.itemsListViewModelObj.pageNumber = 0
                    self.collectinVwItemsList.reloadData()
                }
            }
        }
        return true
    }
    
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if itemsListViewModelObj.selectItemType == "Category" {
            return  itemsListViewModelObj.catListArr.count
            
        } else if itemsListViewModelObj.selectItemType == "Brand" {
            return  itemsListViewModelObj.brandListArr.count
            
        }else {
            return  itemsListViewModelObj.brandListArr.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemListCVC",for: indexPath as IndexPath) as! ItemListCVC
        
        if itemsListViewModelObj.selectItemType == "Category" {
            let dict = itemsListViewModelObj.catListArr[indexPath.row]
            cell.lblCategoryName.text = dict.title
             cell.imgVwCateogy.sd_setImage( with: URL(string:dict.categoryImg), placeholderImage: #imageLiteral(resourceName: "ic_product"))
            self.lblTotalItemCount.text = "\(itemsListViewModelObj.catListArr.count) items"
            
        } else if itemsListViewModelObj.selectItemType == "Brand"{
            let dict = itemsListViewModelObj.brandListArr[indexPath.row]
            cell.lblCategoryName.text = dict.title
            cell.imgVwCateogy.sd_setImage( with: URL(string:dict.brandImg), placeholderImage: #imageLiteral(resourceName: "ic_product"))
            self.lblTotalItemCount.text = "\(itemsListViewModelObj.brandListArr.count)  \(Proxy.shared.languageSelectedStringForKey(ConstantValue.items))"
        }else {
            let dict = itemsListViewModelObj.brandListArr[indexPath.row]
            cell.lblCategoryName.text = dict.title
            cell.imgVwCateogy.sd_setImage( with: URL(string:dict.brandImg), placeholderImage: #imageLiteral(resourceName: "ic_product"))
            self.lblTotalItemCount.text = "\(itemsListViewModelObj.brandListArr.count)  \(Proxy.shared.languageSelectedStringForKey(ConstantValue.items))"
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width/2.1
        let height = CGFloat(160)
        return CGSize(width: width, height: height)
    }
    private func collectionView(_ collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
         if itemsListViewModelObj.selectItemType == "Category" {
            if indexPath.row == itemsListViewModelObj.catListArr.count-1 {
                if itemsListViewModelObj.pageNumber+1 <  itemsListViewModelObj.totalPageCount {
                    itemsListViewModelObj.pageNumber = itemsListViewModelObj.pageNumber + 1
                    itemsListViewModelObj.getCategoryList{
                        self.collectinVwItemsList.reloadData()
                    }
                }
            }
        }
        else if itemsListViewModelObj.selectItemType == "Brand"{
        if indexPath.row == itemsListViewModelObj.brandListArr.count-1 {
            if itemsListViewModelObj.pageNumber+1 <  itemsListViewModelObj.totalPageCount {
                itemsListViewModelObj.pageNumber = itemsListViewModelObj.pageNumber + 1
                itemsListViewModelObj.getBrandList(categoryID: categoryID, {
                    self.collectinVwItemsList.reloadData()
                })
                
            }
        }
    }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if itemsListViewModelObj.selectItemType == "Category" {
            btnAllProduct.isHidden = true
            let dict = itemsListViewModelObj.catListArr[indexPath.row]
            let categoryId = dict.categoryId

            itemsListViewModelObj.selectItemType = "SelectedCategory"
                itemsListViewModelObj.getBrandList(categoryID: categoryId!, {
                    self.lblTotalItemCount.text = "\(self.itemsListViewModelObj.brandListArr.count)  \(Proxy.shared.languageSelectedStringForKey(ConstantValue.items))"
                    self.collectinVwItemsList.reloadData()
                     self.btnBack.isHidden = false
                    self.btnAllProduct.isHidden = false
                     self.lblHeaderTitle.text = " \(Proxy.shared.languageSelectedStringForKey(ConstantValue.brands))"
                })
            }
            else{
            self.btnBack.isHidden = true
            let dict = itemsListViewModelObj.brandListArr[indexPath.row]
            let productListVCObj = self.storyboard?.instantiateViewController(withIdentifier: "ProuductListVCCustomer") as! ProuductListVCCustomer
            productListVCObj.brandId = dict.brandId
            self.navigationController?.pushViewController(productListVCObj, animated: true)
            }
       }
}
