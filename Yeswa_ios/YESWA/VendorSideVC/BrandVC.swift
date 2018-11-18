//
//  BrandVC.swift
//  YeshwaVendor
//
//  Created by Babita Chauhan on 17/03/18.
//  Copyright © 2018 Desh Raj Thakur. All rights reserved.
//

import UIKit

class BrandVC: UIViewController {

    @IBOutlet weak var tblViewBrand: UITableView!
   
    var brandViewModelObj =  BrandViewModel()
  
    var titleAry = ["OSCAR BENEDICT","EXAMPLE 1","EXAMPLE 2","EXAMPLE 3"]
    var decriptionAry = ["Gulf Coast Bread, fresh her..","Gulf Coast Bread, fresh her..","Gulf Coast Bread, fresh her..","Gulf Coast Bread, fresh her.."]
    
    //MARK:- Button Add New Action
    @IBAction func btnAddNewItem(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
