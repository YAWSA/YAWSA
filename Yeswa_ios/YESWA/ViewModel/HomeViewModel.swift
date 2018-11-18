//
//  HomeViewModel.swift
//  YESWA
//  Created by Sonu Sharma on 14/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit

class HomeViewModel: NSObject {
    //MARK:- variable
    var pageNumber = 0
    var totalPageCount = Int()
    var currentLat = String ()
    var currentLong  = String ()
    var brandListArr = [BrandListModel] ()
    var imgFileProductArr = [ImgFileProductModel] ()
    var productListArr = [AddProductWithoutVarientModel]()
   var sliderModelArr =  [SliderModel]()
    func getNewProductList(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KGetLatestProdcut)?page=\(pageNumber)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                print("Latest Proudct Api : \(JSON)")
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
 //MARK:- get Brand List
    func getBrandList(_ completion:@escaping() -> Void) {
        self.pageNumber = 0
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KGetAllBrand)?page=\(pageNumber)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                
                if  let categoryListArray = JSON["list"] as? NSArray {
                    for i in 0 ..< categoryListArray.count{
                        let dictItemList = categoryListArray.object(at: i) as! NSDictionary
                        let objItemListModel = BrandListModel()
                        objItemListModel.brandListDict(dict: dictItemList)
                        self.brandListArr.append(objItemListModel)
                   }
                }
            }else{
                if let error = JSON["error"] as? String {
                }
            }
            completion()
        }
    }

  //   MARK:- get slider product List
        func getSliderImage(_ completion:@escaping() -> Void) {
            WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KGetUserSale)", showIndicator: true) { (JSON) in
                let listArray = JSON["detail"] as! NSArray
                if JSON["status"] as! Int == 200 {
                    for i in 0 ..< listArray.count{
                        let dictProudctList = listArray.object(at: i) as! NSDictionary
                        let objSliderModel = SliderModel()
                        objSliderModel.imgPrdouctDict(dict: dictProudctList)
                        self.sliderModelArr.append(objSliderModel)
                    }

                }else{
                    if let error = JSON["error"] as? String {
                    }
                }
                completion()
            }
    }
}
//MARK:- Extension Class HomeVC
extension HomeVC : UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrShopVia.count
    }
    //MARK:-  TableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeMenuTVC") as! HomeMenuTVC
        if indexPath.section == 0 {
             let brandDict =  homeViewModelObj.brandListArr
             cell.passBrandArrayData(arradyDict: brandDict)
            }
        else{
            let productDict =  homeViewModelObj.productListArr
            cell.passArrayData(arradyDict:productDict)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeHeaderTVC") as! HomeHeaderTVC
        cell.lblShopVia.text = arrShopVia[section]
        cell.contentView.backgroundColor = .white
        cell.btnNext.tag = section
        cell.btnNext.addTarget(self, action: #selector(self.actionNext(_:)), for: .touchUpInside)
        return cell
    }

    //MARK:- Action Next Button --
    @objc func actionNext(_ sender: UIButton) {
        if sender.tag == 0 {
            let itemListVCObj = self.storyboard?.instantiateViewController(withIdentifier: "ItemsListVC") as! ItemsListVC
              KAppDelegate.bottomTabOption =  Proxy.shared.languageSelectedStringForKey(ConstantValue.brands)
            self.navigationController?.pushViewController(itemListVCObj, animated: true)
           }else {
            let productListVCObj = self.storyboard?.instantiateViewController(withIdentifier: "ProuductListVCCustomer") as! ProuductListVCCustomer
            productListVCObj.isFromController = "HomeVCNewProduct"
        self.navigationController?.pushViewController(productListVCObj, animated: true)
        }
    }
}

