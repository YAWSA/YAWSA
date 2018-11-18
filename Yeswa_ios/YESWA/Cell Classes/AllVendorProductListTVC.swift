//
//  AllVendorProductListTVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 27/06/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class AllVendorProductListTVC: UITableViewCell {
    
    @IBOutlet weak var imgVwProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var lblDesecription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
