//
//  ProductDetailVendorViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 07/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit
import DKImagePickerController
class ProductDetailVendorViewModel: NSObject {
    var productID = Int()
    var assets: [DKAsset]?
    var imagesArray = [UIImage]()
    func getProductDetail(_  completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KProductGet)\(productID)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                if  let dicProductList = JSON["detail"] as? NSDictionary{
                addProductWithoutVarientObj.proudctListDict(dict: dicProductList)
                }
            }else{
                if let error = JSON["error"] as? String {
                     Proxy.shared.displayStatusCodeAlert(error)
                }
            }
            completion()
        }
        
    }
    func deleteVarient(_ varientID:Int , completion:@escaping() -> Void) {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KDeleteVariant)\(varientID)", showIndicator: true) { (JSON) in
            if JSON["status"] as! Int == 200 {
                if  let dicProductList = JSON["detail"] as? NSDictionary{
                    addProductWithoutVarientObj.proudctListDict(dict: dicProductList)
                }
            }else{
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
            completion()
        }
        
    }
    
    
   
    // MARK:- AddBrand Api Interaction
    func addImageApi(_  completion:@escaping() -> Void) {
        
        let param = [String:AnyObject]()
    var paramImage = [String:UIImage]()
        for i in 0..<self.imagesArray.count {
            paramImage["File[filename][\(i)]"] =  imagesArray[i]
        }
        
        let updateUrl = "\(Apis.KServerUrl)\(Apis.KAddProductImage)\(productID)"
        WebServiceProxy.shared.uploadImage(param, parametersImage: paramImage, addImageUrl: updateUrl, showIndicator: true) { (jsonResponse) in
            if jsonResponse["status"] as! Int == 200 {
                if  let dicProductList = jsonResponse["detail"] as? NSDictionary{
                    addProductWithoutVarientObj.proudctListDict(dict: dicProductList)
                }
                completion()
                
            } else {
                if let error = jsonResponse["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
        }
        
        
    }
    
}
extension ProductDetailVCVendor:UITableViewDelegate,UITableViewDataSource {
    
    //MARK:- Show Product Details
    func showProductDetails(){
        tblVwProductVarient.reloadData()
        cnstHeightTblView.constant = CGFloat(addProductWithoutVarientObj.varientModelArray.count*220)
        if addProductWithoutVarientObj.imgProductArray.count != 0
        {
             addSlider(viewSlider, storyboard: StoryboardChnage.vendorStoryboard , arrValue: addProductWithoutVarientObj.imgProductArray)
        }
        txtFieldTitle.text = addProductWithoutVarientObj.productTitle
        txtVwDescription.text = addProductWithoutVarientObj.productDescription
        txtFieldCategory.text = addProductWithoutVarientObj.CategoryTitle
        txtFieldBrand.text = addProductWithoutVarientObj.brandTitle
       
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
    
//MARK:- TableView DataSource Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addProductWithoutVarientObj.varientModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "variantTVC") as! variantTVC
        let dict = addProductWithoutVarientObj.varientModelArray[indexPath.row]
        let brandDict = dict.sizeArr
        cell.passArrayData(arradyDict: brandDict)
        cell.lblColor.text = dict.productVarientColorTitle
        cell.lblPrice.text = " \(dict.sizeArr[0].amount)"
        cell.crossAction.tag = indexPath.row//dict.varientID

       cell.crossAction.addTarget(self, action: #selector(deleteAction(_:)), for:.touchUpInside)
        return cell
    }
    
    @objc func editAction(_ sender: UIButton)
    {
         let dict = addProductWithoutVarientObj.varientModelArray[sender.tag]
        
        let addVarientVCObj = self.storyboard?.instantiateViewController(withIdentifier: "AddVarientVC") as! AddVarientVC
        addVarientVCObj.addVarientViewModelObj.varientDetailDict = dict
        addVarientVCObj.addVarientViewModelObj.comeFrom = "Edit"
        self.navigationController?.pushViewController(addVarientVCObj, animated: true)
        
    }
    @objc func deleteAction(_ sender: UIButton)
    {
        let dict = addProductWithoutVarientObj.varientModelArray[sender.tag].sizeArr
        var varientID = Int()
        if dict.count>0{
           let varientSizeDict = dict.first
            varientID = (varientSizeDict?.varientID)!
        }
        objDetailVendorViewModel.deleteVarient(varientID){
            self.showProductDetails()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
}

