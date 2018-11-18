//
//  CartViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 14/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit

class CartViewModel: NSObject {
    var pageNumber = 0
    var totalPageCount = Int()
    var currentLat = String ()
    var currentLong  = String ()
    var cartListArr = [CartModel] ()
    var priceVal = Int()
    func getCartListProduct(_ completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KGetCartProduct)?page=\(pageNumber)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                if JSON["totalPage"] != nil  {
                    self.totalPageCount = JSON["totalPage"] as! Int
                }
                if self.pageNumber == 0{
                    self.cartListArr = []
                }
                
                let cartProductArray = JSON["detail"] as! NSArray
                for i in 0 ..< cartProductArray.count{
                    let dictCartProudctList = cartProductArray.object(at: i) as! NSDictionary
                    let objCartModel = CartModel()
                    objCartModel.productListDict(dict: dictCartProudctList)
                    self.cartListArr.append(objCartModel)
                }
                
            }else{
                self.cartListArr = []
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
            completion()
        }
        
    }
    // MARK:- Add Brand Api Interaction
    func updateToCartApi(_ productId: Int,varientID:Int,itemQuantity:Int ,itemPrice:Int,itemID:Int ,  completion:@escaping() -> Void)   {
        
        let param = [
            "CartItem[quantity]" : itemQuantity ,
            "CartItem[amount]" : itemPrice ,
            "CartItem[product_variant_id]" :varientID,
            "CartItem[product_id] " : productId
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KUpdateCartProduct)\(itemID)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                self.cartListArr = []
                if   let cartProductArray = JSON["detail"] as? NSArray{
                    for i in 0 ..< cartProductArray.count{
                        let dictCartProudctList = cartProductArray.object(at: i) as! NSDictionary
                        let objCartModel = CartModel()
                        objCartModel.productListDict(dict: dictCartProudctList)
                        self.cartListArr.append(objCartModel)
                    }
                }
                completion()
                
            } else {
                
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
        })
        
    }
    
    
}
extension CartVC: UITableViewDataSource,UITableViewDelegate {
    //MARK:-  TableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItemListModelObj.cartListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTVC") as! CartTVC
        
        let cartItemDict = cartItemListModelObj.cartListArr[indexPath.row]
        cell.lblProductPrice.text = "\(cartItemDict.amount!) \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
        cell.lblPrdouctName.text = cartItemDict.productObj.productTitle
        cell.lblProductQuentity.text = "\(cartItemDict.quantity!)"
        
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.remove), for: .normal)
        
        cell.btnRemove.tag = cartItemDict.cartItemId
        cell.btnRemove.addTarget(self, action: #selector(removeProductAction(_:)), for: .touchUpInside)
        
        cell.btnDecreasQuentityProduct.tag = indexPath.row
        cell.btnDecreasQuentityProduct.addTarget(self, action: #selector(minusQuantityAction(_:)), for: .touchUpInside)
        cell.btnIncresaeQuentityProudct.tag = indexPath.row
        cell.btnIncresaeQuentityProudct.addTarget(self, action: #selector(addQuantityAction(_:)), for: .touchUpInside)
        if cartItemDict.productObj.imgProductArray.count != 0 {
            let imgStr = cartItemDict.productObj.imgProductArray[0].productImg
            cell.imgVwProduct.sd_setImage(with: URL(string:  imgStr), completed: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == cartItemListModelObj.cartListArr.count-1 {
            if cartItemListModelObj.pageNumber+1 < cartItemListModelObj.totalPageCount {
                cartItemListModelObj.pageNumber =  cartItemListModelObj.pageNumber + 1
                cartItemListModelObj.getCartListProduct {
                    self.tblVwItemsList.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    @objc func addQuantityAction(_ sender: UIButton) {
        let cartItemDict = cartItemListModelObj.cartListArr[sender.tag]
            let variemntQuantity = cartItemDict.productVariantModelDict.quantity
            if variemntQuantity != cartItemDict.quantity{
                let quantityIncrement:Int = cartItemDict.quantity+1
                let ammountIncrement:Int  = Int(cartItemDict.productVariantModelDict.amount)!*quantityIncrement
                cartItemListModelObj.updateToCartApi(cartItemDict.productObj.productId, varientID: cartItemDict.productVariantId, itemQuantity: quantityIncrement, itemPrice: ammountIncrement, itemID: cartItemDict.cartItemId) {
                    self.handelAmount()
                }
            } else{
      Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.nomoreitemsareavailable))
            }
     
    }
    @objc func minusQuantityAction(_ sender: UIButton) {
        let cartItemDict = cartItemListModelObj.cartListArr[sender.tag]
        if cartItemDict.quantity != 1{
            let quantityIncrement:Int = cartItemDict.quantity-1
            let ammountIncrement:Int  = Int(cartItemDict.productVariantModelDict.amount)!*quantityIncrement
            cartItemListModelObj.updateToCartApi(cartItemDict.productObj.productId, varientID: cartItemDict.productVariantId, itemQuantity: quantityIncrement, itemPrice: ammountIncrement, itemID: cartItemDict.cartItemId) {
                self.handelAmount()
            }
        }
        
    }
    //MARK:- Action Remove Product Btn
    
    @objc func removeProductAction(_ sender: UIButton) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KDeleteCartProduct)?id=\(sender.tag)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.deleteProductSuccessfully))
                self.cartItemListModelObj.priceVal = 0
                self.cartItemListModelObj.getCartListProduct {
                    self.tblVwItemsList.reloadData()
                    self.handelAmount ()
                }
            }else{
                  self.cartItemListModelObj.priceVal = 0
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
        }
    }
    // MARK:- Functoion Handle Amount
    func handelAmount()
    {
        self.cartItemListModelObj.priceVal = 0
        self.lblTotalProductQuentity.text = "\(Proxy.shared.languageSelectedStringForKey(ConstantValue.items)) \(self.cartItemListModelObj.cartListArr.count)"
        
        for i in 0 ..< self.cartItemListModelObj.cartListArr.count{
            let cartItemDict = self.cartItemListModelObj.cartListArr[i]
            cartItemListModelObj.priceVal = cartItemListModelObj.priceVal + Int(cartItemDict.amount)!
        }
        self.lblPriceDetailSubTotal.text = "\(cartItemListModelObj.priceVal) \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
        self.tblVwItemsList.reloadData()
 }
}
