//
//  HelpVCVendor.swift
//  YESWA
//
//  Created by Ankita Thakur on 30/04/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import UIKit

class HelpVCVendor: UIViewController {
    @IBOutlet weak var lblHeader: UILabel!
  @IBOutlet weak var webVwHelpSupport: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchHelpData()

    }
    
    //MARK:- Action Back---
    @IBAction func actionBack(_ sender: UIButton) {
        Proxy.shared.popToBackVC(isAnimate: true, currentViewController: self)
    }
    //MARK:- Function  FETCH Help Data
    func fetchHelpData() {
        WebServiceProxy.shared.getData("\(Apis.KServerUrl)\(Apis.KHelpsupport)?type=\(HelpType.TYPE_HELP)", showIndicator: true, completion: { (JSON) in
            if JSON["status"] as! Int == 200 {
                if let termsDict = JSON["detail"]as? NSDictionary {
                    if let description = termsDict["description"] {
                        self.webVwHelpSupport.loadHTMLString(description as! String , baseURL: nil)
                    }
                }
            } else {
                if let error = JSON["error"] as? String {
                    Proxy.shared.displayStatusCodeAlert(error)
                }
            }
            Proxy.shared.hideActivityIndicator()
        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
