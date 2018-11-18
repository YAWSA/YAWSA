//
//  OrderDetailViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 13/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit


class OrderDetailViewModel {
    
}

extension OrderDetailVC  {
    
// MARK:- Show Products Detail Function
    func showProductDetils () {
        
      lblOrderNumber.text = "\(Proxy.shared.languageSelectedStringForKey(ConstantValue.orderNo)) - \(orderDict.orderNumber)"
      lblDeliveryAddress.text = "\(orderDict.houseNumber),\(orderDict.street) ,\(orderDict.state),\(orderDict.country),\(orderDict.zipcode)"
      lblProductName.text = productDetailDict.productObj.productTitle
      lblTotalprice.text = "\(productDetailDict.amount!) \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
      lblPaymentMethod.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.cash)
      lblDeliveryTime.text = "\(productDetailDict.DeliveryDate)"
     imgVwProduct.sd_setImage(with: URL(string: productDetailDict.productObj.imgProductArray[0].productImg), placeholderImage: #imageLiteral(resourceName: "ic_product"), completed: nil)
    }
}

