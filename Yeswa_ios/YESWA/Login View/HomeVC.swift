//
//  HomeVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 13/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit
import SWRevealViewController

class HomeVC: UIViewController {

    @IBOutlet weak var tblVwHeightCnstrnt: NSLayoutConstraint!
    @IBOutlet weak var VwBottom: UIView!
    @IBOutlet weak var tblVwItemList: UITableView!
    @IBOutlet weak var vwSlider: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblHeader: UILabel!
    //variable
   
    var arrShopVia = [ Proxy.shared.languageSelectedStringForKey(ConstantValue.shopbyBrand),Proxy.shared.languageSelectedStringForKey(ConstantValue.latestProudcts)]
    var  homeViewModelObj = HomeViewModel ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblHeader.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.home)
   
        tblVwItemList.tableFooterView = UIView()
        Proxy.shared.addTabBottom(VwBottom, tabNumber: TabTitle.TAB_Home, currentViewController: self, currentStoryboard: StoryboardChnage.mainStoryboard)
         NotificationCenter.default.addObserver(self, selector: #selector(handelSelectCategoryNotification(_:)), name: NSNotification.Name("SelectCategory"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let auth = Proxy.shared.authNil()
        if auth == "" {
            btnBack.isHidden = false
        }else {
            btnBack.isHidden = true
        }
        
        let nib = UINib.init(nibName: "HomeMenuTVC", bundle: nil)
        self.tblVwItemList.register(nib, forCellReuseIdentifier: "HomeMenuTVC")
        self.homeViewModelObj.imgFileProductArr = []
        homeViewModelObj.getSliderImage {
            self.addSlider(self.vwSlider, storyboard: StoryboardChnage.mainStoryboard,arrValue: self.homeViewModelObj.sliderModelArr )
        }
        homeViewModelObj.getNewProductList {
            self.homeViewModelObj.getBrandList {
                self.tblVwItemList.reloadData()
            }
        }
    }
    
    // MARK:- HandleNotification Method
    @objc func handelSelectCategoryNotification( _ notification: Notification)  {
        
        if KAppDelegate.bottomTabOption == "Product" {
            let productDetailVCObj =  self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailVCCustomer") as! ProductDetailVCCustomer
            productDetailVCObj.productDetailDict = notification.object as! AddProductWithoutVarientModel
        self.navigationController?.pushViewController(productDetailVCObj, animated: true)
            }
           else{
            let productListVCObj = self.storyboard?.instantiateViewController(withIdentifier: "ProuductListVCCustomer") as! ProuductListVCCustomer
               productListVCObj.brandId = notification.object as! Int
            self.navigationController?.pushViewController(productListVCObj, animated: true)
        }
    }
   
    func addSlider(_ bottomContainerView:UIView, storyboard : UIStoryboard,arrValue: [SliderModel]) {
        let sliderHomeVCObj = storyboard.instantiateViewController(withIdentifier: "SliderHomeVC") as! SliderHomeVC
        sliderHomeVCObj.sliderArr = arrValue
        sliderHomeVCObj.comeFrom = "Home"
        self.addChildViewController(sliderHomeVCObj)
        sliderHomeVCObj.view.frame = CGRect(x: 0, y: 0, width: bottomContainerView.frame.size.width, height: bottomContainerView.frame.size.height)
        bottomContainerView.addSubview(sliderHomeVCObj.view)
        sliderHomeVCObj.didMove(toParentViewController: self)
        
    }

    
    @IBAction func actionBack(_ sender: UIButton) {
      RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "SelectRoleVC")
    }
    //AMRK:- Add to Cart
    @IBAction func actionAddToCart(_ sender: UIButton) {
        let auth = Proxy.shared.authNil()
        if auth == "" {
            let alertController = UIAlertController(title: (Proxy.shared.languageSelectedStringForKey(ConstantValue.loginPlease)), message: (Proxy.shared.languageSelectedStringForKey(ConstantValue.wantOrder)), preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: (Proxy.shared.languageSelectedStringForKey(ConstantValue.cancel)), style: .default) { (action:UIAlertAction!) in
            }
            alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: (Proxy.shared.languageSelectedStringForKey(ConstantValue.ok)), style: .cancel) { (action:UIAlertAction!) in
                KAppDelegate.isComeFrom = "HomeVC"
                Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.mainStoryboard, identifier: "SignInVC", isAnimate: true, currentViewController: self)
            }
            
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        }else{
        Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.mainStoryboard, identifier: "CartVC", isAnimate: true, currentViewController: self)
        }
        
     
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
