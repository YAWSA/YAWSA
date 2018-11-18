//
//  OrderDetailVendorViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 13/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import  UIKit

class OrderDetailVendorViewModel {
    var orderID = Int ()
     let objOrderHistoryModel = OrderHistoryModel()
    func changeOrderState(_ orderState: Int , orderId: Int,completion:@escaping() -> Void) {
        let param = [
            "state_id": orderState ,
            ] as [String:AnyObject]
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KChangeOrderState)?id=\(orderId)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                completion()
            } else {
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
        })
    }
    
    func getOrderDetails(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KGetOrderDetail)?id=\(orderID)", showIndicator: true) { (JSON) in
            
            if JSON["status"] as! Int == 200 {
                if let detailDict = JSON["detail"] as? NSDictionary {
                    self.objOrderHistoryModel.orderListDict(dict: detailDict)
                  
                }
                completion()
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
extension OrderDetailsVenderVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  orderDetailsModelViewObj.objOrderHistoryModel.orderItemArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewOrder.dequeueReusableCell(withIdentifier: "OrderDetailTVC") as! OrderDetailTVC
        let dictCell = orderDetailsModelViewObj.objOrderHistoryModel.orderItemArr[indexPath.row]
        cell.lblTitle.text =  dictCell.productObj.productTitle
        cell.lblQuantity.text = "\(dictCell.quantity!)"
        cell.lblPrice.text = "\(dictCell.amount!) \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
        
        if dictCell.productObj.imgProductArray.count != 0{
        cell.imgViewPro.sd_setImage(with: URL(string: dictCell.productObj.imgProductArray[0].productImg), placeholderImage: #imageLiteral(resourceName: "ic_product"), completed: nil)
        }else {
             cell.imgViewPro.image = #imageLiteral(resourceName: "ic_product")
        }
        
        self.lblShippingAddress.text = "\(orderDetailsModelViewObj.objOrderHistoryModel.houseNumber),\(orderDetailsModelViewObj.objOrderHistoryModel.street) ,\(orderDetailsModelViewObj.objOrderHistoryModel.state),\(orderDetailsModelViewObj.objOrderHistoryModel.country),\(orderDetailsModelViewObj.objOrderHistoryModel.zipcode)"
        
        var totalAmt = Int()
        // Calculate total amount of products
        for i in 0 ..< orderDetailsModelViewObj.objOrderHistoryModel.orderItemArr.count{
            let amount = orderDetailsModelViewObj.objOrderHistoryModel.orderItemArr[indexPath.row].amount
            if amount != ""{
                totalAmt = totalAmt + Int(amount!)!
            }
        }
        self.lblTotalPrice.text = "\(totalAmt)\(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
        self.lblTotalItemCount.text = "\(Proxy.shared.languageSelectedStringForKey(ConstantValue.items)) \(orderDetailsModelViewObj.objOrderHistoryModel.orderItemArr.count)"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
        
    }
    
}
