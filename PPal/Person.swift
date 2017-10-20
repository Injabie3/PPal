//
//  Person.swift
//  PPal
//
//  Created by rclui on 10/20/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation
import UIKit

class Person {
    init () {
        self.photo = nil
        //self.labels = []
    }
    
    private var photo: UIImage? // An image of the person. Not sure if we should use UIImage here, probably want a path here.
    private var firstName: String = ""
    private var lastName: String = ""
    private var phoneNumber: String = ""
    private var email: String = ""
    private var address: String = ""
    private var hasHouseKeys: Bool = false
    //private var labels: [Label]
    
    func getName() -> String {
        if (firstName == "" || lastName == "") {
            return ""
        }
        else
        {
            return "\(firstName) \(lastName)"
        }
    }
    
    func setInfo (
        photo: UIImage?,
        firstName: String,
        lastName: String,
        phoneNumber: String,
        email: String,
        address: String,
        hasHouseKeys: Bool
        //labels: [Labels]
        ) -> Bool {
        
        //Do error checking here.
        if (photo == nil || firstName == "" || lastName == "" || phoneNumber == "") {
            return false
        }
        else {
            self.photo = photo
            self.firstName = firstName
            self.lastName = lastName
            self.phoneNumber = phoneNumber
            self.email = email
            self.address = address
            self.hasHouseKeys = hasHouseKeys
            return true
        }
        
    }
    
    func getInfo() -> (
        photo: UIImage,firstName: String, lastName: String, phoneNumber: String, email: String, address: String, hasHouseKeys: Bool) {
            return (self.photo!, self.firstName, self.lastName, self.phoneNumber, self.email, self.address, self.hasHouseKeys)
    }
    
}

