//
//  AddCategoryVC.swift
//  YeshwaVendor
//
//  Created by Babita Chauhan on 17/03/18.
//  Copyright © 2018 Desh Raj Thakur. All rights reserved.
//

import UIKit
import DKImagePickerController
import Photos
class AddCategoryVC: UIViewController,UITextFieldDelegate,multipleImageDelegate {
    
    //MARK:- Outlet
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var txtFieldTitle: UITextField!
    @IBOutlet weak var collViewProductImages: UICollectionView!
    @IBOutlet weak var btnAddProduct: SetCornerButton!
    @IBOutlet weak var lblDescription: UILabel!
    var objSelectCategoryViewModel =  SelectCategoryViewModel()
   
    var selectMultipleImageObj =  SelectMultipleImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        multipleImageObj = self
      

        txtFieldTitle.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.enterTitle))
        lblHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.addNewProdouct)
        lblDescription.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.addDescriptions)
      
        btnAddProduct.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.addProduct), for: .normal)
        

        
    }
   
    //MARK:- UITextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         if textField == txtFieldTitle {
            txtViewDescription.becomeFirstResponder()
        }
        else {
            txtViewDescription.becomeFirstResponder()
        }
        return true
    }
    
    func passSelectedimages(selectedImages: [DKAsset]) {
        self.objSelectCategoryViewModel.imagesArray=[]
        if selectedImages.count != 0 {
            for i in 0 ..< selectedImages.count {
                selectedImages[i].fetchImageWithSize(PHImageManagerMaximumSize, options: PHImageRequestOptions()) { image, info in
                    var img = UIImage()
                    img = image!
                    self.objSelectCategoryViewModel.imagesArray.append(img)
                    if self.objSelectCategoryViewModel.imagesArray.count == selectedImages.count {
                        self.collViewProductImages.reloadData()
                    }
                }
            }
        }
        
        
    }
//MARK:- Buttons Back ======>>
    
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }

    
    //MARK:- Action Save
    @IBAction func actionSave(_ sender: UIButton) {
         if txtFieldTitle.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.title))
        }
        else if txtViewDescription.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.description))
        }
        else if objSelectCategoryViewModel.imagesArray.count == 0 {
            
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.selectImage))
        }
        else {
          objSelectCategoryViewModel.addProductWithoutVarient(txtFieldTitle.text!, _titleDescription: txtViewDescription.text){
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.addProductSucessfully))
            
                let addVarientVCObj = self.storyboard?.instantiateViewController(withIdentifier: "AddVarientVC") as! AddVarientVC
                self.navigationController?.pushViewController(addVarientVCObj, animated: true)
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension AddCategoryVC:UICollectionViewDataSource, UICollectionViewDelegate{
    
    //MARK:- collectionView delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if objSelectCategoryViewModel.imagesArray.count == 0
        {
            return 1
        }else{
            
            return objSelectCategoryViewModel.imagesArray.count+1
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImagesCVC", for: indexPath) as! ProductImagesCVC
        cell.lblAddImage.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.AddPhoto)
        
        if indexPath.row == 0 {
            cell.imgViewCamera.isHidden=false
            cell.lblAddImage.isHidden = false
            cell.crossBtn.isHidden = true
            cell.imgViewCell.isHidden = true
        }else{
            cell.imgViewCamera.isHidden=true
            cell.lblAddImage.isHidden = true
            cell.crossBtn.isHidden = false
            cell.crossBtn.backgroundColor = .clear
            cell.imgViewCell.isHidden = false
            cell.crossBtn.addTarget(self, action: #selector(deleteImage(_:)), for: .touchUpInside)
            cell.imgViewCell.image = objSelectCategoryViewModel.imagesArray[indexPath.row-1]
            
        }
        return cell
    }
    @objc func deleteImage(_ sender:UIButton)
    {
        objSelectCategoryViewModel.imagesArray.remove(at: sender.tag)
        collViewProductImages.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return self.collViewProductImages.frame.size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            selectMultipleImageObj.customActionSheet()
        }
    }
    
    
    
    
    
}


