//
//  SelectGovernentAreaVC.swift
//  YESWA
//
//  Created by Ankita Thakur on 10/05/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class SelectGovernentAreaVC: UIViewController {
    @IBOutlet weak var lblHeader: UILabel!
   
    @IBOutlet weak var tblVwSelectGovernentArea: UITableView!
    var objSelectGovernentAreaVM = SelectGovernentAreaViewmodel ()
    var isTextField = Int ()
    var isSelectGoverArea = String ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblHeader.text = isSelectGoverArea
        if isTextField == 1 {
            objSelectGovernentAreaVM.getGovernorateList {
                self.tblVwSelectGovernentArea.reloadData()
            }
        }else {
          
            objSelectGovernentAreaVM.getRegionList {
                self.tblVwSelectGovernentArea.reloadData()
            }
        }
    }
    
    
    //MARK:- Action Cross
    @IBAction func actionBtnCross(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
