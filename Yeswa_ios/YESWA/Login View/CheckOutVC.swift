//
//  CheckOutVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 13/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit
import CoreLocation

class CheckOutVC: UIViewController {
    
    @IBOutlet weak var btnPlaceOrder: SetCornerButton!
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblPaymentMode: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblShipingHeader: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblHeaderSummery: UILabel!
    @IBOutlet weak var lblAddressHeader: UILabel!
    @IBOutlet weak var lblMobileNoHeader: UILabel!
    @IBOutlet weak var lblNameHeader: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txtFieldName: UITextField!
    @IBOutlet weak var lblProductPrice: UILabel!
    @IBOutlet weak var btncheckBoxCash: UIButton!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblShowDeliveryChargeAmt: UILabel!
    @IBOutlet weak var lblFinalTotla: UILabel!
    @IBOutlet weak var txtFieldMobileNo: UITextField!
    
    //variabe
    var totalPrice = Int ()
    var objCheckoutviewModel = CheckOutViewModel ()
    var btnClick = Int ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
         lblHeader.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.checkout)
        lblNameHeader.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.Name)
         lblMobileNoHeader.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.mobile)
        lblAddressHeader.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.address)
        lblHeaderSummery.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.orderSummary)
         lblSubTotal.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.subTotal)
          lblShipingHeader.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.shipingCharge)
        lblTotal.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.total)
         lblPaymentMode.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.paymode)
        lblPaymentType.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.cash)
    btnPlaceOrder.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.placeanorder), for: .normal)
    }
    //MARK:- ViewWillapper Method
    override func viewWillAppear(_ animated: Bool) {
        lblProductPrice.text = "\(totalPrice) \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
        lblFinalTotla.text = "\(totalPrice + 2) \(Proxy.shared.languageSelectedStringForKey(ConstantValue.Doller))"
        if objSelectOrderAddressModel.house != "" {
          lblAddress.text = "\(objSelectOrderAddressModel.house),\(objSelectOrderAddressModel.street),\(objSelectOrderAddressModel.region)\(objSelectOrderAddressModel.governorate),\(objSelectOrderAddressModel.mobileNo)"
        }else{
             lblAddress.text = ""
        }
    }
      //MARK:- action Button Address
    @IBAction func actionBtnAddress(_ sender: UIButton) {
        Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.mainStoryboard, identifier: "SelectOrderAddressVC", isAnimate: true, currentViewController: self)
    }
    
    //MARK:- Action Buttons
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
     //MARK:- action checboxCash Address
    @IBAction func actionBtnCheckBoxCash(_ sender: UIButton) {
        if btnClick == 0 {
            self.btncheckBoxCash.isSelected = true
            self.btncheckBoxCash.setImage(#imageLiteral(resourceName: "ic_selected_box"), for: .normal)
            btnClick = 1
        } else{
            self.btncheckBoxCash.isSelected = false
            self.btncheckBoxCash.setImage(#imageLiteral(resourceName: "ic_box"), for: .normal)
            btnClick = 0
        }
    }
     //MARK:- action continueToPayment Address 
    @IBAction func actionContinueToPayment(_ sender: UIButton) {
        
        if txtFieldName.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.name))
        }
        else if txtFieldMobileNo.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.phoneNumber))
            
        }
        else if lblAddress.text!.isEmpty {
        Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.selectAddres))
        }
        else if btncheckBoxCash.isSelected == false {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.orderbyCash))
            }
        else {
            objCheckoutviewModel.placeOrderApi(objSelectOrderAddressModel.house, streetAddres: objSelectOrderAddressModel.street, country: objSelectOrderAddressModel.governorate, state: objSelectOrderAddressModel.region, MobileNo1: objSelectOrderAddressModel.mobileNo, state_id: objSelectOrderAddressModel.regionId, mobileNo2: txtFieldMobileNo.text!){
            autoCompleteModel = AutoCompleteModel()
            self.btncheckBoxCash.setImage(#imageLiteral(resourceName: "ic_box"), for: .normal)
            self.txtFieldName.text = ""
            objSelectOrderAddressModel = SelectOrderAddressModel ()
        RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "HomeVC")
        Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.OrderplaceSuccessfully))
        }
    }
}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
