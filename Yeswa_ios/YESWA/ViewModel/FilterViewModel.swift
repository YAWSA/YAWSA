//
//  FilterViewModel.swift
//  YESWA
//
//  Created by Sonu Sharma on 06/07/18.
//  Copyright © 2018 Sonu Sharma. All rights reserved.
//

import Foundation
import UIKit
class FilterViewModel: NSObject {
    

    func appendParam(arr : [AddVarientColorModel], appendFor:String)-> String{
        var keyStr = String()
        var colorIds = String()
        for i in 0 ..< arr.count  {
            if appendFor == "title"{
                keyStr = "\(arr[i].title)"
                
            }else{
                keyStr = "\(arr[i].Id)"

            }
            if colorIds.contains(keyStr){
                //Already in array
            }else{
                
                if colorIds.count > 0 {
                    colorIds = "\(colorIds),\(keyStr)"
                } else{
                    colorIds = "\(keyStr)"
                }
            }
        }
        return colorIds
    }
    
    func appendParam(arr : [BrandListModel], appendFor:String)-> String{
        var keyStr = String()
        var brandIds = String()
        for i in 0 ..< arr.count  {
            if appendFor == "title"{
                keyStr = "\(arr[i].title!)"
                
            }else{
                keyStr = "\(arr[i].brandId!)"
                
            }
            if brandIds.contains(keyStr){
                //Already in array
            }else{
                
                if brandIds.count > 0 {
                    brandIds = "\(brandIds),\(keyStr)"
                } else{
                    brandIds = "\(keyStr)"
                }
            }
        }
        
        return brandIds
    }
    func appendParam(arr : [AddVarientSizeModel], appendFor:String)-> String{
        var keyStr = String()
        var sizeIds = String()
        for i in 0 ..< arr.count  {
            if appendFor == "title"{
                keyStr = "\(arr[i].title)"
                
            }else{
                keyStr = "\(arr[i].Id)"
                
            }
            if sizeIds.contains(keyStr){
                //Already in array
            }else{
                
                if sizeIds.count > 0 {
                    sizeIds = "\(sizeIds),\(keyStr)"
                } else{
                    sizeIds = "\(keyStr)"
                }
            }
        }
        
        return sizeIds
    }
    
    
    
}







