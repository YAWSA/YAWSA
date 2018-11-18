//
//  PaymentsViewModel.swift
//  YeshwaVendor
//
//  Created by Babita Chauhan on 19/03/18.
//  Copyright © 2018 Desh Raj Thakur. All rights reserved.
//

import UIKit
class PaymentsViewModel  {
    
    var pageNumber = 0
    var totalPageCount = Int()
    var currentLat = String ()
    var currentLong  = String ()
    
    var orderListArr = [OrderHistoryModel] ()
    func getCompleteOrderList(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KGetCompleteOrderListVendor)?page=\(pageNumber)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
//                if JSON["pageCount"] != nil  {
//                    self.totalPageCount = JSON["totalPage"] as! Int
//                }
                if self.pageNumber == 0{
                    self.orderListArr = []
                }
                if let ordrListArray = JSON["detail"] as? NSArray {
                    for i in 0 ..< ordrListArray.count{
                        let dictorderArr = ordrListArray.object(at: i) as! NSDictionary
                        let objorderModel = OrderHistoryModel()
                        objorderModel.orderListDict(dict: dictorderArr)
                        self.orderListArr.append(objorderModel)
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
    


extension PaymentsVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objPaymentsVM.orderListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewPayment.dequeueReusableCell(withIdentifier: "PaymentsTVC")  as? PaymentsTVC
        
        let orderDict = objPaymentsVM.orderListArr[indexPath.row].orderItemArr[0]
        // Calculate total amount of products
        var totalAmt = Int()
        for i in 0 ..< objPaymentsVM.orderListArr[indexPath.row].orderItemArr.count{
            let amount = objPaymentsVM.orderListArr[indexPath.row].orderItemArr[i].amount
            if amount != ""{
                totalAmt = totalAmt + Int(amount!)!
            }
        }
        cell?.lblPrice.text = " \(Proxy.shared.languageSelectedStringForKey(ConstantValue.price)): \(totalAmt)  \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
        
        cell?.lblOrderNumber.text = "\(Proxy.shared.languageSelectedStringForKey(ConstantValue.orderNo)) : \(objPaymentsVM.orderListArr[indexPath.row].orderNumber)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let orderDetailsDict = objPaymentsVM.orderListArr[indexPath.row]
        let orderDetailsVenderVCObj =  self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsVenderVC") as! OrderDetailsVenderVC
           orderDetailsVenderVCObj.stateId = orderDetailsDict.state_id
        orderDetailsVenderVCObj.orderDetailsModelViewObj.orderID = orderDetailsDict.id
        self.navigationController?.pushViewController(orderDetailsVenderVCObj, animated: true)
    }
}
