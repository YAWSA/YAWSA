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
    @IBOutlet weak var tblViewPayment: UITableView!
    
    //MARK:- Variables
    var productAry = ["Lakeme","Loreal","Lakeme","Lakeme"]
    var priceAry = ["123","123","123","123"]
 
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
