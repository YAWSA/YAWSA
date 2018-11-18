//
//  CancelOrderViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 16/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit

class CancelOrderViewModel: NSObject {
    
}

//MARK:- Extension Class
extension CancelOrderVC : UITableViewDataSource,UITableViewDelegate {
    
    
    //MARK:-  TableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cancelReason.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cancelOrderReasonTVC") as! cancelOrderReasonTVC
        cell.lblCancelReason.text = cancelReason[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    //MARK:- TableView Delegate Method
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       lblNotInterestedReason.text =  cancelReason[indexPath.row]
        vwCancelReason.isHidden = true
    }
}
