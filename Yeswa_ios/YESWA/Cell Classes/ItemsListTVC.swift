//
//  ItemsListTVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 15/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class ItemsListTVC: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionVwItemsList: UICollectionView!
    var arrCatList =  [ItemListModel] ()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionVwItemsList.register(UINib(nibName: "ItemListCVC", bundle: nil), forCellWithReuseIdentifier: "ItemListCVC")
        collectionVwItemsList.delegate = self
        collectionVwItemsList.dataSource = self
        collectionVwItemsList.reloadData()
        // Initialization code
    }
    
    /// MARK:- Collection View Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCatList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemListCVC",for: indexPath as IndexPath) as? ItemListCVC
        cell?.lblCategoryName.text = arrCatList[indexPath.row].title
        return cell!
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.size.width/3
        let height = CGFloat(150)
        return CGSize(width: width, height: height)
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
//        return UIEdgeInsetsMake(0, 0, 0, 0)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
//        return 10.0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
//        return 10.0
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
