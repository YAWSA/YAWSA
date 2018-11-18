//
//  OrderDetailTVC.swift
//  YESWA
//
//  Created by Babita Chauhan on 19/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class OrderDetailTVC: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var imgViewPro: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
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
