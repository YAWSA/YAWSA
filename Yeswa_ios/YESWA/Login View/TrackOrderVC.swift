//
//  TrackOrderVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 16/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class TrackOrderVC: UIViewController {
    //MARK:- Outlet
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tblVwOrderStatus: UITableView!
    
     var trackOrdeVwModelObj = [TrackOrderViewModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.trackOrder)
    
        //trackOrdeVwModelObj.orderListMessage {
        self.tblVwOrderStatus.reloadData()
  //  }

    }
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    @IBAction func actionCancel(_ sender: UIButton) {
         Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.mainStoryboard, identifier: "CancelOrderVC", isAnimate: true, currentViewController: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
