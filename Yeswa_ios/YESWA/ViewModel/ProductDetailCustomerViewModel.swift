//
//  ProductDetailCustomerViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 09/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation

import UIKit

class ProductDetailCustomerViewModel: NSObject {
    
    var selectedColor = 0
    var selectedSize = 0
    var varientID = Int()
    var prdouctPriceafterSelect = Int ()
    var productQuentity = String ()
    var productPrice = String ()
    
    
    // MARK:- Add Brand Api Interaction
    func addToCartApi(_ productId: Int ,  completion:@escaping() -> Void)   {
 
        let param = [
            "CartItem[quantity]" : productQuentity ,
            "CartItem[amount]" : productPrice ,
            "CartItem[product_variant_id]" :varientID,
            "CartItem[product_id] " : productId
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KAddCartProduct)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                completion()
                
            } else {
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
        })
    }
    
    // MARK:- Add Brand Api Interaction
    func addToWishListApi(_ productId: Int ,  completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KAddToWishList)?product_id=\(productId)", showIndicator: true, completion: { (JSON) in
                if JSON["status"] as! Int == 200 {
                if let message = JSON["message"] as? String {
                Proxy.shared.displayStatusCodeAlert(message)
                }
                completion()
            }
        })
    }
}
//MARK:- Extenesion Class
extension ProductDetailVCCustomer:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    //MARK:- Show Product Details
    func showProductDetails(){
        if typeIdVal == "1" {
            lblshowDiscountStatic.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.discount)
            lblShowTotalPriceStatic.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.totalPrice)
            lblDiscount.text = "\(discountVal) \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
            
            lblTotalPrice.text = "\(Int(productDetailDict.varientMultipleSizeModelArr[0].sizeModelArr[0].amount)! - Int(discountVal)!) \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
            vwShowDiscountHeightCnst.constant = 65
            vwShowDiscount.isHidden = false
            lblShowOffer.isHidden = true
        }else if typeIdVal == "2" {
            lblShowOffer.isHidden = false
            lblShowOffer.text = "Offer: Buy \(discountVal) Get \(getProdLimit)"
            vwShowDiscount.isHidden = true
            vwShowDiscountHeightCnst.constant = 30
         }else{
            lblShowOffer.isHidden = true
            vwShowDiscountHeightCnst.constant = 0
            vwShowDiscount.isHidden = true
        }
         //Reload collectionView
      
        collectionVwColor.reloadData()
        let heightColor = self.collectionVwColor.collectionViewLayout.collectionViewContentSize.height
        self.VwColorHeightCnstrnt.constant = heightColor+30
        collectionVwSize.reloadData()
        let heightSize = self.collectionVwSize.collectionViewLayout.collectionViewContentSize.height
        self.VwColorHeightCnstrnt.constant = heightSize+30
        lblProductName.text = productDetailDict.productTitle
        txtViewDescriptions.text = productDetailDict.productDescription
        if productDetailDict.varientMultipleSizeModelArr[0].sizeModelArr.count != 0
        {
            lblProductPrice.text =  "\(productDetailDict.varientMultipleSizeModelArr[0].sizeModelArr[0].amount) \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
        }
        addSlider(vwSlider, storyboard: StoryboardChnage.mainStoryboard,arrValue:productDetailDict.imgProductArray )
    }
    
    func addSlider(_ bottomContainerView:UIView, storyboard : UIStoryboard,arrValue: [ImgFileProductModel])
        
    {
        let sliderHomeVCObj = storyboard.instantiateViewController(withIdentifier: "SliderHomeVC") as! SliderHomeVC
        sliderHomeVCObj.bannerArr = arrValue
        self.addChildViewController(sliderHomeVCObj)
        sliderHomeVCObj.view.frame = CGRect(x: 0, y: 0, width: bottomContainerView.frame.size.width, height: bottomContainerView.frame.size.height)
        bottomContainerView.addSubview(sliderHomeVCObj.view)
        sliderHomeVCObj.didMove(toParentViewController: self)
        
    }
    /// MARK:- Collection View Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         if collectionView == collectionVwColor{
        return productDetailDict.varientMultipleSizeModelArr.count
            
         }else{
            return productDetailDict.varientMultipleSizeModelArr[objDetailCustomerViewModel.selectedColor].sizeModelArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == collectionVwColor{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomerProudctDetailColorCVC",for: indexPath as IndexPath) as! CustomerProudctDetailColorCVC
            let colorDict = productDetailDict.varientMultipleSizeModelArr[indexPath.row]
            cell.lblColorName.text = colorDict.productVarientColorTitle
            if objDetailCustomerViewModel.selectedColor == indexPath.row  {
                cell.lblColorName.textColor = .white
                cell.VwColor.backgroundColor = .black
                cell.VwColor.layer.borderColor = UIColor.black.cgColor
            }else{
                cell.lblColorName.textColor = .black
                 cell.VwColor.backgroundColor = .white
                cell.VwColor.layer.borderColor = UIColor.black.cgColor
            }
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomerProductDetailSizeCVC",for: indexPath as IndexPath) as! CustomerProductDetailSizeCVC
            
            let sizeDict = productDetailDict.varientMultipleSizeModelArr[objDetailCustomerViewModel.selectedColor].sizeModelArr[indexPath.row]
            cell.lblSize.text = sizeDict.productVarientSizeTitle
            objDetailCustomerViewModel.varientID = sizeDict.varientID
            if objDetailCustomerViewModel.selectedSize == indexPath.row{
            cell.lblSize.textColor = .white
            cell.Vwsize.backgroundColor = .black
            cell.Vwsize.layer.borderColor = UIColor.black.cgColor
            }else{
                cell.lblSize.textColor = .black
                 cell.Vwsize.backgroundColor = .white
                cell.Vwsize.layer.borderColor = UIColor.black.cgColor
            }
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionVwColor{
            objDetailCustomerViewModel.selectedColor = indexPath.row
          
        }else{
            objDetailCustomerViewModel.selectedSize = indexPath.row
            let sizeDict = productDetailDict.varientMultipleSizeModelArr[objDetailCustomerViewModel.selectedColor].sizeModelArr[indexPath.row]
            lblProductPrice.text =  "\(sizeDict.amount) \(Proxy.shared.languageSelectedStringForKey(ConstantValue.loginPlease))"
            objDetailCustomerViewModel.varientID = sizeDict.varientID
            objDetailCustomerViewModel.prdouctPriceafterSelect = Int (sizeDict.amount)!
            
        }
         collectionVwColor.reloadData()
        let heightColor = self.collectionVwColor.collectionViewLayout.collectionViewContentSize.height
        self.VwColorHeightCnstrnt.constant = heightColor+30
        collectionVwSize.reloadData()
        let heightSize = self.collectionVwSize.collectionViewLayout.collectionViewContentSize.height
        self.VwColorHeightCnstrnt.constant = heightSize+30
        
    }

   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        var stringToFit = String()
        
        if collectionView == collectionVwColor{
            let colorDict = productDetailDict.varientMultipleSizeModelArr[indexPath.row]
            stringToFit  = colorDict.productVarientColorTitle
         
            let font = UIFont.systemFont(ofSize: 17)
            let userAttributes = [NSAttributedStringKey.font.rawValue: font, NSAttributedStringKey.foregroundColor: UIColor.black] as? [NSAttributedStringKey : Any]
            let size = stringToFit.size(withAttributes: userAttributes)
            let newSize = CGSize(width: size.width + 60 , height: 40)
            return newSize
            
        }else{
            
            let sizeDict = productDetailDict.varientMultipleSizeModelArr[objDetailCustomerViewModel.selectedColor].sizeModelArr[indexPath.row]
           stringToFit = sizeDict.productVarientSizeTitle
          
            let font = UIFont.systemFont(ofSize: 17)
            let userAttributes = [NSAttributedStringKey.font.rawValue: font, NSAttributedStringKey.foregroundColor: UIColor.black] as? [NSAttributedStringKey : Any]
            let size = stringToFit.size(withAttributes: userAttributes)
            let newSize = CGSize(width: size.width + 60 , height: 40)
            return newSize
        }
    }
    
    
    
}
