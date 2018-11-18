//
//  SelectColorSizeBrandVM.swift
//  YESWA
//
//  Created by Sonu Sharma on 09/07/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit


class SelectColorSizeBrandVM: NSObject {
    
    var pageNumber = 0
    var totalPageCount = Int()
    var currentLat = String ()
    var currentLong  = String ()
    var colorArr = [AddVarientColorModel] ()
    var sizeArr = [AddVarientSizeModel]()
    var brandListArr = [BrandListModel] ()
    var selectedID = NSMutableArray()
    func getColorList(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KGetColor)?page=\(pageNumber)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                if JSON["pageCount"] != nil  {
                    self.totalPageCount = JSON["pageCount"] as! Int
                }
                if self.pageNumber == 0{
                    self.colorArr = []
                }
                if  let colorListArray = JSON["list"] as? NSArray {
                    for i in 0 ..< colorListArray.count{
                        let dictColorList = colorListArray.object(at: i) as! NSDictionary
                        let objAddVarientVCModel = AddVarientColorModel()
                        objAddVarientVCModel.colorListDict(dict: dictColorList)
                        self.colorArr.append(objAddVarientVCModel)
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
    
    func getSizeList(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KGetSize)?page=\(pageNumber)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                if JSON["pageCount"] != nil  {
                    self.totalPageCount = JSON["pageCount"] as! Int
                }
                if self.pageNumber == 0{
                    self.sizeArr = []
                }
                
                if let categoryListArray = JSON["list"] as? NSArray {
                    for i in 0 ..< categoryListArray.count{
                        let dictsize = categoryListArray.object(at: i) as! NSDictionary
                        let objAddVarientSizeVCModel = AddVarientSizeModel()
                        objAddVarientSizeVCModel.sizeListDict(dict: dictsize)
                        self.sizeArr.append(objAddVarientSizeVCModel)
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
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
            completion()
        }
    }
}

extension SelectFilterColorSizeBrand : UITableViewDataSource,UITableViewDelegate {
    
   
    //MARK:-  TableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch headerTitleVal {
        case 0:
          return objSlectFiltrColrSizeBrndVM.sizeArr.count
        case 1:
              return objSlectFiltrColrSizeBrndVM.colorArr.count
        case 2:
             return objSlectFiltrColrSizeBrndVM.brandListArr.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTVCColorSizeBrand") as! FilterTVCColorSizeBrand
        
        switch headerTitleVal {
        case 0:
           let dictSize = objSlectFiltrColrSizeBrndVM.sizeArr[indexPath.row]
            cell.lblTitle.text = dictSize.title
            cell.btnCheck.tag = dictSize.Id
           cell.btnCheck.addTarget(self, action: #selector(checkAction(_:)), for: .touchUpInside)
           if objSlectFiltrColrSizeBrndVM.selectedID.contains(dictSize.Id){
            cell.btnCheck.setImage(#imageLiteral(resourceName: "ic_selected_box"), for: .normal)
           }else{
            cell.btnCheck.setImage(#imageLiteral(resourceName: "ic_box"), for: .normal)
            }
        case 1:
            let dictColor = objSlectFiltrColrSizeBrndVM.colorArr[indexPath.row]
            cell.lblTitle.text = dictColor.title
            cell.btnCheck.tag =  dictColor.Id
            cell.btnCheck.addTarget(self, action: #selector(self.checkAction(_:)), for: .touchUpInside)
            if objSlectFiltrColrSizeBrndVM.selectedID.contains(dictColor.Id){
                cell.btnCheck.setImage(#imageLiteral(resourceName: "ic_selected_box"), for: .normal)
            }else{
                cell.btnCheck.setImage(#imageLiteral(resourceName: "ic_box"), for: .normal)
            }
        case 2:
           let dictBrand = objSlectFiltrColrSizeBrndVM.brandListArr[indexPath.row]
             cell.lblTitle.text = dictBrand.title
           cell.btnCheck.tag = dictBrand.brandId
              cell.btnCheck.addTarget(self, action: #selector(checkAction(_:)), for: .touchUpInside)
           if objSlectFiltrColrSizeBrndVM.selectedID.contains( dictBrand.brandId){
            cell.btnCheck.setImage(#imageLiteral(resourceName: "ic_selected_box"), for: .normal)
           }else{
            cell.btnCheck.setImage(#imageLiteral(resourceName: "ic_box"), for: .normal)
            }

        default:
            return cell
        }
       
        return cell
  }
    @objc func checkAction(_ sender: UIButton) {
        if objSlectFiltrColrSizeBrndVM.selectedID.contains(sender.tag){
            objSlectFiltrColrSizeBrndVM.selectedID.remove(sender.tag)
        }else{
            objSlectFiltrColrSizeBrndVM.selectedID.add(sender.tag)
        }
        tblVwColorSizeBrand.reloadData()
    }
    
}
    
    









