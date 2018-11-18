		//
//  AddVarientSelectColorSizeViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 29/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit


class AddVarientSelectColorSizeViewModel: NSObject {
    
    var pageNumber = 0
    var totalPageCount = Int()
    var currentLat = String ()
    var currentLong  = String ()
    var colorArr = [AddVarientColorModel] ()
    var sizeArr = [AddVarientSizeModel]()
    var mainArrIndex = Int()
    func getColor(_ completion:@escaping() -> Void) {
        
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
                }
            }
            completion()
        }
        
    }
    
    
    
    func getSize(_ completion:@escaping() -> Void) {
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
                }
            }
            completion()
        }
        
    }
    
}

//MARK:- Extension Class ----

extension AddVarientSelectColorSizeVC :UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- TableView DataSource Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if txtfieldCount == 1 {
            return addVarientColorSizeViewModelObj.colorArr.count
        }else {
           return addVarientColorSizeViewModelObj.sizeArr.count
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddVarientSelectColorSizeTVC") as? AddVarientSelectColorSizeTVC
        if txtfieldCount == 1 {
            let colorDict = addVarientColorSizeViewModelObj.colorArr[indexPath.row]
            cell?.lblSelectItem.text = colorDict.title
            cell?.btnCheckBox.isHidden = true
        
            
        }else {
            let colorDict = addVarientColorSizeViewModelObj.sizeArr[indexPath.row]
            cell?.lblSelectItem.text = colorDict.title
            cell?.btnCheckBox.isHidden = true
            
            
        }
        return cell!
    }
    
    func selectSizeAction(_ sender:UIButton){
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if txtfieldCount == 1 {
            if indexPath.row == addVarientColorSizeViewModelObj.colorArr.count-1 {
                if addVarientColorSizeViewModelObj.pageNumber+1 < addVarientColorSizeViewModelObj.totalPageCount {
                    addVarientColorSizeViewModelObj.pageNumber =  addVarientColorSizeViewModelObj.pageNumber + 1
                    addVarientColorSizeViewModelObj.getColor {
                        self.tableVwSelectcolorSize.reloadData()
                    }
                }
            }
        }else {
            if indexPath.row == addVarientColorSizeViewModelObj.sizeArr.count-1 {
                if addVarientColorSizeViewModelObj.pageNumber+1 < addVarientColorSizeViewModelObj.totalPageCount {
                    addVarientColorSizeViewModelObj.pageNumber =  addVarientColorSizeViewModelObj.pageNumber + 1
                    addVarientColorSizeViewModelObj.getSize {
                        self.tableVwSelectcolorSize.reloadData()
                    }
                }
            }
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if txtfieldCount == 1 {
            var isValExist = false
            let dictCategory = addVarientColorSizeViewModelObj.colorArr[indexPath.row]
            let dict = ["colorTitle": dictCategory.title,"colorId": dictCategory.Id] as [String : Any]
            for i in 0..<KAppDelegate.listVariantArr.count{
                let mainDic = KAppDelegate.listVariantArr[i] as! NSMutableDictionary
                if let colorID = mainDic.value(forKey: "color_id") as? String {
                    if Int(colorID) == dictCategory.Id{
                        isValExist = true
                        break
                    }
                }else{
                    let colorID = mainDic.value(forKey: "color_id") as! Int
                    if colorID == dictCategory.Id{
                        isValExist = true
                        break
                    }
                }
            }
            if isValExist == true{
              Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.alreadyAdded))
            }else{
                self.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: NSNotification.Name("SelectColor"), object: dict)
                })
            }
        }else {
            let dictCategory = addVarientColorSizeViewModelObj.sizeArr[indexPath.row]
            let dict = ["SizeTitle": dictCategory.title,"sizeId": dictCategory.Id] as [String : Any]
            var isValExist = false
            let mainDic = KAppDelegate.listVariantArr[addVarientColorSizeViewModelObj.mainArrIndex] as! NSMutableDictionary
            let sizeArr = mainDic.value(forKey: "detail") as! NSMutableArray
            for i in 0..<sizeArr.count{
                let sizeDic = sizeArr[i] as! NSMutableDictionary
                if let colorID = sizeDic.value(forKey: "size_id") as? String {
                    if Int(colorID) == dictCategory.Id{
                        isValExist = true
                        break
                    }
                }else{
                    let colorID = sizeDic.value(forKey: "size_id") as! Int
                    if colorID == dictCategory.Id{
                        isValExist = true
                        break
                    }
                }
            }
            
            
            if isValExist == true{
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.alreadySelectSize))
                
            }else{
                self.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: NSNotification.Name("SelectSize"), object: dict)
                })
            }
        }
    }
}

