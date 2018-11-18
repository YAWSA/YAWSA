//
//  SelectGovernentAreaViewmodel.swift
//  YESWA
//
//  Created by Ankita Thakur on 10/05/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit
class SelectGovernentAreaViewmodel {
    var pageNumber = 0
    var totalPageCount = Int()
    var governorateArr = [SelectGovernentModel] ()
    var regionArr = [SelectAreaModel] ()
    var governorateID = Int ()
    var regionId = Int ()
    var selectedCountryId = Int()
    func getGovernorateList(_ completion:@escaping() -> Void) {
        
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KGetGovernorateList)?page=\(pageNumber)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                if JSON["pageCount"] != nil  {
                    self.totalPageCount = JSON["pageCount"] as! Int
                }
                if self.pageNumber == 0{
                    self.governorateArr = []
                }
                let governorateListArray = JSON["list"] as! NSArray
                for i in 0 ..< governorateListArray.count{
                    let dictGovernorateList = governorateListArray.object(at: i) as! NSDictionary
                    let objSelectGovernentModel = SelectGovernentModel()
                    objSelectGovernentModel.governorateDict(dict: dictGovernorateList)
                    self.governorateArr.append(objSelectGovernentModel)
                }
                
            }else{
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
            completion()
        }
        
    }
    
    //MARK:- Function GetBrandList
    func getRegionList(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KGetGovernorateRegionList)?countryId=\(selectedCountryId)&page=\(pageNumber)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                if JSON["pageCount"] != nil  {
                    self.totalPageCount = JSON["pageCount"] as! Int
                }
                if self.pageNumber == 0{
                    self.regionArr = []
                }
                let regionListArray = JSON["list"] as! NSArray
                for i in 0 ..< regionListArray.count{
                    let dictRegionList = regionListArray.object(at: i) as! NSDictionary
                    let objSelectAreaModel = SelectAreaModel()
                    objSelectAreaModel.regionDict(dict: dictRegionList)
                    self.regionArr.append(objSelectAreaModel)

                }
            }else{
                if let error = JSON["error"] as? String {
                    print(error)
                }
            }
            completion()
        }
        
    }
    
    
    
}

extension SelectGovernentAreaVC :UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- TableView DataSource Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isTextField == 1 {
            return objSelectGovernentAreaVM.governorateArr.count
        }else {
            return objSelectGovernentAreaVM.regionArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectGovernentAreaTVC") as? SelectGovernentAreaTVC
        if isTextField == 1 {
            let dictGovernorate = objSelectGovernentAreaVM.governorateArr[indexPath.row]
            cell?.lbshowGovernentArea.text = dictGovernorate.governorateTitle
            
        }else{
             let dictRegion = objSelectGovernentAreaVM.regionArr[indexPath.row]
            cell?.lbshowGovernentArea.text = dictRegion.regionTitle
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 45
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isTextField == 1 {
            if indexPath.row == objSelectGovernentAreaVM.governorateArr.count-1 {
                if objSelectGovernentAreaVM.pageNumber+1 < objSelectGovernentAreaVM.totalPageCount {
                    objSelectGovernentAreaVM.pageNumber =  objSelectGovernentAreaVM.pageNumber + 1
                    objSelectGovernentAreaVM.getGovernorateList {
                        self.tblVwSelectGovernentArea.reloadData()
                    }
                }
            }
        }else {
            if indexPath.row == objSelectGovernentAreaVM.regionArr.count-1 {
                if objSelectGovernentAreaVM.pageNumber+1 < objSelectGovernentAreaVM.totalPageCount {
                    objSelectGovernentAreaVM.pageNumber =  objSelectGovernentAreaVM.pageNumber + 1
                    objSelectGovernentAreaVM.getRegionList {
                        self.tblVwSelectGovernentArea.reloadData()
                    }
                }
            }
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isTextField == 1 {
            let dictGovernorate = objSelectGovernentAreaVM.governorateArr[indexPath.row]
            objSelectGovernentAreaVM.governorateID = dictGovernorate.governorateId
            let dict = ["title": dictGovernorate.governorateTitle, "governentId": dictGovernorate.governorateId] as [String : Any]
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: NSNotification.Name("GovernentSelect"), object: dict)
            })
        }
        else {
            let dictRegion = objSelectGovernentAreaVM.regionArr[indexPath.row]
            objSelectGovernentAreaVM.regionId = dictRegion.regionId
              let dict = ["title": dictRegion.regionTitle,"regionId": dictRegion.regionId] as [String : Any]
            self.dismiss(animated: true, completion: {
                NotificationCenter.default.post(name: NSNotification.Name("AreaSelect"), object: dict)
            })
        }
    }
}
