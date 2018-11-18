//
//  TrackOrderViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 16/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit

class TrackOrderViewModel: NSObject {
    
}

//MARK:- Extension Class
extension TrackOrderVC : UITableViewDataSource,UITableViewDelegate {
    
    
    //MARK:-  TableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackOrderTVC") as! TrackOrderTVC
        cell.lblOrderStatus.text = "Processed"
        cell.lblshowCurrentOrderStatus.text = "in process"
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    //MARK:- TableView Delegate Method
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
