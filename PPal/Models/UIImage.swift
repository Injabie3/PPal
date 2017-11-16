//
//  UIImage.swift
//  PPal
//
//  Created by rclui on 11/11/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {
    
    /// Converts the UIImage into a Base64 String.
    var toBase64: String {
        get {
            let imageData: NSData = UIImagePNGRepresentation(self)! as NSData
            return imageData.base64EncodedString(options: [])
        }
    }
    
    func resizeImageWith(newSize: CGSize) -> UIImage {
        
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}
