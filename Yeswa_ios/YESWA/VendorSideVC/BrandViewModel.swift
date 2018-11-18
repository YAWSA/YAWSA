//
//  File.swift
//  YeshwaVendor
//
//  Created by Babita Chauhan on 17/03/18.
//  Copyright © 2018 Desh Raj Thakur. All rights reserved.
//

import UIKit


class BrandViewModel {
    
}

extension BrandVC:UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleAry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewBrand.dequeueReusableCell(withIdentifier: "BrandTVC") as? BrandTVC
        cell?.lblTitle.text = titleAry[indexPath.row]
        cell?.lblDescription.text = decriptionAry[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
