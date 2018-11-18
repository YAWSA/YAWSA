//
//  CartTVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 14/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class CartTVC: UITableViewCell {
    
    
    @IBOutlet weak var imgVwProduct: UIImageView!
    @IBOutlet weak var lblPrdouctName: UILabel!
    @IBOutlet weak var lblProductQuentity: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnOrderNow: UIButton!
    @IBOutlet weak var btnDecreasQuentityProduct: UIButton!
    @IBOutlet weak var btnIncresaeQuentityProudct: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
