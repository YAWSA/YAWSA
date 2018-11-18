//
//  SliderTableViewCell.swift
//  EZFood
//
//  Created by Sukhpreet Kaur on 03/01/17.
//  Copyright © 2017 Sukhpreet Kaur. All rights reserved.
//

import UIKit
import SDWebImage

class SliderHomeVC: UIViewController {
    //MARK:Outlets
    @IBOutlet var pageControlImg: UIPageControl!
    @IBOutlet var collectionViewSlider: UICollectionView!
    
    //MARK: Variables
    var totalPages = Int()
    var imageCounter = 1
    var slideTimer = Timer()
     var bannerArr = [ImgFileProductModel]()
    var sliderArr = [SliderModel]()
        var comeFrom = String()
    var arrAddProductWithoutVarient = AddProductWithoutVarientModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        if comeFrom ==  "Home"{
            totalPages = sliderArr.count
        }else{
           totalPages = bannerArr.count
        }
        initiateAutoscroll()
        // Initialization code
    }
    
}
extension SliderHomeVC: UIScrollViewDelegate{
    // MARK: UIScrollViewDelegate method implementation
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = collectionViewSlider.frame.width
        pageControlImg.currentPage = Int(collectionViewSlider.contentOffset.x / pageWidth)
        imageCounter = Int(collectionViewSlider.contentOffset.x / pageWidth)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        
        let currentPage = floor(scrollView.contentOffset.x / UIScreen.main.bounds.size.width);
        pageControlImg.currentPage = Int(currentPage)
    }
}
extension SliderHomeVC:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    //MARK:- collectionView delegates
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if comeFrom ==  "Home"{
            return sliderArr.count
        }else{
           return bannerArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCVC", for: indexPath) as! SliderCVC
        var   imgURL = String()
        if comeFrom ==  "Home"{
            imgURL = sliderArr[indexPath.row].productImg

        }else{
            imgURL = bannerArr[indexPath.row].productImg

        }
        if imgURL != ""
        {
            cell.imgSlider.sd_setImage( with: URL(string: (imgURL)), placeholderImage: #imageLiteral(resourceName: "ic_product"))
        }else{
            cell.imgSlider.image = #imageLiteral(resourceName: "ic_product")
        }
        
        let storyBoardVal = self.storyboard
        if storyBoardVal == StoryboardChnage.vendorStoryboard
        {
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(deleteImageAction(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return self.collectionViewSlider.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if comeFrom ==  "Home"{
        let productDetailDict = sliderArr[indexPath.row]
        if productDetailDict.productModelObj.varientMultipleSizeModelArr.count != 0 {
            let productDetailVCObj =  self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVCCustomer") as! ProductDetailVCCustomer
            productDetailVCObj.productDetailDict = productDetailDict.productModelObj
            productDetailVCObj.typeIdVal = productDetailDict.typeId
            productDetailVCObj.discountVal = productDetailDict.discount
            productDetailVCObj.getProdLimit = productDetailDict.getProductLimit
            
            self.navigationController?.pushViewController(productDetailVCObj, animated: true)
            }else {
             Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.noAvailble))
            }
        }
    }

    //MARK:- Delete Image Method
    func productImageDelete(_ imageId:Int, completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KProductImageDelete)\(imageId)", showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
            Proxy.shared.displayStatusCodeAlert( Proxy.shared.languageSelectedStringForKey(AlertValue.imageDeleted))
                completion()
            }
            else {
                Proxy.shared.displayStatusCodeAlert(JSON["error"] as? String ?? "Error")
            }
        })
    }
    @objc func deleteImageAction(_ sender:UIButton)
    {
        if bannerArr.count != 1 {
            let dict = bannerArr[sender.tag]
            productImageDelete(dict.productImgID) {
                NotificationCenter.default.post(name: NSNotification.Name("DeleteBannerImage"), object: nil)
            }
        }else{
            Proxy.shared.displayStatusCodeAlert( Proxy.shared.languageSelectedStringForKey(AlertValue.cantDelImage))
            
        }
       
    }
    //MARK: Timer Method
    @objc func autoScroll() {
        if imageCounter < bannerArr.count
        {
            let indexPath = IndexPath(row: imageCounter, section: 0)
            collectionViewSlider.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
            pageControlImg.currentPage = imageCounter
            imageCounter += 1
        } else {
            if bannerArr.count == 1 {
                
            } else {
                imageCounter = 0
                let indexPath = IndexPath(row: imageCounter, section: 0)
                collectionViewSlider.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition(), animated: true)
                pageControlImg.currentPage = imageCounter
            }
        }
    }
    //MARK:-  Auto Scroll Method
    func initiateAutoscroll() {
        self.pageControlImg.isHidden = false
        self.pageControlImg.numberOfPages =  bannerArr.count
        self.pageControlImg.currentPage = 0
        self.pageControlImg.tintColor = UIColor.white.withAlphaComponent(0.7)
        if bannerArr.count >= 1 {
            imageCounter = 1
        } else {
            imageCounter = 0
        }
        self.collectionViewSlider.delegate = self
        self.collectionViewSlider.dataSource = self
        self.collectionViewSlider.reloadData()
        
        DispatchQueue.main.async  {
            self.slideTimer.invalidate()
            self.slideTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(SliderHomeVC.autoScroll), userInfo: nil, repeats: true)
        }
    }
    
}
