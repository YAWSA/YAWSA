//
//  SelectFilterColorSizeBrand.swift
//  YESWA
//
//  Created by Sonu Sharma on 09/07/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class SelectFilterColorSizeBrand: UIViewController {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var tblVwColorSizeBrand: UITableView!
    var headerTitleVal = Int()
    var objSlectFiltrColrSizeBrndVM = SelectColorSizeBrandVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        switch headerTitleVal {
        case 0:
            lblHeader.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.selectSize)
            for i in 0 ..< KAppDelegate.sizeFilterArr.count{
                let cellDict = KAppDelegate.sizeFilterArr[i]
                objSlectFiltrColrSizeBrndVM.selectedID.add(cellDict.Id)
            }
            objSlectFiltrColrSizeBrndVM.getSizeList {
                self.tblVwColorSizeBrand.reloadData()
            }
        case 1:
            for i in 0 ..< KAppDelegate.colorFilterArr.count{
                let cellDict = KAppDelegate.colorFilterArr[i]
                objSlectFiltrColrSizeBrndVM.selectedID.add(cellDict.Id)
            }
              lblHeader.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.selectColor)
            objSlectFiltrColrSizeBrndVM.getColorList {
                  self.tblVwColorSizeBrand.reloadData()
            }
            
        case 2:
            
            for i in 0 ..< KAppDelegate.brandListFilterArr.count{
                let cellDict = KAppDelegate.brandListFilterArr[i]
                objSlectFiltrColrSizeBrndVM.selectedID.add(cellDict.brandId)
            }
             lblHeader.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.selectBrand)
            objSlectFiltrColrSizeBrndVM.getBrandList {
            self.tblVwColorSizeBrand.reloadData()
            }
            
        default:
             break
        }
      

    }
    
    
    @IBAction func actionBtnCross(_ sender: UIButton) {
       self.dismiss(animated: true, completion: nil)
    }
    @IBAction func actionDone(_ sender: UIButton) {
       
        self.dismiss(animated: true) {
        switch self.headerTitleVal {
        case 0:
            for i in 0 ..< self.objSlectFiltrColrSizeBrndVM.sizeArr.count{
                let cellDict = self.objSlectFiltrColrSizeBrndVM.sizeArr[i]
                
                if self.objSlectFiltrColrSizeBrndVM.selectedID.contains(cellDict.Id){
                    KAppDelegate.sizeFilterArr.append(cellDict)
                }
            }
        case 1:
            for i in 0 ..< self.objSlectFiltrColrSizeBrndVM.colorArr.count{
                let cellDict = self.objSlectFiltrColrSizeBrndVM.colorArr[i]
                
                if self.objSlectFiltrColrSizeBrndVM.selectedID.contains(cellDict.Id){
                    KAppDelegate.colorFilterArr.append(cellDict)
                }
                }
        case 2:
            for i in 0 ..< self.objSlectFiltrColrSizeBrndVM.brandListArr.count{
                let cellDict = self.objSlectFiltrColrSizeBrndVM.brandListArr[i]
                
                if self.objSlectFiltrColrSizeBrndVM.selectedID.contains(cellDict.brandId){
                    KAppDelegate.brandListFilterArr.append(cellDict)
                }
                }
        default:
            break
        }
            NotificationCenter.default.post(name: NSNotification.Name("setFilter"), object: self.headerTitleVal)
        
      }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

   

}
