//
//  MyDetailsVCCustomer.swift
//  YESWA
//
//  Created by Sonu Sharma on 19/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class MyDetailsVCCustomer: UIViewController {
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var txtFieldFirstName: UITextField!
    @IBOutlet weak var txtFieldLastName: UITextField!
    @IBOutlet weak var txtFieldEmail: UITextField!
    @IBOutlet weak var btnSaveChanges: SetCornerButton!
    @IBOutlet weak var btnBack: UIButton!
    
    var objMyDetailsViewModel = MyDetailsVCCustomerViewModel ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    txtFieldFirstName.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.firstName))
    txtFieldLastName.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.lastName))
    txtFieldEmail.setPlaceHolderColor(txtString: Proxy.shared.languageSelectedStringForKey(ConstantValue.Email))
        
    lblHeader.text = Proxy.shared.languageSelectedStringForKey(ConstantValue.myDetails)
        
    btnSaveChanges.setTitle(Proxy.shared.languageSelectedStringForKey(ConstantValue.saveChanges), for: .normal)
        


    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.txtFieldFirstName.text = KAppDelegate.profileDetailCustomer.firstName
        self.txtFieldLastName.text = KAppDelegate.profileDetailCustomer.lastName
         self.txtFieldEmail.text = KAppDelegate.profileDetailCustomer.emailId
        
    }
    
//MARK:- Action Back
    
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    //MARK:- Actoin Save Changes
    @IBAction func actionSaveChange(_ sender: UIButton) {
        
        if txtFieldFirstName.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.firstname))
        }
        else if txtFieldLastName.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.lastName))
        }
        else if txtFieldEmail.text!.isEmpty {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.email))
        }
        else if !Proxy.shared.isValidEmail(txtFieldEmail.trimmedValue) {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.validEmail))
        }else {
            
            objMyDetailsViewModel.firstNameVal = txtFieldFirstName.text!
            objMyDetailsViewModel.lastNameVal = txtFieldLastName.text!
            objMyDetailsViewModel.EmailVal = txtFieldEmail.text!
            
            objMyDetailsViewModel.updateDetails {
        Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.yourDetailsisupdatedsuccesfully))
            
            Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

}
