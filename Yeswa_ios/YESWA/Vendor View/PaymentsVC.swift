//
//  PaymentsVC.swift
//  YeshwaVendor
//
//  Created by Babita Chauhan on 19/03/18.
//  Copyright © 2018 Desh Raj Thakur. All rights reserved.
//

import UIKit

class PaymentsVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tblViewPayment: UITableView!
    @IBOutlet weak var VwBottom: UIView!
    @IBOutlet weak var lblOrderHistory: UILabel!
    var objPaymentsVM  =  PaymentsViewModel()
    
    
    //MARK:- Variables
    override func viewDidLoad() {
        super.viewDidLoad()
        
        objPaymentsVM.getCompleteOrderList{
            self.tblViewPayment.reloadData()
            }
        
        Proxy.shared.addTabBottomForVendor(VwBottom, tabNumber: TabTitleVendor.TAB_Payment, currentViewController: self, currentStoryboard: StoryboardChnage.vendorStoryboard)
        lblHeader.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.PaymentHeader)
        lblOrderHistory.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.orderHistory)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
