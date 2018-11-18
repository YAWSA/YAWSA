//
//  WebServiceProxy.swift
//  Foosto
//
//  Created by Sukhpreet Kaur on 3/10/18.
//  Copyright © 2018 Sukhpreet Kaur. All rights reserved.
//
 
 import Foundation
 import Alamofire
 
 
 class WebServiceProxy {
    static var shared: WebServiceProxy {
        return WebServiceProxy()
    }
    
    fileprivate init(){}
    //MARKK:- API Interaction
    func postData(_ urlStr: String, params: Dictionary<String, AnyObject>? = nil, showIndicator: Bool, completion: @escaping (_ response: NSDictionary) -> Void) {
        if NetworkReachabilityManager()!.isReachable {
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
            request(urlStr, method: .post, parameters: params, encoding: URLEncoding.httpBody, headers:["auth_code": "\(Proxy.shared.authNil())","User-Agent":"\(AppInfo.UserAgent)"])
                .responseJSON { response in
                    Proxy.shared.hideActivityIndicator()
                    if response.data != nil && response.result.error == nil {
                        if response.response?.statusCode == 200 {
                            if let JSON = response.result.value as? NSDictionary {
                                completion(JSON)
                            } else {
                                Proxy.shared.hideActivityIndicator()
                                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.ErrorUnabletoencodeJSONResponse))
                            }
                        } else {
                            if response.data != nil{
                                debugPrint(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)!)
                            }
                            self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                        }
                    } else {
                        if response.data != nil{
                            debugPrint(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)!)
                        }
                        self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                    }
            }
        } else {
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.openSettingApp()
        }
    }
    
    func getData(_ urlStr: String, showIndicator: Bool, completion: @escaping (_ responseDict: NSDictionary) -> Void) {
        if NetworkReachabilityManager()!.isReachable {
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
            debugPrint("URL: ",urlStr)
            request(urlStr, method: .get, parameters: nil, encoding: JSONEncoding.default, headers:["auth_code": "\(Proxy.shared.authNil())","User-Agent":"\(AppInfo.UserAgent)"])
                .responseJSON { response in
                    Proxy.shared.hideActivityIndicator()
                    if response.data != nil && response.result.error == nil {
                        if response.response?.statusCode == 200 {
                            if let JSON = response.result.value as? NSDictionary {
                                debugPrint("JSON", JSON)
                                completion(JSON)
                            } else {
                                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.ErrorUnabletoencodeJSONResponse))
                            }
                        } else {
                            if response.data != nil{
                                debugPrint(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)!)
                            }
                            self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                        }
                    } else {
                        if response.data != nil{
                            debugPrint(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)!)
                        }
                        self.statusHandler(response.response, data: response.data, error: response.result.error as NSError?)
                    }
            }
        } else {
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.openSettingApp()
        }
    }
    // MARK: - Error Handling
    func statusHandler(_ response:HTTPURLResponse? , data:Data?, error:NSError?) {
        if let code = response?.statusCode {
            switch code {
            case 400:
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.urlError))
            case 401:
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.UnauthorizedactionError))
            case 403:
                UserDefaults.standard.set("", forKey: "auth_code")
                UserDefaults.standard.synchronize()
                 Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.sessionError))
                RootControllerProxy.shared.rootWithoutDrawer(StoryboardChnage.mainStoryboard, identifier: "SelectRoleVC")
                
            case 404:
                Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.urlNotExist))
            case 500:
                let myHTMLString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                Proxy.shared.displayStatusCodeAlert(myHTMLString as String)
           
            case 408:
            Proxy.shared.displayStatusCodeAlert(Proxy.shared.languageSelectedStringForKey(AlertValue.serverError))
            default:
                let myHTMLString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
                Proxy.shared.displayStatusCodeAlert(myHTMLString as String)
                
            }
        } else {
            let myHTMLString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!
            Proxy.shared.displayStatusCodeAlert(myHTMLString as String)
           
        }
        
        if let errorCode = error?.code {
            switch errorCode {
            default:
                break
                
            }
        }
    }
    func uploadImage(_ parameters:[String:AnyObject],parametersImage:[String:UIImage],addImageUrl:String, showIndicator: Bool, completion:@escaping (_ completed: NSDictionary) -> Void){
        
        if NetworkReachabilityManager()!.isReachable {
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
            debugPrint("URL: ",addImageUrl)
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    for (key, val) in parameters {
                        multipartFormData.append(val.data(using: String.Encoding.utf8.rawValue)!, withName: key)
                    }
                    for (key, val) in parametersImage {
                        let timeStamp = Date().timeIntervalSince1970 * 1000
                        let fileName = "image\(timeStamp).png"
                        guard let imageData = UIImageJPEGRepresentation(val, 0.5)
                            else {
                                return
                        }
                        multipartFormData.append(imageData, withName: key, fileName: fileName , mimeType: "image/png")
                    }
            },
                to: addImageUrl,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.validate()
                        upload.responseJSON { response in
                            guard response.result.isSuccess else {
                                Proxy.shared.hideActivityIndicator()
                                return
                            }
                            Proxy.shared.hideActivityIndicator()
                            if let responseJSON = response.result.value as? NSDictionary{
                                completion(responseJSON)
                            }
                        }
                        
                    case .failure(let errorcoding):
                        debugPrint(errorcoding)
                        break
                    }
               }
            )
            
        } else {
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.openSettingApp()
        }
    }
    
    func uploadImageWithImage(parametersImage:[String:UIImage],addImageUrl:String, showIndicator: Bool, completion:@escaping (_ completed: NSDictionary) -> Void){
        
        if NetworkReachabilityManager()!.isReachable {
            if showIndicator {
                Proxy.shared.showActivityIndicator()
            }
            debugPrint("URL: ",addImageUrl)
            Alamofire.upload(
                multipartFormData: { multipartFormData in
//                    for (key, val) in parameters {
//                        multipartFormData.append(val.data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                    }
                    
                    for (key, val) in parametersImage {
                        let timeStamp = Date().timeIntervalSince1970 * 1000
                        let fileName = "image\(timeStamp).png"
                        guard let imageData = UIImageJPEGRepresentation(val, 0.5)
                            else {
                                return
                        }
                        multipartFormData.append(imageData, withName: key, fileName: fileName , mimeType: "image/png")
                        
                        
                    }
                    
            },
                to: addImageUrl,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.validate()
                        upload.responseJSON { response in
                            guard response.result.isSuccess else {
                                return
                            }
                            Proxy.shared.hideActivityIndicator()
                            if let responseJSON = response.result.value as? NSDictionary{
                                completion(responseJSON)
                            }
                        }
                        
                    case .failure(let errorcoding):
                        debugPrint(errorcoding)
                        break
                    }
            }
            )
            
        } else {
            Proxy.shared.hideActivityIndicator()
            Proxy.shared.openSettingApp()
        }
    }
    
    
    func HtmlDisplayStatusAlert(userMessage: String)
    {
//        let pushControllerObj = storyboardObj?.instantiateViewController(withIdentifier: "HtmlViewController") as! HtmlViewController
//        pushControllerObj.HtmlSting = userMessage
//        KAppDelegate.window?.currentViewController()?.navigationController?.pushViewController(pushControllerObj, animated: true)
    }
    
 }
