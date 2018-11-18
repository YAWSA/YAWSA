//
//  AddVarientVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 28/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class AddVarientVC: UIViewController,UITextFieldDelegate {
    ///MARK:- Outlet
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tblViewAddVarient: UITableView!
    @IBOutlet weak var addMoreBtn: SetCornerButton!
    @IBOutlet weak var saveBtn: SetCornerButton!
    
    var addVarientViewModelObj =  AddVarientViewModel()
    var productTitle = String ()
    var productDiscriptions = String ()
    var feedbackResponse  = NSString()
    override func viewDidLoad() {
        super.viewDidLoad()
        KAppDelegate.listVariantArr = []
        if addVarientViewModelObj.comeFrom == "Edit" {
            addMoreBtn.isHidden = true
            addVarientViewModelObj.addDictToArray(addVarientViewModelObj.varientDetailDict.productVarientColorTitle, sizeStr: addVarientViewModelObj.varientDetailDict.productVarientSizeTitle, quantityStr: "\(addVarientViewModelObj.varientDetailDict.quantity)", priceStr: "\(addVarientViewModelObj.varientDetailDict.amount)") {
                KAppDelegate.idSize = self.addVarientViewModelObj.varientDetailDict.sizeId
                KAppDelegate.idColor = self.addVarientViewModelObj.varientDetailDict.colorId
                
                self.tblViewAddVarient.reloadData()
            }
        }else{
            addVarientViewModelObj.addDictToArray("", sizeStr: "", quantityStr: "", priceStr: ""){
               
                 self.tblViewAddVarient.reloadData()
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handelSelectColorNotification(_:)), name: NSNotification.Name("SelectColor"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handelSelectSizeNotification(_:)), name: NSNotification.Name("SelectSize"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handelSizeNotification(_:)), name: NSNotification.Name("ForSize"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handelColorNotification(_:)), name: NSNotification.Name("ForColor"), object: nil)

        let nib = UINib.init(nibName: "AddViriantTVC", bundle: nil)
        self.tblViewAddVarient.register(nib, forCellReuseIdentifier: "AddViriantTVC")
        
        setUpStaticsValue()
    }
    func setUpStaticsValue() {
        
    saveBtn.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.save), for: .normal)
        
        lblHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.addProductVarient)
        
    }
    @IBAction func addMoreAction(_ sender: Any) {
        addVarientViewModelObj.addDictToArray("", sizeStr: "", quantityStr: "", priceStr: ""){
            self.tblViewAddVarient.reloadData()
        }
      
    }
    //MARK:- Handle Notification
    
    
    @objc func handelColorNotification( _ notification: Notification)  {
        let objectVal = notification.object as! Int
      
        addVarientViewModelObj.selectedTxtFldIndex = objectVal-10
            let selectCategoryVCObj = storyboard?.instantiateViewController(withIdentifier: "AddVarientSelectColorSizeVC") as! AddVarientSelectColorSizeVC
            selectCategoryVCObj.isTextField = "txtFieldColor"
            self.present(selectCategoryVCObj, animated: true, completion: nil)
            
       
   }
    @objc func handelSizeNotification( _ notification: Notification)  {
        let objectVal = notification.object as! Int
        var getsection = Int()
        getsection = objectVal/10000
        var getRow = Int()
        getRow = objectVal%10000
        print("textFieldShouldEndEditing: ",getsection,getRow)
        
            addVarientViewModelObj.selectedIndex = getRow

            addVarientViewModelObj.selectedTxtFldIndex = getsection//objectVal-20
            let selectCategoryVCObj = storyboard?.instantiateViewController(withIdentifier: "AddVarientSelectColorSizeVC") as! AddVarientSelectColorSizeVC
            selectCategoryVCObj.isTextField = "txtFieldSize"
            selectCategoryVCObj.addVarientColorSizeViewModelObj.mainArrIndex = getsection
            self.present(selectCategoryVCObj, animated: true, completion: nil)
     
    }
    
    @objc func handelSelectColorNotification( _ notification: Notification)  {
        let dict = notification.object as! NSDictionary
        addVarientViewModelObj.titleValueColor  = (dict["colorTitle"] as? String)!
        KAppDelegate.idColor = (dict["colorId"] as? Int)!
        
        let cellDict =  KAppDelegate.listVariantArr[addVarientViewModelObj.selectedTxtFldIndex] as! NSMutableDictionary
        
        let dictVariant = NSMutableDictionary()
        dictVariant.setValue(KAppDelegate.idColor, forKey: "color_id")
        dictVariant.setValue(addVarientViewModelObj.titleValueColor , forKey: "color")
        dictVariant.setValue(cellDict["amount"] as? String, forKey: "amount")
        dictVariant.setValue(cellDict["detail"] as? NSMutableArray, forKey: "detail")
        KAppDelegate.listVariantArr.replaceObject(at: addVarientViewModelObj.selectedTxtFldIndex, with: dictVariant)
        tblViewAddVarient.reloadData()
    }
    
    @objc func handelSelectSizeNotification( _ notification: Notification)  {
         let dict = notification.object as! NSDictionary
        addVarientViewModelObj.titleValueSize  = (dict["SizeTitle"] as? String)!
        KAppDelegate.idSize = (dict["sizeId"] as? Int)!
        
        let cellDict =  KAppDelegate.listVariantArr[addVarientViewModelObj.selectedTxtFldIndex] as! NSMutableDictionary
        let sizeQuantityArr = cellDict["detail"] as! NSMutableArray
        
        let dictVariant = NSMutableDictionary()
        dictVariant.setValue(cellDict["color_id"] as? Int, forKey: "color_id")
        dictVariant.setValue(cellDict["color"] as? String, forKey: "color")
        dictVariant.setValue(cellDict["amount"] as? String, forKey: "amount")

      
        let sizeArrDict = sizeQuantityArr.object(at: addVarientViewModelObj.selectedIndex) as! NSMutableDictionary
        
        let sizeQuantityDict = NSMutableDictionary()
        sizeQuantityDict.setValue(addVarientViewModelObj.titleValueSize, forKey: "size")
        sizeQuantityDict.setValue(KAppDelegate.idSize, forKey: "size_id")
        sizeQuantityDict.setValue(sizeArrDict["quantity"], forKey: "quantity")
        sizeQuantityArr.replaceObject(at: addVarientViewModelObj.selectedIndex, with: sizeQuantityDict)
        dictVariant.setValue(sizeQuantityArr, forKey: "detail")

        
        KAppDelegate.listVariantArr.replaceObject(at: addVarientViewModelObj.selectedTxtFldIndex, with: dictVariant)
        
        
        
        tblViewAddVarient.reloadData()
      
    }
    func replaceVarient()
    {
        
    }
    
    //MARK:- Action Save
    
    @IBAction func actionSave(_ sender: UIButton) {
        if KAppDelegate.listVariantArr.count != 0
        {
            let varientArr = NSMutableArray()
            for i in 0..<KAppDelegate.listVariantArr.count{
                
                let cellDict =  KAppDelegate.listVariantArr[i] as! NSMutableDictionary
                
                let dictVariant = NSMutableDictionary()
                dictVariant.setValue(cellDict["color_id"] as? Int, forKey: "color_id")
                dictVariant.setValue(cellDict["amount"] as? String, forKey: "amount")
                let sizeQuantityArray =  cellDict.value(forKey: "detail") as! NSMutableArray
                
                let detailArr = NSMutableArray()
                for j in 0..<sizeQuantityArray.count{
                    let cellDict =  sizeQuantityArray[j] as! NSMutableDictionary
                    
                    let dictVariant = NSMutableDictionary()
                    dictVariant.setValue(cellDict["quantity"] as? String, forKey: "quantity")
                    dictVariant.setValue(cellDict["size_id"] as? Int, forKey: "size_id")
                    detailArr.add(dictVariant)
                }
                dictVariant.setValue(detailArr, forKey: "detail")
                
                varientArr.add(dictVariant)
                
                
            }
            if addVarientViewModelObj.comeFrom == "Edit" {
                
                addVarientViewModelObj.updateVarientApi(varientArr){
                    Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
                }
                
            }else{
       
                addVarientViewModelObj.uploadVarientApi(varientArr, completion: {
                    if self.addVarientViewModelObj.comeFrom == "Detail"{
                        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
                    }else{
                        Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.vendorStoryboard, identifier: "CategoryVC", isAnimate: true, currentViewController: self)
                    }
                })
       
            }
        }else{
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.fillField))
        
        }
    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
