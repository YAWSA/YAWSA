//
//  Extensions.swift
//  kaboky
//
//  Created by Himanshu Singla on 11/04/17.
//  Copyright © 2017 ToXSL Technologies Pvt. Ltd. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
//MARK: REMOVE HTML TAGS
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }}


extension UITextField {
//    var isBlank : Bool {
//        return (self.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)!
//    }
//    var trimmedValue : String {
//        return (self.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
//    }
    func rightImage(image:UIImage,imgW:Int,imgH:Int)  {
        self.rightViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imgW, height: imgH))
        imageView.image = image
        self.rightView = imageView
    }
    
    func leftImage(image:UIImage,imgW:Int,imgH:Int)  {
        self.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imgW, height: imgH))
        imageView.image = image
        self.leftView = imageView
    }
    func setPlaceHolderColor(txtString: String){
        self.attributedPlaceholder = NSAttributedString(string: txtString, attributes: [NSAttributedStringKey.foregroundColor :UIColor.gray])
        
    }
    func trimWhiteSpace(textfield:UITextField) -> Bool  {
        let str = textfield.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0
        return str
    }
    func trimWhiteSpaceTxtVw(textView:UITextView) -> Bool  {
        let str = textView.text?.trimmingCharacters(in: .whitespacesAndNewlines).count == 0
        return str
    }
}
extension UIView {
    func showAnimations(_ completion: ((Bool) -> Swift.Void)? = nil) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.layoutIfNeeded()
            self.layoutSubviews()
        }, completion: completion)
    }
}


extension GMSMapView {
    func setRegion(sourceLocation: CLLocationCoordinate2D, zoomLevel : Float = 14.0)  {
        let camera = GMSCameraPosition.camera(withLatitude: sourceLocation.latitude, longitude: sourceLocation.longitude, zoom: zoomLevel)
        self.camera = camera
    }
}

extension UITableView {
    func animate( ) {
        let cells = self.visibleCells
        let tableHeight: CGFloat = self.bounds.size.height
        for i in cells {
            let cell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        var index = 0
        for a in cells {
            let cell = a as UITableViewCell
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .allowAnimatedContent, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            index += 1
        }
    }
}

extension String {
    var isNumeric: Bool {
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    var isValidName : Bool {
        let emailRegEx = "^[a-zA-ZàáâäãåąčćęèéêëėįìíîïłńòóôöõøùúûüųūÿýżźñçčšžÀÁÂÄÃÅĄĆČĖĘÈÉÊËÌÍÎÏĮŁŃÒÓÔÖÕØÙÚÛÜŲŪŸÝŻŹÑßÇŒÆČŠŽ∂ð ,.'-]+$"
        let range = self.range(of: emailRegEx, options:.regularExpression)
        return range != nil ? true : false
    }
}

extension UIImageView {
    func convertToHexagon() {
        let path = roundedPolygonPath(self.bounds, lineWidth: 2, sides: 6, cornerRadius: 0, rotationOffset: CGFloat(Double.pi))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.lineWidth = 1
        mask.strokeColor = UIColor.clear.cgColor
        mask.fillColor = UIColor.white.cgColor
        self.layer.mask = mask
        
        let border = CAShapeLayer()
        border.path = path.cgPath
        border.lineWidth = 1
        border.strokeColor = UIColor.white.cgColor
        border.fillColor = UIColor.clear.cgColor
        self.layer.addSublayer(border)
    }
    
    fileprivate func roundedPolygonPath(_ rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat, rotationOffset: CGFloat = 0)
        -> UIBezierPath {
            let path = UIBezierPath()
            let theta: CGFloat = CGFloat(2.0 * Double.pi) / CGFloat(sides)
            let width = min(rect.size.width, rect.size.height)
            
            let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
            let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0
            var angle = CGFloat(rotationOffset)
            let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
            path.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))
            for _ in 0 ..< sides {
                angle += theta
                let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
                let tip = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
                let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
                let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
                path.addLine(to: start)
                path.addQuadCurve(to: end, controlPoint: tip)
            }
            path.close()
            let bounds = path.bounds
            let transform = CGAffineTransform(translationX: -bounds.origin.x + rect.origin.x + lineWidth / 2.0,
                                              y: -bounds.origin.y + rect.origin.y + lineWidth / 2.0)
            path.apply(transform)
            return path
    }
}
