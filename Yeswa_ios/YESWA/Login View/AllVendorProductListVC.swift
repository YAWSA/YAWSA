//
//  AllVendorProductListVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 27/06/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class AllVendorProductListVC: UIViewController {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tblVwProductList: UITableView!
    var objAllVendorProductListVM = AllVendorProductListVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objAllVendorProductListVM.getVendorProudctList {
            self.tblVwProductList.reloadData()
        }
    }
    //MARK:- Back Button
    @IBAction func actionBack(_ sender: UIButton) {
       Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
