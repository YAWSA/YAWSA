//  SelectCategoryBrandVC.swift
//  YESWA
//  Created by Sonu Sharma on 28/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.

import UIKit

class SelectCategoryBrandVC: UIViewController  {
   
    @IBOutlet weak var tblVwCategoryBrand: UITableView!
    @IBOutlet weak var lblSelectField: UILabel!
    
    
    var objSelectCategoryBrndViewModel =  SelectCategoryViewModel()
    var isTextField = Int ()
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    //MARK:- Action 
    @IBAction func actionCross(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
