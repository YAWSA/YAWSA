//
//  PaymentsViewModel.swift
//  YeshwaVendor
//
//  Created by Babita Chauhan on 19/03/18.
//  Copyright © 2018 Desh Raj Thakur. All rights reserved.
//

import UIKit
class PaymentsViewModel  {
    
}

extension PaymentsVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return productAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewPayment.dequeueReusableCell(withIdentifier: "PaymentsTVC")  as? PaymentsTVC
        cell?.lblTitle.text = productAry[indexPath.row]
        cell?.lblPrice.text = priceAry[indexPath.row]
        return cell!
    }
    
    
}
