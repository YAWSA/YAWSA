//
//  AddVarientViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 29/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit


class AddVarientViewModel: NSObject {
    
    var titleValueColor = String()
    var titleValueSize = String ()
    var selectedTxtFldIndex = Int()
    var selectedIndex = Int()

    var comeFrom = String()
    var feedbackResponse = NSString()
    var varientDetailDict = VarientModel()
    func addDictToArray (_ colorStr: String, sizeStr:String, quantityStr:String, priceStr:String,completion:@escaping() -> Void){
        
        let dictVariant = NSMutableDictionary()
        dictVariant.setValue(-1, forKey: "color_id")
        dictVariant.setValue(colorStr, forKey: "color")
        dictVariant.setValue(priceStr, forKey: "amount")

        let sizeQuantityArr = NSMutableArray()
        let sizeQuantityDict = NSMutableDictionary()
        sizeQuantityDict.setValue(sizeStr, forKey: "size")
        sizeQuantityDict.setValue(-1, forKey: "size_id")
        sizeQuantityDict.setValue(quantityStr, forKey: "quantity")
        sizeQuantityArr.add(sizeQuantityDict)
        
        dictVariant.setValue(sizeQuantityArr, forKey: "detail")
        KAppDelegate.listVariantArr.add(dictVariant)
        completion()
    }
    
    func updateVarientApi(_ varientArr:NSMutableArray , completion:@escaping() -> Void)   {
       let cellDict = varientArr[0] as! NSMutableDictionary
        let param = [
            "ProductVariant[size_id]" :KAppDelegate.idSize,
             "ProductVariant[color_id]" :KAppDelegate.idColor,
             "ProductVariant[quantity]" :"\(cellDict["quantity"] as! String)",
             "ProductVariant[amount]" :"\(cellDict["amount"] as! String)"
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KProductUpdateVarient)\(varientDetailDict.varientID)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                KAppDelegate.listVariantArr = []
                if  let dicProductList = JSON["detail"] as? NSDictionary{
                addProductWithoutVarientObj.proudctListDict(dict: dicProductList)
                }
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.varientAddedSuccessfully))
                completion()
                
            } else {
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
        })
        
    }
    
    
    
    func uploadVarientApi(_ varientArr:NSMutableArray , completion:@escaping() -> Void)   {
        feedbackResponse = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: varientArr, options: JSONSerialization.WritingOptions.prettyPrinted)
            feedbackResponse = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)!
            
        }catch let error as NSError{
            debugPrint(error.description)
        }
        let param = [
            "ProductVariant[items]" :feedbackResponse
            ] as [String:AnyObject]
        
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KAddProductVarient)?id=\(addProductWithoutVarientObj.productId!)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                KAppDelegate.listVariantArr = []
                if  let dicProductList = JSON["detail"] as? NSDictionary{
                    addProductWithoutVarientObj.proudctListDict(dict: dicProductList)
                }
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.varientAddedSuccessfully))
                completion()
                
            } else {
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
        })
        
    }
    
}

//MARK:- Extension Class ----
extension AddVarientVC :UITableViewDelegate,UITableViewDataSource {
    //MARK:- TableView DataSource Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return KAppDelegate.listVariantArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddViriantTVC") as! AddViriantTVC

        cell.txtFieldColor.tag = indexPath.row+10
        cell.txtFieldPrice.tag = indexPath.row+40
        
        let cellDict =  KAppDelegate.listVariantArr[indexPath.row] as! NSMutableDictionary
        cell.txtFieldPrice.text  = cellDict["amount"] as? String
        cell.txtFieldColor.text = cellDict["color"] as? String
        cell.passArrayData(arradyDict: cellDict)
        if indexPath.row == 0{
        cell.crossAction.isHidden = true
        }else{
        cell.crossAction.isHidden = false
        }
        cell.crossAction.tag = indexPath.row
        
        
        cell.crossAction.addTarget(self, action: #selector(crossCellAction(_:)), for: .touchUpInside)
        cell.addColorAction.addTarget(self, action: #selector(addAction(_:)), for: .touchUpInside)
        cell.btnAddSizeValue.tag = indexPath.row
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    //MARK;- Action Sell
    @objc func crossCellAction(_ sender: UIButton)
    {
        if KAppDelegate.listVariantArr.count > 1{
            KAppDelegate.listVariantArr.removeObject(at: sender.tag)
            tblViewAddVarient.reloadData()
        }else{
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.youcantdeleteSingleVarient))
        }
    }
    //MARK:- Action TextFieldColor
    @objc func textFieldColorAction(textField: UITextField) {
        addVarientViewModelObj.selectedTxtFldIndex = textField.tag-10
        let selectCategoryVCObj = storyboard?.instantiateViewController(withIdentifier: "AddVarientSelectColorSizeVC") as! AddVarientSelectColorSizeVC
        selectCategoryVCObj.isTextField = "txtFieldColor"
        self.present(selectCategoryVCObj, animated: true, completion: nil)
         self.view.endEditing(true)
    }
        //MARK:- Action TextFieldSize
    @objc func textFieldSizeAction(textField: UITextField) {
        addVarientViewModelObj.selectedTxtFldIndex = textField.tag-20
        let selectCategoryVCObj = storyboard?.instantiateViewController(withIdentifier: "AddVarientSelectColorSizeVC") as! AddVarientSelectColorSizeVC
        selectCategoryVCObj.isTextField = "txtFieldSize"
        self.present(selectCategoryVCObj, animated: true, completion: nil)
        self.view.endEditing(false)
    }
    @objc func addAction(_ sender: Any) {
        addVarientViewModelObj.addDictToArray("", sizeStr: "", quantityStr: "", priceStr: ""){
            self.tblViewAddVarient.reloadData()
        }
        
    }
}
