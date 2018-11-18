//
//  CancelOrderVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 16/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class CancelOrderVC: UIViewController {
    //MARK:- Outlet
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblNotInterestedReason: UILabel!
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var vwCancelReason: UIView!
    @IBOutlet weak var tblVwCancelReason: UITableView!
    @IBOutlet weak var txtViewComment: UITextView!
    // var
    var cancelReason = ["Slow Service","High Cost","Mood Change","Not happy with this","Not look like good "]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vwCancelReason.isHidden = true
        self.tblVwCancelReason.reloadData()

    }
    //MARK:- Action Back
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    //MARK:- Action drop Down
    @IBAction func actionDropDown(_ sender: UIButton) {
          vwCancelReason.isHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
