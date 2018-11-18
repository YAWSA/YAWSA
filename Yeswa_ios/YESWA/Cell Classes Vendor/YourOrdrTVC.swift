//
//  YourOrdrTVC.swift
//  YESWA
//
//  Created by Babita Chauhan on 19/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class YourOrdrTVC: UITableViewCell {

    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgviewProd: UIImageView!
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
