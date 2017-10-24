//
//  Person.swift
//  PPal
//
//  Created by rclui on 10/20/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation



class Label {
    var name: String // The name of the label.
    var people: [Person] // An array of Person that have this label.
    
    init (name: String) {
        self.name = name
        self.people = []
    }
    
    func getPeople() -> [Person] {
        return self.people
    }
    
    // Add a person to a label.
    // Returns:
    // True if person was added.
    // False if person is already assigned this label.
//    func add(person: Person) -> Bool {
//        if self.people.contains(where: person) {
//            return false
//        }
//        else {
//            self.people.append(person)
//        }
//        
//    }
    
}

class Person {
    init () {
        self.labels = []
    }
    
    private var photo: String = "" // An image of the person. Not sure if we should use UIImage here, probably want a path here.
    private var firstName: String = "" // The first name of the person.
    private var lastName: String = "" // The last name of the person.
    private var phoneNumber: String = "" // The phone number of the person.
    private var email: String = "" // The email address.
    private var address: String = "" // The house address.
    private var hasHouseKeys: Bool = false // Does this person have keys for the AD patient?
    private var labels: [Label]
    
    func getName() -> (String, String) {
        if (firstName == "" || lastName == "") {
            return ("", "")
        }
        else
        {
            return (firstName, lastName)
        }
    }
    
    // Sets the info for a Person
    // Returns true if there is valid information for photo, firstName, lastName and phoneNumber,
    // and sets all fields.
    // - phoneNumber must be integers, +, - only.
    // Returns false if the above is not satisfied, and do not set anything.
    func setInfo (
        pathToPhoto photo: String,
        firstName: String,
        lastName: String,
        phoneNumber: String,
        email: String,
        address: String,
        hasHouseKeys: Bool,
        labels: [Label]
        ) -> Bool {
        
        let validPhoneNumberCharacters = CharacterSet(charactersIn: "-+1234567890")
        //Do error checking here.
        if (photo == "" || firstName == "" || lastName == "" || phoneNumber == "") {
            return false
        }
        // Check if the phone number is valid.
        else if (phoneNumber == "" || phoneNumber.rangeOfCharacter(from: validPhoneNumberCharacters) != nil) {
            return false
        } else {
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
        pathToPhoto: String,firstName: String, lastName: String, phoneNumber: String, email: String, address: String, hasHouseKeys: Bool) {
            return (self.photo, self.firstName, self.lastName, self.phoneNumber, self.email, self.address, self.hasHouseKeys)
    }
    
}

