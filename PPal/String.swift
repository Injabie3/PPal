//
//  String.swift
//  PPal
//
//  Created by rclui on 10/25/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation

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
            let validPhoneNumberCharacters = CharacterSet(charactersIn: "-+1234567890")
            return self.rangeOfCharacter(from: validPhoneNumberCharacters.inverted) == nil
        }
    }
}
