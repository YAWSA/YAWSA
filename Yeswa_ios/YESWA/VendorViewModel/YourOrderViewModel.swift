//
//  YourOrderViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 19/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class YourOrderViewModel {
    
    var pageNumber = 0
    var totalPageCount = Int()
    var currentLat = String ()
    var currentLong  = String ()
    var orderListArr = [OrderHistoryModel] ()
    
    func getOrderList(_ completion:@escaping() -> Void) {
        self.pageNumber = 0
        self.orderListArr = []
        
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KGetOrderList)?page=\(pageNumber)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                if JSON["totalPage"] != nil  {
                    self.totalPageCount = JSON["totalPage"] as! Int
                }
                if self.pageNumber == 0{
                    self.orderListArr = []
                }
                        let ordersArr = JSON["detail"] as! NSArray
                        for i in 0 ..< ordersArr.count{
                            let dictorderArr = ordersArr.object(at: i) as! NSDictionary
                            let objorderModel = OrderHistoryModel()
                            objorderModel.orderListDict(dict: dictorderArr)
                            self.orderListArr.append(objorderModel)
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
extension YourOrderVC: UITableViewDataSource,UITableViewDelegate {
//MARK:- TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return  yourOrderViewModelObj.orderListArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewOrder.dequeueReusableCell(withIdentifier: "YourOrdrTVC") as! YourOrdrTVC
      
        if  yourOrderViewModelObj.orderListArr[indexPath.row].orderItemArr.count < 0{
        let orderDict = yourOrderViewModelObj.orderListArr[indexPath.row].orderItemArr[0]
        cell.lblTitle.text =  orderDict.productObj.productTitle
            if orderDict.productObj.imgProductArray.count == 0 {
                cell.imgviewProd.image = #imageLiteral(resourceName: "ic_orders")
            }else {
                cell.imgviewProd.sd_setImage(with: URL(string:  orderDict.productObj.imgProductArray[0].productImg), completed: nil)
            }
        }
        else{
             cell.imgviewProd.image = #imageLiteral(resourceName: "ic_orders")
        }
        // Calculate total amount of products
         var totalAmt = Int()
        for i in 0 ..< yourOrderViewModelObj.orderListArr[indexPath.row].orderItemArr.count{
            let amount = yourOrderViewModelObj.orderListArr[indexPath.row].orderItemArr[i].amount
            if amount != ""{
                totalAmt = totalAmt + Int(amount!)!
            }
        }
      
        cell.lblPrice.text = " \(Proxy.shared.languageSelectedStringForKey(ConstantValue.price)): \(yourOrderViewModelObj.orderListArr[indexPath.row].amount)  \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
        cell.lblOrderNumber.text = "\(Proxy.shared.languageSelectedStringForKey(ConstantValue.orderNo)) : \(yourOrderViewModelObj.orderListArr[indexPath.row].orderNumber)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    let orderDetailsDict = yourOrderViewModelObj.orderListArr[indexPath.row]
     let orderDetailsVenderVCObj =  self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsVenderVC") as! OrderDetailsVenderVC
        orderDetailsVenderVCObj.orderDetailsModelViewObj.orderID = orderDetailsDict.id
        
        orderDetailsVenderVCObj.stateId = orderDetailsDict.state_id
        
    self.navigationController?.pushViewController(orderDetailsVenderVCObj, animated: true)
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == yourOrderViewModelObj.orderListArr.count-1 {
            if yourOrderViewModelObj.pageNumber+1 < yourOrderViewModelObj.totalPageCount {
                yourOrderViewModelObj.pageNumber =  yourOrderViewModelObj.pageNumber + 1
                yourOrderViewModelObj.getOrderList {
                    self.tblViewOrder.reloadData()
                }
            }
        }
    }
}
