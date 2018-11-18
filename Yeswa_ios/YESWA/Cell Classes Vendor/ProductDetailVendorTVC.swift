//
//  ProductDetailVendorTVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 07/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class ProductDetailVendorTVC: UITableViewCell {

    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var txtFieldColor: UITextField!
    @IBOutlet weak var txtFieldSize: UITextField!
    @IBOutlet weak var txtFieldQuentity: UITextField!
    @IBOutlet weak var txtFieldPrice: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
