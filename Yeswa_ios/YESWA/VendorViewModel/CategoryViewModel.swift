//
//  CategoryViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 27/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher
class CategoryViewModel {
    var pageNumber = 0
    var totalPageCount = Int()
    var currentLat = String ()
    var currentLong  = String ()
    var catListArr = [CategoryVCModel] ()
    
    func getCategoryList(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KgetCategoryList)?page=\(pageNumber)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                if JSON["pageCount"] != nil  {
                    self.totalPageCount = JSON["pageCount"] as! Int
                }
                if self.pageNumber == 0{
                    self.catListArr = []
                }
                if let categoryListArray = JSON["list"] as? NSArray {
                    for i in 0 ..< categoryListArray.count{
                        let dictProudctList = categoryListArray.object(at: i) as! NSDictionary
                        let objCategoryVCModel = CategoryVCModel()
                        objCategoryVCModel.categoryListDict(dict: dictProudctList)
                        self.catListArr.append(objCategoryVCModel)
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

extension CategoryVC :UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- TableView DataSource Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryViewModelObj.catListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTVC") as! CategoryTVC
        let dictCategory = categoryViewModelObj.catListArr[indexPath.row]
        cell.lblDescription.text = dictCategory.title
        cell.imgVwCategory.sd_setImage(with: URL(string:dictCategory.categoryImg), completed: nil)
     
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dictCategory = categoryViewModelObj.catListArr[indexPath.row]
        let brandVCObj =  self.storyboard?.instantiateViewController(withIdentifier: "BrandVC") as! BrandVC
        brandVCObj.categoryIdVal = dictCategory.categoryId
        self.navigationController?.pushViewController(brandVCObj, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == categoryViewModelObj.catListArr.count-1 {
            if categoryViewModelObj.pageNumber+1 < categoryViewModelObj.totalPageCount {
                categoryViewModelObj.pageNumber =  categoryViewModelObj.pageNumber + 1
                categoryViewModelObj.getCategoryList {
                    self.tblViewCategoryList.reloadData()
                }
            }
        }
    }
}
