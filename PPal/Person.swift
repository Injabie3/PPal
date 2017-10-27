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
    
    private var id: Int = 0 // This holds the ID of the person.  To be used with the database.
    private var photo: String = "" // An image of the person. Not sure if we should use UIImage here, probably want a path here.
    private var firstName: String = "" // The first name of the person. Must not be empty as per requirements.
    private var lastName: String = "" // The last name of the person. Must not be empty as per requirements.
    private var phoneNumber: String = "" // The phone number of the person. Must not be empty as per requirements.
    private var email: String = "" // The email address.
    private var address: String = "" // The house address.
    private var hasHouseKeys: Bool = false // Does this person have keys for the AD patient?
    private var labels: [Label] // An array of Labels associated with the person.
    
    private var hasMaxLabels: Bool {
        get {
            return labels.count >= 10 // As per Profile requirements.
        }
    }
    
    var valid: Bool {
        get {
            //Do error checking here.
            if (photo == "" || firstName == "" || lastName == "" || phoneNumber == "") {
                return false
            }
            // Check if the phone number is valid.
            else if (!phoneNumber.isValidPhoneNumber) {
                return false
            }
            // Check if the email is valid.
            else if (email != "" && !email.isValidEmail) {
                return false
            }
            // Check if the person has at least one label.
            else if (labels.count == 0) {
                return false
            } else {
                return true
            }
        }
    }
    
    /**
     Gets a Person's first and last name.
     
     - returns:
         A tuple with the following:
         - firstName: The first name of the Person.
         - lastName: The last name of the Person.
     */
    func getName() -> (firstName: String, lastName: String) {
        return (firstName, lastName)
    }
    
    /**
     Gets a Person's phone number.
     
     - returns: String
     */
    func getPhoneNumber() -> String {
        return phoneNumber
    }
    
    
    
    /**
     Associates a Label with a Person.
     
     - parameter label: A Label.
     - returns:
     - True if the label was successfully added.
     - False if the label could not be added.
     This can be due to the label already existing in the list,
     or due to the fact that the person has the maximum number of labels.
     */
    @discardableResult
    func add(label: Label) -> Bool {
        if self.hasMaxLabels {
            return false
        }
        
        // Check to see if the label exists in the list.
        for listItem in self.labels {
            if listItem == label {
                return false
            }
        }
        
        // Check to see if the label has a blank name.
        if label.getName() == "" {
            return false
        }
        
        // Check to see if we can add this Person to the label, if not
        // return false
        if !label.add(person: self) {
            return false
        }
        
        // We've made it this far, so we can safely add the label, and return true.
        self.labels.append(label)
        return true
    }
    
    /**
     Delete/disassociates a Label with a Person.
     
     - parameter label: A Label.
     - returns:
     - True if the label was successfully deleted from this person.
     - False if the label could not be deleted.
         This can be due to the label not associated with this person.
     */
    @discardableResult
    func del(label: Label) -> Bool {
        
        // Check to see if the label is associated with this person.
        // If not, return false.
        let indexToRemove = self.labels.index(of: label)
        
        if indexToRemove == nil {
            return false
        }
        
        // Try to remove this person from the label, if not
        // return false
        if !label.del(person: self) {
            return false
        }
        
        // We've made it this far, so we can safely remove the label, and return true.
        self.labels.remove(at: indexToRemove!)
        return true
        
        
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
        hasHouseKeys: Bool
        ) -> Bool {
        
        //Do error checking here.
        if (photo == "" || firstName == "" || lastName == "" || phoneNumber == "") {
            return false
        }
        // Check if the phone number is valid.
        else if (!phoneNumber.isValidPhoneNumber) {
            return false
        }
        // Check if the email is valid.
        else if (email != "" && !email.isValidEmail ) {
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

extension Person: Equatable {
    /**
     Defines the equality operator to signify what is meant by
     having two Person objects being "equivalent"
     
     Referenced: https://developer.apple.com/documentation/swift/equatable
     */
    static func == (lhs: Person, rhs: Person) -> Bool {
        let lhsInfo = lhs.getInfo()
        let rhsInfo = rhs.getInfo()
        return
            lhsInfo.pathToPhoto == rhsInfo.pathToPhoto &&
            lhsInfo.firstName == rhsInfo.firstName &&
            lhsInfo.lastName == rhsInfo.lastName &&
            lhsInfo.phoneNumber == rhsInfo.phoneNumber &&
            lhsInfo.email == rhsInfo.email &&
            lhsInfo.hasHouseKeys == rhsInfo.hasHouseKeys
    }
}
