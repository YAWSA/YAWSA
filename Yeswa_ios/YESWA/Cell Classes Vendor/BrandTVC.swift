//
//  TableViewCell.swift
//  YeshwaVendor
//
//  Created by Babita Chauhan on 17/03/18.
//  Copyright © 2018 Desh Raj Thakur. All rights reserved.
//

import UIKit

class BrandTVC: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var imgVwBrand: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
