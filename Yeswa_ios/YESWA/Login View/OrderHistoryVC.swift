//
//  OrderHistoryVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 15/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class OrderHistoryVC: UIViewController {
    //MARK:- Outlet
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnPanding: UIButton!
    @IBOutlet weak var btnCompleted: UIButton!
    @IBOutlet weak var btnCancelled: UIButton!
    @IBOutlet weak var tblVwOrder: UITableView!
    @IBOutlet weak var btnDrawer: UIButton!
   
    //MARK :- Variable
    var isfromController = ""
    var orderHistoryVwModelObj = OrderHistoryViewModel()
    var selectedIndex  = Int ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.orderHistory)
        
        btnPanding.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.pending), for: .normal)
        btnCompleted.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.completed), for: .normal)
        btnCancelled.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.cancelled), for: .normal)
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
       setColor()
        orderHistoryVwModelObj.stateId = OrderState.STATE_NEW.rawValue
       orderHistoryVwModelObj.getOrderList {
            self.tblVwOrder.reloadData()
        }
    }
    
    

//  MARK:- Action Buttosn
    @IBAction func actionDrawer(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    // MARK:- Action Panding Button
    @IBAction func actionPanding(_ sender: UIButton) {
        selectedIndex =  TrackOrderColor.Panding
        btnPanding.setTitleColor(UIColor .black, for: .normal)
        btnCompleted.setTitleColor(UIColor .lightGray , for: .normal)
        btnCancelled.setTitleColor(UIColor .lightGray , for: .normal)
        
        self.orderHistoryVwModelObj.pageNumber = 0
        self.orderHistoryVwModelObj.orderListArr = []
        
        orderHistoryVwModelObj.stateId = OrderState.STATE_NEW.rawValue
        orderHistoryVwModelObj.getOrderList {
            self.tblVwOrder.reloadData()
        }
    }
    
    //MARK:- Action Completed Button
    @IBAction func actionCompleted(_ sender: UIButton) {
        selectedIndex =  TrackOrderColor.Completed
        btnCompleted.setTitleColor(UIColor .black, for: .normal)
        btnPanding.setTitleColor(UIColor .lightGray , for: .normal)
        btnCancelled.setTitleColor(UIColor .lightGray , for: .normal)
        self.orderHistoryVwModelObj.pageNumber = 0
        self.orderHistoryVwModelObj.orderListArr = []
        
        orderHistoryVwModelObj.stateId = OrderState.STATE_COMPLETED.rawValue
        orderHistoryVwModelObj.getOrderList {
            self.tblVwOrder.reloadData()
        }
        
    }
    //MARK:- Action Cancelled Button
    @IBAction func actionCancelled(_ sender: UIButton) {
       selectedIndex =  TrackOrderColor.Cancelled
        btnCancelled.setTitleColor(UIColor .black, for: .normal)
        btnCompleted.setTitleColor(UIColor .lightGray , for: .normal)
        btnPanding.setTitleColor(UIColor .lightGray , for: .normal)
        self.orderHistoryVwModelObj.pageNumber = 0
        self.orderHistoryVwModelObj.orderListArr = []
        orderHistoryVwModelObj.stateId = OrderState.STATE_CANCELLED.rawValue
        orderHistoryVwModelObj.getOrderList {
            self.tblVwOrder.reloadData()
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
