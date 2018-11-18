//
//  HelpVCCustomer.swift
//  YESWA
//
//  Created by Ankita Thakur on 30/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit
import MessageUI

class HelpVCCustomer: UIViewController,MFMailComposeViewControllerDelegate {
   @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblContactTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
     lblHeader.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.help)
        lblContactTitle.text =  Proxy.shared.languageSelectedStringForKey(ConstantValue.canContact)
    }
    //MARK:- Button Actions -
    @IBAction func actionBtnCall(_ sender: UIButton) {
        callNumber("+965 6508 2227")
      
    }
    // MARK:- Actions
    @IBAction func actionBtnEmail(_ sender: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
        
    }
    
   
    @IBAction func actionBtnTwitter(_ sender: UIButton) {
         openUrl(urlStr: "https://mobile.twitter.com/yeswaapp/")
    }
    
    @IBAction func actionBtnInstagram(_ sender: UIButton) {
        
       openUrl(urlStr: "https://www.instagram.com/yeswaapp/")
    }
    //MARK:- Action Back---
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["Yeswaapplication@gmail.com"])
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
    
    
    func callNumber( _ numberString: String)  {
        
        let convert_mobile_string = numberString.replacingOccurrences(of: " ", with: "")
        let url:URL = URL(string: "tel://\(convert_mobile_string)")!
        if(UIApplication.shared.canOpenURL(url)) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: {
                    (success) in
                })
            } else {
                if UIApplication.shared.openURL(url) {
                } else {
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.notConnect))
            
                }
            }
        } else {
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.notConnect))
        }
    }
    //MARK: - Function Add HyperLink
    func openUrl(urlStr:String!) {
        
        if let url = NSURL(string:urlStr) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
