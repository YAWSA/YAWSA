//
//  ProductDetailVCVendor.swift
//  YESWA
//
//  Created by Sonu Sharma on 07/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit
import DKImagePickerController
import Photos

class ProductDetailVCVendor: UIViewController ,multipleImageDelegate{
    
    //MARK:- outlet
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblBrand: UILabel!
    @IBOutlet weak var lblDescriptions: UILabel!
    @IBOutlet weak var lblTitleHeader: UILabel!
    @IBOutlet weak var btnAddMore: UIButton!
    @IBOutlet weak var lblVariantProduct: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    
    @IBOutlet weak var viewSlider: UIView!
    @IBOutlet weak var txtFieldTitle: UITextField!
    @IBOutlet weak var txtVwDescription: UITextView!
    @IBOutlet weak var txtFieldCategory: UITextField!
    @IBOutlet weak var txtFieldBrand: UITextField!
    @IBOutlet weak var cnstHeightTblView: NSLayoutConstraint!
    @IBOutlet weak var tblVwProductVarient: UITableView!
    
    var objDetailVendorViewModel = ProductDetailVendorViewModel()
    var selectMultipleImageObj =  SelectMultipleImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        multipleImageObj = self
        NotificationCenter.default.addObserver(self, selector: #selector(handelDetailNotification(_:)), name: NSNotification.Name("DeleteBannerImage"), object: nil)
        
        let nib = UINib.init(nibName: "variantTVC", bundle: nil)
        self.tblVwProductVarient.register(nib, forCellReuseIdentifier: "variantTVC")
        setStaticsStrings()
    }
    func setStaticsStrings(){
        lblHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.productDetails)
        lblBrand.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.brands)
        lblDescriptions.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.descriptions)
        lblTitleHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.title)
         lblVariantProduct.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.variantProduct)
         lblCategory.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.categoty)
        btnAddMore.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.addMoreVariant), for: .normal)
        


    }
    @objc func handelDetailNotification(_ notification: Notification)
    {
        objDetailVendorViewModel.getProductDetail {
            self.showProductDetails()
        }
    }
    @IBAction func addVarientAction(_ sender: Any) {
        
        let addVarientVCObj = self.storyboard?.instantiateViewController(withIdentifier: "AddVarientVC") as! AddVarientVC
        addVarientVCObj.addVarientViewModelObj.comeFrom = "Detail"
        self.navigationController?.pushViewController(addVarientVCObj, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        objDetailVendorViewModel.getProductDetail {
            self.showProductDetails()
        }
    }
    
    @IBAction func addImageAction(_ sender: Any) {
         selectMultipleImageObj.customActionSheet()
    }
    
    
    // MARK:- Action Back
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    func passSelectedimages(selectedImages: [DKAsset]) {
        //objDetailVendorViewModel.cameFromGalley = "Gallery"
        objDetailVendorViewModel.imagesArray=[]
        objDetailVendorViewModel.assets = []
        objDetailVendorViewModel.assets = selectedImages
        if selectedImages.count != 0 {
            Proxy.shared.showActivityIndicator()
            for i in 0 ..< selectedImages.count {
                selectedImages[i].fetchImageWithSize(PHImageManagerMaximumSize, options: PHImageRequestOptions()) { image, info in
                    var img = UIImage()
                    img = image!
                    self.objDetailVendorViewModel.imagesArray.append(img)
                    if self.objDetailVendorViewModel.imagesArray.count == selectedImages.count {
                        self.objDetailVendorViewModel.addImageApi{
                            Proxy.shared.hideActivityIndicator()
                            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.imageAdded))
                            
                            if addProductWithoutVarientObj.imgProductArray.count != 0
                            {
                             self.showProductDetails()
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

