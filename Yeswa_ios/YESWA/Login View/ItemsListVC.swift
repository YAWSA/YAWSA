//
//  ItemsListVC.swift
//  YESWA
//
//  Created by Sonu Sharma on 15/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit
import SDWebImage

class ItemsListVC: UIViewController,UITextFieldDelegate {
    
     //MARK:- Outlet
   
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtFieldSearch: UITextField!
    @IBOutlet weak var lblHeaderTitle: UILabel!
    @IBOutlet weak var lblTotalItemCount: UILabel!
    @IBOutlet weak var collectinVwItemsList: UICollectionView!
    @IBOutlet weak var VwBottom: UIView!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var btnFilter: UIButton!
     @IBOutlet weak var btnAllProduct: UIButton!
    
    var chooseShopType = ""
    var categoryID = Int()
    var itemsListViewModelObj =  ItemListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblHeaderTitle.text = KAppDelegate.bottomTabOption
        NotificationCenter.default.addObserver(self, selector: #selector(setFilterNotification(_:)), name: NSNotification.Name("FilterPerform"), object: nil)
        self.collectinVwItemsList.register(UINib(nibName: "ItemListCVC", bundle: nil), forCellWithReuseIdentifier: "ItemListCVC")
         txtFieldSearch.placeholder = Proxy.shared.languageSelectedStringForKey(ConstantValue.search)
        checkForApi()
       

    }
    
    func checkForApi(){
        
        SDImageCache.shared().clearMemory()
        SDImageCache.shared().clearDisk()
        
        if  KAppDelegate.bottomTabOption == "Category" {
            btnFilter.isHidden = true
            btnAllProduct.isHidden = true
            Proxy.shared.addTabBottom(VwBottom, tabNumber: TabTitle.TAB_Category, currentViewController: self, currentStoryboard: StoryboardChnage.mainStoryboard)
            
            if categoryID != 0{
                self.lblHeaderTitle.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.brands)
                self.itemsListViewModelObj.selectItemType =  Proxy.shared.languageSelectedStringForKey(ConstantValue.brands)
                itemsListViewModelObj.getBrandList(categoryID: categoryID, {
                    self.collectinVwItemsList.reloadData()
                })
            }else{
                self.lblHeaderTitle.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.categoty)
                itemsListViewModelObj.selectItemType =  Proxy.shared.languageSelectedStringForKey(ConstantValue.categoty)
               
                itemsListViewModelObj.getCategoryList {
                    self.collectinVwItemsList.reloadData()
                }}
        }else {
            btnAllProduct.isHidden = false
            btnFilter.isHidden = false
            Proxy.shared.addTabBottom(VwBottom, tabNumber: TabTitle.TAB_Brand, currentViewController: self, currentStoryboard: StoryboardChnage.mainStoryboard)
            self.itemsListViewModelObj.selectItemType =  Proxy.shared.languageSelectedStringForKey(ConstantValue.brands)
            itemsListViewModelObj.getAllBrandList {
                self.collectinVwItemsList.reloadData()
            }
        }
    }
    
    
    //MARK:- button show All Product
    @IBAction func actionShowAllProduct(_ sender: UIButton) {
        //HomeVC
        let productListVCObj = self.storyboard?.instantiateViewController(withIdentifier: "ProuductListVCCustomer") as! ProuductListVCCustomer
        productListVCObj.isFromController = "HomeVC"
        self.navigationController?.pushViewController(productListVCObj, animated: true)
        
    }
    @objc func setFilterNotification(_ notification: Notification){
        let productListVCObj = self.storyboard?.instantiateViewController(withIdentifier: "ProuductListVCCustomer") as! ProuductListVCCustomer
        self.navigationController?.pushViewController(productListVCObj, animated: true)

    }
    @IBAction func actionFilter(_ sender: UIButton) {
        let filterVCObj = storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        self.present(filterVCObj, animated: true, completion: nil)
    }
    
    //MARK:-
    @IBAction func actionBack(_ sender: UIButton) {
        itemsListViewModelObj.selectItemType = "Category"
        self.btnAllProduct.isHidden = true
        self.lblHeaderTitle.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.categoty)
        itemsListViewModelObj.getCategoryList {
            self.collectinVwItemsList.reloadData()
            self.btnBack.isHidden = true
        }
    }
    
//MARK:- Actin Cross
  @IBAction func actionCross(_ sender: UIButton) {
        txtFieldSearch.text = ""
        txtFieldSearch.resignFirstResponder()
        
        if KAppDelegate.bottomTabOption == "Category" {
              itemsListViewModelObj.getCategoryList {
                self.collectinVwItemsList.reloadData()
             }
        }else {
            itemsListViewModelObj.getAllBrandList {
                self.collectinVwItemsList.reloadData()
            }
        }
    }
    @IBAction func actionAddCart(_ sender: UIButton) {
        
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
    
    //MARK:- action Drawer
    @IBAction func actionDrawer(_ sender: UIButton) {
        self.revealViewController().revealToggle(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
