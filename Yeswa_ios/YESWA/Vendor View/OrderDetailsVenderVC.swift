//
//  OrderDetailsVenderVC.swift
//  YESWA
//
//  Created by Babita Chauhan on 19/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class OrderDetailsVenderVC: UIViewController {
    //MARK:- IBOutlets
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tblViewOrder: UITableView!
    @IBOutlet weak var lblPaymentMethod: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var lblShippingAddress: UILabel!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var lblTotalItemCount: UILabel!
    @IBOutlet weak var tblVwHeightCnstrnt: NSLayoutConstraint!
    @IBOutlet weak var lblPriceDetail: UILabel!
    @IBOutlet weak var lblPaymethod: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    var isComeFromController = ""
    var stateId = Int ()
    
    //MARK:- Variables
    var orderDetailsModelViewObj = OrderDetailVendorViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderDetailsModelViewObj.getOrderDetails {
            self.tblViewOrder.reloadData()
            self.tblViewOrder.layoutIfNeeded()
            self.tblVwHeightCnstrnt.constant = self.tblViewOrder.contentSize.height
        }
        handelBtn()
        setUpData()
       
    }
    func setUpData(){
        lblHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.orderDetails)
        btnAccept.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.accept), for: .normal)
        btnReject.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.reject), for: .normal)
        lblPriceDetail.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.priceDetail)
        lblPaymethod.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.paymentMethod)
        lblSubTotal.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.subTotal)
        lblAddress.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.address)
    }
    func handelBtn(){
        btnAccept.isHidden = false
        btnReject.isHidden = false
        switch stateId {
        case OrderState.STATE_REJECTED.rawValue, OrderState.STATE_COMPLETED.rawValue:
            btnAccept.isHidden = true
            btnReject.isHidden = true
        case OrderState.STATE_ACCEPTED.rawValue:
            btnAccept.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.started), for: .normal)
            btnReject.isHidden = true
        case OrderState.STATE_STARTED.rawValue:
            btnAccept.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.complete), for: .normal)
            btnReject.isHidden = true
        default:
            break
        }
    }
    //MARK:- Action Back ------
    @IBAction func actionBack(_ sender: UIButton) {
     Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    //MARK:- Action Buttons
    @IBAction func actionAccept(_ sender: Any) {
        var stateVal = Int()
        switch stateId {
        case OrderState.STATE_NEW.rawValue:
            stateVal = OrderState.STATE_ACCEPTED.rawValue
        case OrderState.STATE_ACCEPTED.rawValue:
            stateVal = OrderState.STATE_STARTED.rawValue
        case OrderState.STATE_STARTED.rawValue:
              stateVal = OrderState.STATE_COMPLETED.rawValue
        default:
            break
        }
        stateId = stateVal
       orderDetailsModelViewObj.changeOrderState(stateVal, orderId: orderDetailsModelViewObj.objOrderHistoryModel.id, completion: {
        self.handelBtn()
        })
    }
    //MARK:- Action Reject
    @IBAction func actionReject(_ sender: UIButton) {
        stateId = OrderState.STATE_REJECTED.rawValue
     orderDetailsModelViewObj.changeOrderState(OrderState.STATE_REJECTED.rawValue, orderId: orderDetailsModelViewObj.objOrderHistoryModel.id, completion: {
    self.handelBtn()
        })
    }
}
