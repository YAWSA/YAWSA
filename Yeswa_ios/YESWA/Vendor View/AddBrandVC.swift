//
//  AddBrandVC.swift
//  YESWA
//
//  Created by Babita Chauhan on 19/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class AddBrandVC: UIViewController,passImageDelegate,UITextFieldDelegate {
    //Outlet
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txtFieldTitle: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var imgVwBrand: UIImageView!
    //Variable
    var selectdItemDict = BrandVCModel ()
    var addBrandViewModelObj =  AddBrandViewModel()
    var btnTapped = ""
    var categoryID = Int ()
    var galleryFunctions =  GalleryCameraImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCameraImageObj = self
        if btnTapped == "EditButton" {
          btnSave.setTitle( Proxy.shared.languageSelectedStringForKey(ConstantValue.update), for: .normal)
          txtFieldTitle.text = "\(selectdItemDict.brandTitle!)"
          imgVwBrand.sd_setImage(with: URL(string: selectdItemDict.brandFile), completed: nil)
        }else{
             btnSave.setTitle( Proxy.shared.languageSelectedStringForKey(ConstantValue.save), for: .normal)
        }
        
        txtFieldTitle.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.enterbrand))
        
        lblHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.brands)
        
        btnSave.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.save), for: .normal)
        

    }

    
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    @IBAction func actionCamera(_ sender: UIButton) {
          galleryFunctions.customActionSheet()
        
    }
    func passSelectedimage(selectImage: UIImage) {
        imgVwBrand.image = selectImage
        
    }
    
    //MARK:- Action Save
    @IBAction func actionSave(_ sender: UIButton) {
        txtFieldTitle.resignFirstResponder()
        if btnTapped == "EditButton" {
            if txtFieldTitle.text!.isEmpty {
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.title))
            }
            else{
                addBrandViewModelObj.editBrand(txtFieldTitle.text!, categoryID: categoryID ,brandID : selectdItemDict.brandId,brandImg: imgVwBrand.image! ) {
                   Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.editbrandsuccessfully))
                     Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
                }
            }
        }else {
            if txtFieldTitle.text!.isEmpty {
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.title))
            }else{
                addBrandViewModelObj.addBrand(txtFieldTitle.text!, categoryID: categoryID ,brandImg: imgVwBrand.image!) {
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.addbrandsuccessfully))
                Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
                }
            }
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

