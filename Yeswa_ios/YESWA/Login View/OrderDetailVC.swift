//
//  OrderDetailVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 17/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class OrderDetailVC: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var imgVwProduct: UIImageView!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblPaymentMethod: UILabel!
    @IBOutlet weak var lblTotalprice: UILabel!
    @IBOutlet weak var lblDeliveryTime: UILabel!
    @IBOutlet weak var lblDeliveryAddress: UILabel!
    @IBOutlet weak var lblAddressHeader: UILabel!
    @IBOutlet weak var lblTimerHeader: UILabel!
    @IBOutlet weak var lblPaymentHeader: UILabel!
    @IBOutlet weak var lblTotalHeader: UILabel!
    //MARK:- Variable
    var productDetailDict = CartModel ()
    var orderDict = OrderHistoryModel ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblHeader.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.orderDetails)
         lblAddressHeader.text =  "\(Proxy.shared.languageSelectedStringForKey(ConstantValue.deliveryAddress)):"
         lblPaymentHeader.text =  "\(Proxy.shared.languageSelectedStringForKey(ConstantValue.paymentMethod)):"
         lblTotalHeader.text =  "\(Proxy.shared.languageSelectedStringForKey(ConstantValue.totalprice)):"
        
    }
    //MARK:- ViewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        showProductDetils()
    }
    
    //MARK:- action Back
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
