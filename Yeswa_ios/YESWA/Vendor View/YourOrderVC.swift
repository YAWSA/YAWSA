//
//  YourOrderVC.swift
//  YESWA
//
//  Created by Babita Chauhan on 19/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class YourOrderVC: UIViewController {
   
    //MARK:- IBOutlets
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tblViewOrder: UITableView!
    @IBOutlet weak var VwBottom: UIView!
    
    var yourOrderViewModelObj = YourOrderViewModel()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        Proxy.shared.addTabBottomForVendor(VwBottom, tabNumber: TabTitleVendor.TAB_Orders, currentViewController: self, currentStoryboard: StoryboardChnage.vendorStoryboard)
        lblHeader.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.yourorders)
          NotificationCenter.default.addObserver(self, selector: #selector(handelNotification(_:)), name: NSNotification.Name("RefershOrderList"), object: nil)

       
    }
    
    @objc func handelNotification(_ notification: Notification) {
        self.yourOrderViewModelObj.pageNumber = 0
        self.yourOrderViewModelObj.orderListArr = []
        yourOrderViewModelObj.getOrderList {
            self.tblViewOrder.reloadData()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        yourOrderViewModelObj.getOrderList {
            self.tblViewOrder.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
