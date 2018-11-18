//
//  ProductDetailVCCustomer.swift
//  YESWA
//
//  Created by Sonu Sharma on 09/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class ProductDetailVCCustomer: UIViewController {

    // Outlet
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var vwSlider: UIView!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var vwShowDiscountHeightCnst: NSLayoutConstraint!
    @IBOutlet weak var lblshowDiscountStatic: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var txtViewDescriptions: UITextView!
    @IBOutlet weak var lblItemCount: UILabel!
    @IBOutlet weak var collectionVwColor: UICollectionView!
    @IBOutlet weak var collectionVwSize: UICollectionView!
    @IBOutlet weak var vwShowDiscount: UIView!
    @IBOutlet weak var btnAddWishList: UIButton!
    @IBOutlet weak var VwColorHeightCnstrnt: NSLayoutConstraint!
    @IBOutlet weak var btnAddCart: UIButton!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblShowTotalPriceStatic: UILabel!
    @IBOutlet weak var lblShowOffer: UILabel!
    var productDetailDict =  AddProductWithoutVarientModel()
    var discountVal = String ()
    var typeIdVal = String ()
    var getProdLimit = String()
    
    var objDetailCustomerViewModel = ProductDetailCustomerViewModel ()
    var productPrice = 0
    var quentityVal = 0
    var isFavourite = Int ()
    var isFromController = ""
    var isSelectedItem = String ()
    
    
    var produtValue: Int = 0 {
        didSet {
            lblItemCount.text = "\(produtValue)"
            if productDetailDict.varientMultipleSizeModelArr[0].sizeModelArr.count != 0
            {
                lblProductPrice.text =  "\(productDetailDict.varientMultipleSizeModelArr[0].sizeModelArr[0].amount) KD"
                
                if objDetailCustomerViewModel.prdouctPriceafterSelect == 0 {
                    productPrice = Int (productDetailDict.varientMultipleSizeModelArr[objDetailCustomerViewModel.selectedColor].sizeModelArr[0].amount)!
                    quentityVal = productPrice
                    if typeIdVal == "1" {
                        quentityVal = Int(productPrice) - Int(discountVal)!
                    }
                    
                }else {
                     productPrice = objDetailCustomerViewModel.prdouctPriceafterSelect
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        produtValue = 1
        //check if already favourite
        if productDetailDict.isFavourite == 1{
         self.btnAddWishList.setImage(#imageLiteral(resourceName: "ic_selected_heart"), for: .normal)
        }else{
            self.btnAddWishList.setImage(#imageLiteral(resourceName: "ic_heart"), for: .normal)
        }
        
        
        lblHeader.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.productDetails)
        btnAddToCart.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.addToCart), for: .normal)
        lblQty.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.quantity)
        lblSize.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.size)
        lblColor.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.color)
         lblDescription.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.descriptions)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.showProductDetails ()
    }
    @IBAction func ActionBtnCart(_ sender: UIButton) {
        let auth = Proxy.shared.authNil()
        if auth == "" {
            let alertController = UIAlertController(title:(Proxy.shared.languageSelectedStringForKey(ConstantValue.loginPlease)), message: (Proxy.shared.languageSelectedStringForKey(ConstantValue.sureToLogin)), preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: (Proxy.shared.languageSelectedStringForKey(ConstantValue.cancel)), style: .default) { (action:UIAlertAction!) in
            }
            alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: (Proxy.shared.languageSelectedStringForKey(ConstantValue.ok)), style: .cancel) { (action:UIAlertAction!) in
                KAppDelegate.isComeFrom = "ProductDetailCustomer"
                Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.mainStoryboard, identifier: "SignInVC", isAnimate: true, currentViewController: self)
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        }else {
           Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.mainStoryboard, identifier: "CartVC", isAnimate: true, currentViewController: self)
        }
    }
    
    // MARK:- Action Buttons Back
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    //MARK:- Action Btns Increaes/Decrease Items
    @IBAction func actionBtnDecreaseItems(_ sender: UIButton) {
        if produtValue == 1 {
        }
        else{
            produtValue -= 1
            let value = Int (productPrice) * produtValue
            lblProductPrice.text = "\(value) \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
            quentityVal = value
            // if discount is availble
            if typeIdVal == "1" {
                  let discountValue = produtValue * Int(discountVal)!
                 lblDiscount.text = "\(discountValue)  \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
                
                lblTotalPrice.text = "\(Int(value) - Int(discountValue)) \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
                quentityVal = Int(value) - Int(discountVal)!
            }
        }
    }
    
    @IBAction func actionBtnIncreaseItems(_ sender: UIButton) {
        produtValue += 1
        let value = Int (productPrice) * produtValue
        lblProductPrice.text = "\(value) \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
        quentityVal = value
         // if discount is availble
        if typeIdVal == "1" {
            let discountValue = produtValue * Int(discountVal)!
            lblDiscount.text = "\(discountValue)  \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
            
            lblTotalPrice.text = "\(Int(value) - Int(discountValue)) \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
            quentityVal = Int(value) - Int(discountValue)
      }
 
    }
    
    @IBAction func actionAddToWishList(_ sender: UIButton) {
        let auth = Proxy.shared.authNil()
        if auth == "" {
            let alertController = UIAlertController(title:(Proxy.shared.languageSelectedStringForKey(ConstantValue.loginPlease)), message: (Proxy.shared.languageSelectedStringForKey(ConstantValue.sureToLogin)), preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: (Proxy.shared.languageSelectedStringForKey(ConstantValue.cancel)), style: .default) { (action:UIAlertAction!) in
            }
            alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: (Proxy.shared.languageSelectedStringForKey(ConstantValue.ok)), style: .cancel) { (action:UIAlertAction!) in
                KAppDelegate.isComeFrom = "ProductDetailCustomer"
                Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.mainStoryboard, identifier: "SignInVC", isAnimate: true, currentViewController: self)
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        }else{
            objDetailCustomerViewModel.addToWishListApi(productDetailDict.productId){
                if self.btnAddWishList.currentImage == #imageLiteral(resourceName: "ic_heart")
                {
                    self.btnAddWishList.setImage(#imageLiteral(resourceName: "ic_selected_heart"), for: .normal)
                }else{
                    self.btnAddWishList.setImage(#imageLiteral(resourceName: "ic_heart"), for: .normal)
                }
            }
        }
        
        
    }
    //MARK:- Action Add to Cart --
    
    @IBAction func actionBtnAddCart(_ sender: UIButton) {
        let auth = Proxy.shared.authNil()
        if auth == "" {
            
            let alertController = UIAlertController(title: (Proxy.shared.languageSelectedStringForKey(ConstantValue.loginPlease)), message: (Proxy.shared.languageSelectedStringForKey(ConstantValue.wantOrder)), preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: (Proxy.shared.languageSelectedStringForKey(ConstantValue.cancel)), style: .default) { (action:UIAlertAction!) in
            }
            alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: (Proxy.shared.languageSelectedStringForKey(ConstantValue.ok)), style: .cancel) { (action:UIAlertAction!) in
                KAppDelegate.isComeFrom = "ProductDetailCustomer"
                Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.mainStoryboard, identifier: "SignInVC", isAnimate: true, currentViewController: self)
            
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        }else{
            objDetailCustomerViewModel.productQuentity = lblItemCount.text!
            objDetailCustomerViewModel.productPrice = "\(quentityVal)"
            objDetailCustomerViewModel.addToCartApi(productDetailDict.productId) {
            Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.productaddedtoyourCartSuccessfully))
            
        }
        }
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
