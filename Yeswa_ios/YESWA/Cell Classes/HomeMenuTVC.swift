//
//  HomeMenuTVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 14/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class HomeMenuTVC: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionVwItem: UICollectionView!
    var proudcutArray = [AddProductWithoutVarientModel]()
    var brandArray = [BrandListModel]()
    var sectionCount = Int()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionVwItem.register(UINib(nibName: "HomeItemCVC", bundle: nil), forCellWithReuseIdentifier: "HomeItemCVC")
        collectionVwItem.delegate = self
        collectionVwItem.dataSource = self
        collectionVwItem.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    func passArrayData(arradyDict: [AddProductWithoutVarientModel])  {
        proudcutArray = arradyDict
        sectionCount = 1
        collectionVwItem.reloadData()
    }
    func passBrandArrayData(arradyDict: [BrandListModel])  {
        brandArray = arradyDict
        sectionCount = 0
        collectionVwItem.reloadData()
    }
    /// MARK:- Collection View Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if sectionCount == 0 {
            return self.brandArray.count
        }
        else {
            return self.proudcutArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeItemCVC",for: indexPath as IndexPath) as! HomeItemCVC
        if sectionCount == 0{
            let dictbrand = brandArray[indexPath.row]
            cell.lblTitle.text = dictbrand.title
           
            cell.imgView.sd_setImage( with: URL(string:dictbrand.brandImg), placeholderImage:#imageLiteral(resourceName: "ic_product"))
        }
        else{
            let dictCat = proudcutArray[indexPath.row]
            cell.lblTitle.text = dictCat.productTitle
            
            if dictCat.imgProductArray.count != 0
            {
                cell.imgView.contentMode = .scaleToFill
                let imgStr = dictCat.imgProductArray[0].productImg
                cell.imgView.sd_setImage(with: URL(string:  imgStr), completed: nil)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width/2.3
        let height = CGFloat(200)
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 25.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if sectionCount == 0{
              KAppDelegate.bottomTabOption =  Proxy.shared.languageSelectedStringForKey(ConstantValue.brands)
            let dictbrand = brandArray[indexPath.row]
             NotificationCenter.default.post(name: NSNotification.Name("SelectCategory"), object: dictbrand.brandId)
        } else {
             let dictCat = proudcutArray[indexPath.row]
            let productDetailDict = proudcutArray[indexPath.row]
            if   productDetailDict.varientMultipleSizeModelArr.count != 0{
                KAppDelegate.bottomTabOption =  Proxy.shared.languageSelectedStringForKey(ConstantValue.product)
                NotificationCenter.default.post(name: NSNotification.Name("SelectCategory"), object:dictCat)
            }else{
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.noAvailble))
            }

        }
    }
}
