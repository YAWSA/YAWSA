//
//  OrderDetailShortVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 12/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class OrderDetailShortVC: UIViewController{
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblProductCount: UILabel!
    @IBOutlet weak var tblVwOrderDetail: UITableView!
    @IBOutlet weak var lblSubTotalHeader: UILabel!
    @IBOutlet weak var lblShipingCharge: UILabel!
    @IBOutlet weak var lblTotalPiceHeader: UILabel!
    var objOrderDetailShortViewModel = OrderDetailShortViewModel ()

    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    
    var orderDetailDict = OrderHistoryModel ()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblHeader.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.orderDetails)
        lblSubTotalHeader.text = "\(Proxy.shared.languageSelectedStringForKey(ConstantValue.subTotal)):"
        lblTotalPiceHeader.text = "\(Proxy.shared.languageSelectedStringForKey(ConstantValue.totalprice)):"
        lblShipingCharge.text  =  "\(Proxy.shared.languageSelectedStringForKey(ConstantValue.shipingCharge)):"
       
    }
    override func viewWillAppear(_ animated: Bool) {
        var totalAmt = Int()
        
        // Calculate total amount of products
        for i in 0 ..< orderDetailDict.orderItemArr.count{
            let amount = orderDetailDict.orderItemArr[i].amount
            if amount != ""{
                totalAmt = totalAmt + Int(amount!)!
            }
        }
        self.lblSubTotal.text = " \(totalAmt) \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
        self.lblTotal.text = "\(totalAmt+2) \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
        tblVwOrderDetail.reloadData()
    }
    
// MARK:- Action Back ---
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    

}
