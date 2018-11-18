//
//  OrderHistoryViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 16/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit

class OrderHistoryViewModel: NSObject {
    
    var pageNumber = 0
    var totalPageCount = Int()
    var currentLat = String ()
    var currentLong  = String ()
    var stateId = Int ()
    var orderListArr = [OrderHistoryModel] ()
    
    func getOrderList(_ completion:@escaping() -> Void) {
        
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KGetOrderList)?page=\(pageNumber)&state_id=\(stateId)", showIndicator: true) { (JSON) in 
            if JSON["status"] as! Int == 200 {
                if JSON["totalPage"] != nil  {
                    self.totalPageCount = JSON["totalPage"] as! Int
                }
                if self.pageNumber == 0{
                    self.orderListArr = []
                }
                if  let ordersArr = JSON["detail"] as? NSArray {
                    for i in 0 ..< ordersArr.count{
                        let dictorderArr = ordersArr.object(at: i) as! NSDictionary
                        let objorderModel = OrderHistoryModel()
                        objorderModel.orderListDict(dict: dictorderArr)
                        self.orderListArr.append(objorderModel)
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

//MARK:- Extension Class
  extension OrderHistoryVC : UITableViewDataSource,UITableViewDelegate {
    
    func setColor (){
        btnPanding.setTitleColor(UIColor .black, for: .normal)
        btnCompleted.setTitleColor(UIColor .lightGray , for: .normal)
        btnCancelled.setTitleColor(UIColor .lightGray , for: .normal)
    }
    
    //MARK:-  TableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  orderHistoryVwModelObj.orderListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderHistoryTVC") as! OrderHistoryTVC
        if orderHistoryVwModelObj.orderListArr[indexPath.row].orderItemArr.count != 0{
        let orderDict = orderHistoryVwModelObj.orderListArr[indexPath.row].orderItemArr[0]
        cell.lblItemName.text =  orderDict.productObj.productTitle
        var totalAmt = Int()
       
        // Calculate total amount of products
         for i in 0 ..< orderHistoryVwModelObj.orderListArr[indexPath.row].orderItemArr.count{
            let amount = orderHistoryVwModelObj.orderListArr[indexPath.row].orderItemArr[i].amount
            if amount != ""{
            totalAmt = totalAmt + Int(amount!)!
            }
        }
        if orderDict.state_id == OrderState.STATE_NEW.rawValue{
            cell.btnCancel.isHidden = false
        }else{
          cell.btnCancel.isHidden = true
        }
        cell.lblItemPrice.text = "\(Proxy.shared.languageSelectedStringForKey(ConstantValue.price)) : \(totalAmt+2) \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
        cell.lblItemNumber.text = "\(Proxy.shared.languageSelectedStringForKey(ConstantValue.orderNo)) : \(orderHistoryVwModelObj.orderListArr[indexPath.row].orderNumber)"
        if orderDict.productObj.imgProductArray.count == 0 {
           cell.imgVwItem.image = #imageLiteral(resourceName: "ic_orders")
        }else {
          cell.imgVwItem.sd_setImage(with: URL(string:  orderDict.productObj.imgProductArray[0].productImg), completed: nil)
        }
        cell.btnCancel.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.cancel), for: .normal)
        

        cell.btnCancel.tag = indexPath.row
        cell.btnCancel.addTarget(self, action: #selector(self.actionCancelOrder(_:)), for: .touchUpInside)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    //MARK:- TableView Delegate Method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let orderDetailsDict = orderHistoryVwModelObj.orderListArr[indexPath.row]
          let orderDetailShortVCObj = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailShortVC") as! OrderDetailShortVC
        orderDetailShortVCObj.orderDetailDict = orderDetailsDict
        self.navigationController?.pushViewController(orderDetailShortVCObj, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == orderHistoryVwModelObj.orderListArr.count-1 {
            if orderHistoryVwModelObj.pageNumber+1 < orderHistoryVwModelObj.totalPageCount {
                orderHistoryVwModelObj.pageNumber =  orderHistoryVwModelObj.pageNumber + 1
                orderHistoryVwModelObj.getOrderList {
                    self.tblVwOrder.reloadData()
                }
            }
        }
    }
    //MARK:- Button Action
    @objc func actionCancelOrder(_ sender: UIButton) {
          let orderDict = orderHistoryVwModelObj.orderListArr[sender.tag]
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KCancelOrder)?id=\(orderDict.id)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                self.orderHistoryVwModelObj.orderListArr=[]
                   self.orderHistoryVwModelObj.stateId = OrderState.STATE_NEW.rawValue
                self.orderHistoryVwModelObj.getOrderList({
                    self.tblVwOrder.reloadData()
                })
            }else{
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
        }
    }
}


