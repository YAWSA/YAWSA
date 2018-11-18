//
//  CartVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 13/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class CartVC: UIViewController {
    //MARK:- Outlet
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblTotalProductQuentity: UILabel!
    @IBOutlet weak var tblVwItemsList: UITableView!
    @IBOutlet weak var lblPriceDetailSubTotal: UILabel!
    @IBOutlet weak var VwShowProductItemPrice: UIView!
    @IBOutlet weak var vwShowPriceDetailPrice: UIView!
    @IBOutlet weak var lblHeadingPriceDetail: UILabel!
    @IBOutlet weak var lblSubtotalHeader: UILabel!
    @IBOutlet weak var btnCheckOut: SetCornerButton!
    var cartItemListModelObj = CartViewModel ()
    override func viewDidLoad() {
     super.viewDidLoad()
     lblHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.cart)
        lblHeadingPriceDetail.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.priceDetail)
        lblSubtotalHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.subTotal)
      btnCheckOut.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.checkout), for: .normal)
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cartItemListModelObj.getCartListProduct {
            self.handelAmount()
        }
    }
    
    //MARK:- Action Buttons
    @IBAction func actionDrawer(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    @IBAction func actionCheckOut(_ sender: UIButton) {
        if cartItemListModelObj.cartListArr.count == 0 {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.noProductinCartList))
            
        }else {
            let checkoutVCObj = self.storyboard?.instantiateViewController(withIdentifier: "CheckOutVC") as! CheckOutVC
            checkoutVCObj.totalPrice = cartItemListModelObj.priceVal
            self.navigationController?.pushViewController(checkoutVCObj, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
