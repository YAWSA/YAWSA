//
//  AddProductWithoutVarientModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 03/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
var addProductWithoutVarientObj = AddProductWithoutVarientModel()
class AddProductWithoutVarientModel: NSObject {
    
    //Product Values
    var productId,prouductStateId,isFavourite :Int!
    var productTitle,productDescription :String!
    
    var imgProductArray = [ImgFileProductModel] ()
    var varientModelArray = [VarientModel]()
    var varientMultipleSizeModelArr = [VarientMultipleSizeModel]()
    
  
    
    // Brand Values
    var brandTitle = String ()
    
    // Categories values
    var CategoryTitle = String ()
    
    
    func proudctListDict(dict: NSDictionary) {
        if let prodDict = dict["product"] as? NSDictionary {
            handelProductDict(dict: prodDict)
        }else{
            handelProductDict(dict: dict)
        }
        
        
    }
    
    
    func handelProductDict(dict: NSDictionary)  {
        isFavourite = dict["is_favourite"] as? Int ?? 0
        productTitle = dict["title"] as? String ?? ""
        
        let stringDescrption = dict["description"] as? String ?? ""
        productDescription = stringDescrption.htmlToString
        productId = dict["id"] as? Int ?? 0
        prouductStateId = dict["state_id"] as? Int ?? 0
        
        if let brandList = dict["Brand"] as? NSDictionary {
            brandTitle = brandList["title"] as? String ?? ""
        }
        if let CategoryList = dict["Category"] as? NSDictionary {
            CategoryTitle = CategoryList["title"] as? String ?? ""
        }
        
        imgProductArray = []
        if let cartList = dict["file_list"] as? NSArray
        {
            for i in 0..<cartList.count{
                let dictImgProduct = cartList.object(at: i) as! NSDictionary
                let imgFileProductObjct = ImgFileProductModel()
                imgFileProductObjct.imgPrdouctDict(dict: dictImgProduct)
                imgProductArray.append(imgFileProductObjct)
            }
        }
       
        
        varientModelArray = []
        if let productVariantsArr = dict["productVariants"] as? NSArray  //productVariants
        {
            for i in 0..<productVariantsArr.count{
                let dictImgProduct = productVariantsArr.object(at: i) as! NSDictionary
                let varientModelObj = VarientModel()
                varientModelObj.varientDict(dict: dictImgProduct)
                varientModelArray.append(varientModelObj)
            }
        } else if let productVariantsArr = dict["ProductVariants"] as? NSArray
        {
            for i in 0..<productVariantsArr.count{
                let dictImgProduct = productVariantsArr.object(at: i) as! NSDictionary
                let varientModelObj = VarientMultipleSizeModel()
                varientModelObj.varientDict(dict: dictImgProduct)
                varientMultipleSizeModelArr.append(varientModelObj)
            }
        }
    }
 }



class VarientMultipleSizeModel : NSObject {
    var productVarientColorTitle = String ()
    var colorId = Int ()
   var  sizeModelArr = [SizeModel]()
    func varientDict (dict: NSDictionary){
       
        colorId = dict["color_id"] as? Int ?? 0
        productVarientColorTitle = dict["color_title"] as? String ?? ""
        if let sizeDetailArr = dict["sizeDetail"] as? NSArray
        {
            for i in 0..<sizeDetailArr.count{
                let dictsSizeDetail = sizeDetailArr.object(at: i) as! NSDictionary
                let sizeModelObj = SizeModel()
                sizeModelObj.sizeDict(dict: dictsSizeDetail)
                sizeModelArr.append(sizeModelObj)
            }
        }
    }
}
class SizeModel : NSObject {
    var varientID = Int ()
    var quantity = Int ()
    var amount = String ()
    var productVarientSizeTitle = String ()
    var sizeId = Int ()
    func sizeDict (dict: NSDictionary){
        varientID = dict["id"] as? Int ?? 0
        quantity = dict["quantity"] as? Int ?? 0
        sizeId = dict["size_id"] as? Int ?? 0
        amount = dict["amount"] as? String ??  ""
        productVarientSizeTitle = dict["size_title"] as? String ?? ""
    }
}


class VarientModel : NSObject {
    var varientID = Int ()
    var quantity = Int ()
    var amount = String ()
    var productVarientColorTitle = String ()
    var productVarientSizeTitle = String ()
     var colorId = Int ()
     var sizeId = Int ()
    var sizeArr = [SizeModal]()
    func varientDict (dict: NSDictionary){
        varientID = dict["product_id"] as? Int ?? 0 //id
        quantity = dict["quantity"] as? Int ?? 0
        colorId = dict["color_id"] as? Int ?? 0
        
        if let priceVal = dict["amount"] as? Int
        {
            amount = "\(priceVal)"
        }else if let priceVal = dict["amount"] as? String
        {
            amount = priceVal
        }
        else if let priceVal = dict["amount"] as? Float
        {
            amount = "\(priceVal)"
        }
        else if let priceVal = dict["amount"] as? Double
        {
            amount = "\(priceVal)"
        }
        if let quantityVal = dict["amount"] as? Int
        {
            amount = "\(quantityVal)"
        }
        productVarientColorTitle = dict["color_title"] as? String ?? ""
        productVarientSizeTitle = dict["size_title"] as? String ?? ""
        if let productVariantsArr = dict["sizeDetail"] as? NSArray {
        for i in 0..<productVariantsArr.count{
                let dictImgProduct = productVariantsArr.object(at: i) as! NSDictionary
                let sizeObj = SizeModal()
                sizeObj.imgPrdouctDict(dict: dictImgProduct)
                sizeArr.append(sizeObj)
            }
        }
    }
}
class SizeModal : NSObject {
    var amount = String ()
    var colorId = Int ()
    var varientID = Int ()
    var quantity = Int ()
    var productVarientColorTitle = String ()
    var productVarientSizeTitle = String ()
    var proDes = String ()
    var sizeId = Int ()
    
    func imgPrdouctDict (dict: NSDictionary){
        varientID = dict["id"] as? Int ?? 0
        quantity = dict["quantity"] as? Int ?? 0
        colorId = dict["color_id"] as? Int ?? 0
        sizeId = dict["size_id"] as? Int ?? 0
        amount = dict["amount"] as? String ??  ""
        productVarientColorTitle = dict["color_title"] as? String ?? ""
        productVarientSizeTitle = dict["size_title"] as? String ?? ""
    }
}

class ImgFileProductModel : NSObject {
  
    var productImg = String ()
    var productImgID = Int ()
    
    func imgPrdouctDict (dict: NSDictionary){
       
        
        productImg = dict["image_file"] as? String ?? ""
        productImgID = dict["id"] as? Int ?? 0
    }
}

