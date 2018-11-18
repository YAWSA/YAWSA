//
//  PaymentsTVC.swift
//  YeshwaVendor
//
//  Created by Babita Chauhan on 19/03/18.
//  Copyright © 2018 Desh Raj Thakur. All rights reserved.
//

import UIKit

class PaymentsTVC: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var imgViewProduct: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnComplete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
