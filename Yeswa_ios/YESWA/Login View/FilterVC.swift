//
//  FilterVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 06/07/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit
import NHRangeSlider
class FilterVC: UIViewController ,NHRangeSliderViewDelegate{
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var sliderPrice: NHRangeSliderView!
    @IBOutlet weak var lblSize: UILabel!
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblBrand: UILabel!
    
    //variable
    var objfilterVM = FilterViewModel ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sliderPrice.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(handelNotification(_:)), name:  NSNotification.Name("setFilter"), object: nil)
        sliderPrice.lowerValue = 0
        sliderPrice.upperValue = 100
        KAppDelegate.sizeFilterArr = []
        KAppDelegate.colorFilterArr = []
        KAppDelegate.brandListFilterArr = []
         KAppDelegate.sliderMinVal = ""
         KAppDelegate.sliderMaxVal = ""
    }
    func sliderValueChanged(slider: NHRangeSlider?) {
      let lowerValue =   slider?.lowerValue
        let upperValue =   slider?.upperValue
        KAppDelegate.sliderMinVal = "\(lowerValue!)"
        KAppDelegate.sliderMaxVal = "\(upperValue!)"

    }
    //MARK:- Handle Notification Method --
    @objc func handelNotification(_ notification: Notification){
        let notificationObj = notification.object as! Int
        switch notificationObj {
        case 0:
         lblSize.text = objfilterVM.appendParam(arr: KAppDelegate.sizeFilterArr, appendFor: "title")
        lblSize.textColor = UIColor.black
        case 1:
            lblColor.text = objfilterVM.appendParam(arr: KAppDelegate.colorFilterArr, appendFor: "title")
            lblColor.textColor = UIColor.black

        case 2:
            lblBrand.text = objfilterVM.appendParam(arr: KAppDelegate.brandListFilterArr, appendFor: "title")
            lblBrand.textColor = UIColor.black
        default:
            break
        }
    }
    
   
    //MARK:- Action Cross --
    @IBAction func actionCross(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    //MARK:- Action
    @IBAction func actionBtnSelectSize(_ sender: UIButton) {
        let selectfltColorSizeBrandObj = storyboard?.instantiateViewController(withIdentifier: "SelectFilterColorSizeBrand") as! SelectFilterColorSizeBrand
        selectfltColorSizeBrandObj.headerTitleVal = 0
        self.present(selectfltColorSizeBrandObj, animated: true, completion: nil)
    }
    
    @IBAction func actionBtnSelectColor(_ sender: UIButton) {
        let selectfltColorSizeBrandObj = storyboard?.instantiateViewController(withIdentifier: "SelectFilterColorSizeBrand") as! SelectFilterColorSizeBrand
         selectfltColorSizeBrandObj.headerTitleVal = 1
        self.present(selectfltColorSizeBrandObj, animated: true, completion: nil)
    }
    
    @IBAction func actionBtnSelectBrand(_ sender: UIButton) {
        let selectfltColorSizeBrandObj = storyboard?.instantiateViewController(withIdentifier: "SelectFilterColorSizeBrand") as! SelectFilterColorSizeBrand
          selectfltColorSizeBrandObj.headerTitleVal = 2
        self.present(selectfltColorSizeBrandObj, animated: true, completion: nil)
        
    }
    
    @IBAction func ActionBtnFilter(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
             NotificationCenter.default.post(name: NSNotification.Name("FilterPerform"), object: nil)
        }
       
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

}
