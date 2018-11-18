//
//  OrderDetailShortViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 12/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit

class OrderDetailShortViewModel: NSObject {
    
    
}
extension OrderDetailShortVC:UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- TableView DataSource Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  orderDetailDict.orderItemArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailShortTVC") as! OrderDetailShortTVC
        
        let dictCell = orderDetailDict.orderItemArr[indexPath.row]
        cell.productName.text =  dictCell.productObj.productTitle
        cell.lblQuentity.text = "\(dictCell.quantity!)"
        cell.productPrice.text = "\(dictCell.amount!) \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
        if dictCell.productObj.imgProductArray.count == 0 {
            cell.imgVwProduct.image = #imageLiteral(resourceName: "ic_product")
        }else{
            cell.imgVwProduct.sd_setImage(with: URL(string: dictCell.productObj.imgProductArray[0].productImg), placeholderImage: #imageLiteral(resourceName: "ic_product"), completed: nil)
        }
        
        self.lblProductCount.text = "\(Proxy.shared.languageSelectedStringForKey(ConstantValue.items))\(orderDetailDict.orderItemArr.count)"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
//MARK:- TableView Did Select--
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderDetailShortVCObj = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailVC") as! OrderDetailVC
         let dictCell = orderDetailDict.orderItemArr[indexPath.row]
        orderDetailShortVCObj.productDetailDict = dictCell
        orderDetailShortVCObj.orderDict = orderDetailDict
    self.navigationController?.pushViewController(orderDetailShortVCObj, animated: true)
    }
}


