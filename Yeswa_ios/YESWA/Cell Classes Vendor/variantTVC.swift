//
//  variantTVC.swift
//  YESWA
//
//  Created by Ankita Thakur on 13/07/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class variantTVC: UITableViewCell ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var crossAction: UIButton!
    @IBOutlet weak var collectionVwItem: UICollectionView!
    @IBOutlet weak var collectionVwSize: UICollectionView!
    @IBOutlet weak var lblPrice: UITextField!
    @IBOutlet weak var lblColor: UILabel!
    
    @IBOutlet var lblColorHeader : UILabel!
    @IBOutlet var lblSizeHeader : UILabel!
    @IBOutlet var lblQtyHeader : UILabel!
    @IBOutlet var lblPriceHeader : UILabel!
    
    var arrData = [SizeModal]()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionVwItem.register(UINib(nibName: "VarientCVC", bundle: nil), forCellWithReuseIdentifier: "VarientCVC")
        self.collectionVwSize.register(UINib(nibName: "VarientCVC", bundle: nil), forCellWithReuseIdentifier: "VarientCVC")
        
        collectionVwItem.delegate = self
        collectionVwItem.dataSource = self
        collectionVwItem.reloadData()
        
        collectionVwSize.delegate = self
        collectionVwSize.dataSource = self
        collectionVwSize.reloadData()
        lblColorHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.color)
        lblSizeHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.size)
        lblPriceHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.price)
        lblQtyHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.quantity)
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func passArrayData(arradyDict: [SizeModal])  {
        arrData = arradyDict
        collectionVwItem.reloadData()
        collectionVwSize.reloadData()

    }
    /// MARK:- Collection View Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VarientCVC",for: indexPath as IndexPath) as! VarientCVC
        let cellDict = arrData[indexPath.row]
        if collectionView == collectionVwItem{
            
            cell.lblTitle.text = "\(cellDict.quantity)"
        }
        else{
            cell.lblTitle.text = cellDict.productVarientSizeTitle
        }
        cell.lblTitle.isUserInteractionEnabled = false
        cell.backgroundView?.layer.cornerRadius = 5.0
        cell.backgroundView?.clipsToBounds = true
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        var stringToFit = String()
        let colorDict = arrData[indexPath.row]
        if collectionView == collectionVwItem{
            stringToFit  = "\(colorDict.quantity)"
            let font = UIFont.systemFont(ofSize: 17)
            let userAttributes = [NSAttributedStringKey.font.rawValue: font, NSAttributedStringKey.foregroundColor: UIColor.black] as? [NSAttributedStringKey : Any]
            let size = stringToFit.size(withAttributes: userAttributes)
            let newSize = CGSize(width: size.width + 50 , height: 37)
            return newSize
            
        }else{
            
            stringToFit = colorDict.productVarientSizeTitle
            
            let font = UIFont.systemFont(ofSize: 17)
            let userAttributes = [NSAttributedStringKey.font.rawValue: font, NSAttributedStringKey.foregroundColor: UIColor.black] as? [NSAttributedStringKey : Any]
            let size = stringToFit.size(withAttributes: userAttributes)
            let newSize = CGSize(width: size.width + 50 , height: 37)
            return newSize
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    
}
