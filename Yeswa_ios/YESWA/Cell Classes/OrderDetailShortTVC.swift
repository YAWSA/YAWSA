//
//  OrderDetailShortTVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 12/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class OrderDetailShortTVC: UITableViewCell {

    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var lblQuentity: UILabel!
    @IBOutlet weak var imgVwProduct: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
