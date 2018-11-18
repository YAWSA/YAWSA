//
//  CategoryVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 27/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class CategoryVC: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tblViewCategoryList: UITableView!
    @IBOutlet weak var VwBottom: UIView!
    var categoryViewModelObj =  CategoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     lblHeader.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.home)
        Proxy.shared.addTabBottomForVendor(VwBottom, tabNumber: TabTitleVendor.TAB_Home, currentViewController: self, currentStoryboard: StoryboardChnage.vendorStoryboard)

    }
    override func viewWillAppear(_ animated: Bool) {
        categoryViewModelObj.getCategoryList {
            self.tblViewCategoryList.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
