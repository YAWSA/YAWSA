//
//  ProfileViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 16/03/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit
import MessageUI


class ProfileViewModel: NSObject {
    
}

//MARK:- Extension Class
extension ProfileVC : UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate {
    
    
    //MARK:-  TableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPersonalDetailArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTVC") as! ProfileTVC
        cell.lblUserDetails.text = userPersonalDetailArr[indexPath.row].0
        cell.imgVwDrawer?.image = userPersonalDetailArr[indexPath.row].1
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    //MARK:- TableView Delegate Method
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch  indexPath.row {
        case 0:
            Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.mainStoryboard, identifier: "OrderHistoryVC", isAnimate: true, currentViewController: self)
        case 1:
            Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.mainStoryboard, identifier: "MyDetailsVCCustomer", isAnimate: true, currentViewController: self)
        case 2:
            let prouductListVCCustomerObj = self.storyboard?.instantiateViewController(withIdentifier: "ProuductListVCCustomer") as! ProuductListVCCustomer
            prouductListVCCustomerObj.isFromController = "ProfileVC"; self.navigationController?.pushViewController(prouductListVCCustomerObj, animated: true)
        case 3:
            Proxy.shared.pushToNextVC(storyborad: StoryboardChnage.mainStoryboard, identifier: "ChangePasswordVCCustomer", isAnimate: true, currentViewController: self)
        case 4:
            if KAppDelegate.profileDetailCustomer.isVendor == 1 {
                switchToVendor ()
            }else {
            Proxy.shared.pushToNextVC(storyborad:StoryboardChnage.mainStoryboard, identifier: "SwitchToVendorVC", isAnimate: true, currentViewController: self)
            }
        case 5:
         customActionSheetLanguage()
        case 6:
        Proxy.shared.pushToNextVC(storyborad:StoryboardChnage.mainStoryboard, identifier: "HelpVCCustomer", isAnimate: true, currentViewController: self)
            
        case 7:
               customActionSheet ()
        case 8 :
              Proxy.shared.logout()
        default:
            break
    }
 }
    func customActionSheetLanguage() {
        let myActionSheet = UIAlertController(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.selectLanguage), message: "", preferredStyle: .actionSheet)
        
        let englishAction = UIAlertAction(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.english), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            UserDefaults.standard.set("0", forKey: "LanguageSelect")
            UserDefaults.standard.synchronize()
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            
            RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "HomeVC")
        })
        let otherAction = UIAlertAction(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.Other), style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            UserDefaults.standard.set("1", forKey: "LanguageSelect")
            UserDefaults.standard.synchronize()
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            RootControllerProxy.shared.rootWithDrawer(StoryboardChnage.mainStoryboard, identifier: "HomeVC")
            
        })
        
        let cancelAction = UIAlertAction(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.cancel), style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        myActionSheet.addAction(englishAction)
        myActionSheet.addAction(otherAction)
        myActionSheet.addAction(cancelAction)
        KAppDelegate.window?.currentViewController()?.present(myActionSheet, animated: true, completion: nil)
    }
    // MARK:- Add Brand Api Interaction
    func switchToVendor() {
        let param = [
            "User[role_id]" : "\(Role.RollVendor)" ,
            ] as [String:AnyObject]
        WebServiceProxy.shared.postData("\(Apis.KServerUrl)\(Apis.KSwitchUser)", params: param, showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let detailDict = JSON["detail"] as? NSDictionary {
                    KAppDelegate.profileDetaiVendor.userDict(dict: detailDict)
                }
                RootControllerProxy.shared.rootWithoutDrawer(StoryboardChnage.vendorStoryboard, identifier: "CategoryVC")
                
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.loginsuccesfully))
                
            } else {
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
        })
    }
    
    
   
    //MARK:- Functon CustomActionSheet
    func customActionSheet() {
        // create an actionSheet
        let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // create an action
        let firstAction: UIAlertAction = UIAlertAction(title:  Proxy.shared.languageSelectedStringForKey(AlertValue.helpImprovetheApp), style: .default) { action -> Void in
            
            let mailComposeViewController = self.configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.present(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }
        
        let secondAction: UIAlertAction = UIAlertAction(title: Proxy.shared.languageSelectedStringForKey(ConstantValue.rateApp), style: .default) { action -> Void in
            Proxy.shared.displayStatusCodeAlert( Proxy.shared.languageSelectedStringForKey(AlertValue.youcangiveratetheappaftertheAppUpload))
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title:   Proxy.shared.languageSelectedStringForKey(ConstantValue.cancel), style: .cancel) { action -> Void in }
        
        // add actions
        actionSheetController.addAction(firstAction)
        actionSheetController.addAction(secondAction)
        actionSheetController.addAction(cancelAction)
        
        // present an actionSheet...
        KAppDelegate.window?.currentViewController()?.present(actionSheetController, animated: true, completion: nil)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([""])
        mailComposerVC.setSubject("")
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        
    let sendMailErrorAlert = UIAlertView(title:  Proxy.shared.languageSelectedStringForKey(ConstantValue.sendEmail), message: Proxy.shared.languageSelectedStringForKey(AlertValue.notSendEmail), delegate: self, cancelButtonTitle: Proxy.shared.languageSelectedStringForKey(ConstantValue.ok))
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
