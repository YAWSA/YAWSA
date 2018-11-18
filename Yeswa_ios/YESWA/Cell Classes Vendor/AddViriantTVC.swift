//
//  AddViriantTVC.swift
//  YESWA
//
//  Created by Ankita Thakur on 16/07/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
class AddViriantTVC: UITableViewCell, UITextFieldDelegate  ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    @IBOutlet weak var crossAction: UIButton!
    @IBOutlet weak var addColorAction: UIButton!
    @IBOutlet weak var btnAddSizeValue: UIButton!

    @IBOutlet var lblColor : UILabel!
    @IBOutlet var lblSize : UILabel!
    @IBOutlet var lblQty : UILabel!
    @IBOutlet var lblPrice : UILabel!
    
    @IBOutlet weak var txtFieldColor: UITextField!
    @IBOutlet weak var txtFieldPrice: UITextField!
    @IBOutlet weak var collectionVwItem: UICollectionView!
    @IBOutlet weak var collectionVwSize: UICollectionView!
     var arrData = NSMutableArray()
    var indexValue = Int()
    var sizeArrCount = 1
    var quantityArrCount = 1

    override func awakeFromNib() {
        super.awakeFromNib()
        txtFieldColor.delegate = self
        txtFieldPrice.delegate = self
       
        self.collectionVwItem.register(UINib(nibName: "VarientCVC", bundle: nil), forCellWithReuseIdentifier: "VarientCVC")
        self.collectionVwSize.register(UINib(nibName: "VarientSizeCVC", bundle: nil), forCellWithReuseIdentifier: "VarientSizeCVC")
        collectionVwItem.tag = 2
        collectionVwSize.tag = 3
        collectionVwItem.delegate = self
        collectionVwItem.dataSource = self
        collectionVwItem.reloadData()
        collectionVwSize.delegate = self
        collectionVwSize.dataSource = self
        collectionVwSize.reloadData()
        lblColor.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.color)
        lblSize.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.size)
        lblPrice.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.price)
        lblQty.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.quantity)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtFieldColor {
        //    txtFieldQuentity.resignFirstResponder()
            txtFieldPrice.resignFirstResponder()
            NotificationCenter.default.post(name: NSNotification.Name("ForColor"), object: txtFieldColor.tag)
            return false
            
        }
 
    else{
            return true
        }
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        var indexVal = Int()
        switch textField {
        case txtFieldColor:
            indexVal = textField.tag-10
        case txtFieldPrice:
            indexVal = textField.tag-40
        default:
            indexVal = textField.tag
        }

        let mainArrDict = KAppDelegate.listVariantArr.object(at: indexVal) as! NSMutableDictionary
        let dictVariant = NSMutableDictionary()
        dictVariant.setValue(mainArrDict["color_id"], forKey: "color_id")
        dictVariant.setValue(txtFieldColor.text!, forKey: "color")
        dictVariant.setValue(txtFieldPrice.text!, forKey: "amount")

        dictVariant.setValue(mainArrDict["detail"] as? NSMutableArray, forKey: "detail")
        KAppDelegate.listVariantArr.replaceObject(at: indexVal, with: dictVariant)
        
        return true
    }
 
    func passArrayData(arradyDict: NSMutableDictionary)  {
        arrData = []
        let sizeQuantityArr = arradyDict.value(forKey: "detail") as! NSMutableArray
        arrData = sizeQuantityArr
        collectionVwItem.reloadData()
        collectionVwSize.reloadData()
    }
    /// MARK:- Collection View Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          return arrData.count
       }
    
    func collectionView(_ collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if collectionView == collectionVwItem{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VarientCVC",for: indexPath as IndexPath) as! VarientCVC
    let cellDict = arrData[indexPath.row] as! NSMutableDictionary
                cell.lblTitle.tag = 10000*(crossAction.tag)+indexPath.row
    cell.lblTitle.text = "\((cellDict).value(forKey: "quantity") as? String ?? "")"
        cell.backgroundView?.layer.cornerRadius = 5.0
        cell.backgroundView?.clipsToBounds = true
            return cell
        }
            
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VarientSizeCVC",for: indexPath as IndexPath) as! VarientSizeCVC
            
            let cellDict = arrData[indexPath.row] as! NSMutableDictionary
            cell.lblTitle.tag = 10000*(crossAction.tag)+indexPath.row
            cell.lblTitle.text = "\((cellDict).value(forKey: "size") as? String ?? "")"
            if arrData.count==1{
                cell.btnCross.isHidden = true
            }else{
               cell.btnCross.isHidden = false
            }
            cell.btnCross.tag = 100000*(crossAction.tag)+indexPath.row
            cell.btnCross.addTarget(self, action: #selector(actionDeletedSize(_ :)), for: .touchUpInside)
            cell.backgroundView?.layer.cornerRadius = 5.0
            cell.backgroundView?.clipsToBounds = true
            return cell
        }
        
    }
    
    @objc func actionDeletedSize(_ sender:UIButton){
        arrData = []
        let objectVal = sender.tag
        var getsection = Int()
        getsection = objectVal/100000
        var getRow = Int()
        getRow = objectVal%100000

        let mainArrDict = KAppDelegate.listVariantArr.object(at: getsection) as! NSMutableDictionary
        
        let dictVariant = NSMutableDictionary()
        dictVariant.setValue(mainArrDict["color_id"], forKey: "color_id")
        dictVariant.setValue(txtFieldColor.text!, forKey: "color")
        dictVariant.setValue(txtFieldPrice.text!, forKey: "amount")
        
        
        let sizeQuantityArr = mainArrDict.value(forKey: "detail") as! NSMutableArray
        sizeQuantityArr.removeObject(at: getRow)
        dictVariant.setValue(sizeQuantityArr, forKey: "detail")
        KAppDelegate.listVariantArr.replaceObject(at: getsection, with: dictVariant)
        
        arrData = []
        arrData = sizeQuantityArr 
        collectionVwItem.reloadData()
        collectionVwSize.reloadData()
    }
    @IBAction func actionAddSize(_ sender: UIButton) {
        // Check value is exist in size or quantity
        IQKeyboardManager.sharedManager().resignFirstResponder()
        
        var getsection = Int()
        getsection = sender.tag///10000
      
        let mainArrDict = KAppDelegate.listVariantArr.object(at: getsection) as! NSMutableDictionary
        let sizeQuantityArr = mainArrDict["detail"] as! NSMutableArray
        var checkSizeQuantVal = false
        var message = ""
        for i in 0..<sizeQuantityArr.count{
            let sizeDict = sizeQuantityArr[i] as! NSMutableDictionary
            if let sizeVal = sizeDict.value(forKey: "size") as? String{
                if sizeVal != ""{
                    if let quantityVal = sizeDict.value(forKey: "quantity") as? String{
                        if quantityVal != ""{
                            
                        }else{
                            checkSizeQuantVal = true
                            message = "quantity"
                            break
                        }
                    }
                    
                }else{
                    // size value nil
                    checkSizeQuantVal = true
                    message = "size"
                    break
                }
            }
        }
    
        if checkSizeQuantVal == true{
            Proxy.shared.displayStatusCodeAlert("\(Proxy.shared.languageSelectedStringForKey(AlertValue.pleaseEnter))\(message)\(Proxy.shared.languageSelectedStringForKey( AlertValue.value))")
            return
        }else{
            let dictVariant = NSMutableDictionary()
            dictVariant.setValue(mainArrDict["color_id"], forKey: "color_id")
            dictVariant.setValue(mainArrDict["color"], forKey: "color")
            dictVariant.setValue(mainArrDict["amount"], forKey: "amount")
            
            let sizeQuantityDict = NSMutableDictionary()
            sizeQuantityDict.setValue("", forKey: "size")
            sizeQuantityDict.setValue(-1, forKey: "size_id")
            sizeQuantityDict.setValue("", forKey: "quantity")
            sizeQuantityArr.add(sizeQuantityDict)
            
            dictVariant.setValue(sizeQuantityArr, forKey: "detail")
            KAppDelegate.listVariantArr.replaceObject(at: getsection, with: dictVariant)
            
            arrData = []
            arrData = sizeQuantityArr//add(dictVariant)
            collectionVwItem.reloadData()
            collectionVwSize.reloadData()
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
       
        var stringToFit = String()
        let colorDict = arrData[indexPath.row] as! NSMutableDictionary
        if collectionView == collectionVwItem{
            stringToFit  = colorDict["size"] as! String
            let font = UIFont.systemFont(ofSize: 10)
            let userAttributes = [NSAttributedStringKey.font.rawValue: font, NSAttributedStringKey.foregroundColor: UIColor.black] as? [NSAttributedStringKey : Any]
            let size = stringToFit.size(withAttributes: userAttributes)
            let newSize = CGSize(width: size.width + 50 , height: 37)
            return newSize

        }else{
            stringToFit = colorDict["size"] as! String
            let font = UIFont.systemFont(ofSize: 10)
            let userAttributes = [NSAttributedStringKey.font.rawValue: font, NSAttributedStringKey.foregroundColor: UIColor.black] as? [NSAttributedStringKey : Any]
            let size = stringToFit.size(withAttributes: userAttributes)
            
            let newSize = CGSize(width: size.width + 50 , height: 37)
            return newSize
         }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        if collectionView == collectionVwItem{
         return UIEdgeInsetsMake(-5, 0, 0, 0)
        }
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
}
