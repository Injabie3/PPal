//
//  String.swift
//  PPal
//
//  Created by rclui on 10/25/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation
import UIKit

public extension String {
    
    /**
     Verifies if the email is valid.
     This property gives:
     - True if email is valid.
     - False if email is invalid.
     */
    var isValidEmail: Bool {
        get {
            let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
            return emailPredicate.evaluate(with: self)
        }
    }
    
    /**
     Verifies if the phone number is a valid one.
     This property gives:
     - True if the phone number is valid.
     - false if the phone number is invalid.
     */
    var isValidPhoneNumber: Bool {
        get {
            let validPhoneNumberCharacters = CharacterSet(charactersIn: "-()+1234567890").union(CharacterSet.whitespaces)
            return self.rangeOfCharacter(from: validPhoneNumberCharacters.inverted) == nil
        }
    }
    
    /// Assumes a base64 encoded image, and converts this into a UIImage
    /// May throw an error if this is not a base64 image.
    var toImage: UIImage {
        get {
            let dataDecoded: NSData = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))!
            return UIImage(data: dataDecoded as Data)!
        }
    }
    
}
