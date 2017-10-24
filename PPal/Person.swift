//
//  Person.swift
//  PPal
//
//  Created by rclui on 10/20/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation

class Person {
    
    init () {
        self.labels = []
    }
    
    init (pathToPhoto photo: String,
          firstName: String,
          lastName: String,
          phoneNumber: String,
          labels: [Label]) {
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
    var validate: Bool {
        get {
            //Do error checking here.
            if (photo == "" || firstName == "" || lastName == "" || phoneNumber == "") {
                return false
            }
                // Check if the phone number is valid.
            else if (phoneNumber == "" || phoneNumber.rangeOfCharacter(from: validPhoneNumberCharacters.inverted) != nil) {
                return false
            }
            else if (email != "" && email.rangeOfCharacter(from: CharacterSet(charactersIn: "@")) == nil ) {
                return false;
            } else {
                return true
            }
        }
    }
    
    // Helpers
    /// The valid characters in a phone number.
    private let validPhoneNumberCharacters = CharacterSet(charactersIn: "-+1234567890")
    
    /**
     Gets a Person's first and last name.
     
     - returns:
         A tuple with the following:
         - firstName: The first name of the Person.
         - lastName: The last name of the Person.
     */
    func getName() -> (String, String) {
        return (firstName, lastName)
    }
    
    /**
     Sets the info for a Person.
     
     Returns true and sets informations provided if there is valid information for photo,
     firstName, lastName and phoneNumber, and the below conditions are true:
     - phoneNumber must be integers, +, - only.
     - email contains @ symbol somewhere.
     Returns false if the above is not satisfied, and do not set anything.
     
     - parameters:
         - pathToPhoto: The path to the photo of the person. Cannot be empty.
         - firstName: The first name of the person. Cannot be empty.
         - lastName: The last name of the person. Cannot be empty.
         - phoneNumber: The phone number of the person.  Can only contain numbers and + - symbols. Cannot be empty.
         - email: The email of the person. Must contain the @ symbol somewhere. May be empty.
         - address: The home address of the person.  May be empty.
         - hasHouseKeys: Indicates if the person has knowledge of the AD patient's house keys.  True for **yes**, false for **no**.
         - labels: An array of Label that the user is associated with.
     
     - returns: true or false
    */
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
        
        //Do error checking here.
        if (photo == "" || firstName == "" || lastName == "" || phoneNumber == "") {
            return false
        }
        // Check if the phone number is valid.
        else if (phoneNumber == "" || phoneNumber.rangeOfCharacter(from: validPhoneNumberCharacters.inverted) != nil) {
            return false
        }
        else if (email != "" && email.rangeOfCharacter(from: CharacterSet(charactersIn: "@")) == nil ) {
            return false;
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
    
    /**
     Gets all the information about a Person.
     
     - returns:
         A tuple with the following:
         - pathToPhoto: The path to the photo of the person. Cannot be empty.
         - firstName: The first name of the person. Cannot be empty.
         - lastName: The last name of the person. Cannot be empty.
         - phoneNumber: The phone number of the person.  Can only contain numbers and + - symbols. Cannot be empty.
         - email: The email of the person. Must contain the @ symbol somewhere. May be empty.
         - address: The home address of the person.  May be empty.
         - hasHouseKeys: Indicates if the person has knowledge of the AD patient's house keys.  True for **yes**, false for **no**.
         - labels: An array of Label that the user is associated with.
     */
    func getInfo() -> (
        pathToPhoto: String,
        firstName: String,
        lastName: String,
        phoneNumber: String,
        email: String,
        address: String,
        hasHouseKeys: Bool,
        labels: [Label]) {
            return (self.photo, self.firstName, self.lastName, self.phoneNumber, self.email, self.address, self.hasHouseKeys, self.labels)
    }
    
}

