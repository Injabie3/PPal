//
//  Label.swift
//  PPal
//
//  Created by rclui on 10/24/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation

class Label {
    var name: String // The name of the label.
    var people: [Person] // An array of Person that have this label.
    static private var names: [String] = []
    
    init () {
        self.name = ""
        self.people = []
    }
    
    deinit {
        // Make sure to get rid of the name on the list.
        let index = Label.names.index(of: self.name)
        if let indexToRemove = index {
            Label.names.remove(at: indexToRemove)
        }
    }
    
    /**
     Gets a list of Person(s) associated with the label.
     
     -returns: Array of Person(s)
     */
    func getPeople() -> [Person] {
        return self.people
    }
    
    /**
     Edit the Label name.
     
     - parameter name: The name of the label.  Cannot be blank.
     - get: true or false
         - True if the label name **was changed**.
         - False if the label name **could not be changed**.
             This can be due to an existing label already having the same name,
             or the name supplied is blank.
     */
    func editLabel(name: String) -> Bool {
        if (name == "") {
            return false
        }
        
        // See if the name to change to is already being used by another label,
        // and if it is, refuse the change.
        let indexOfExistingName = Label.names.index(of: name)
        
        if indexOfExistingName == nil {
            // If this name doesn't exist, remove the previous name from the list, and add the new one to the list.
            if self.name != "" {
                let indexOfPreviousName = Label.names.index(of: self.name)
                
                // Optional protection to avoid crashing.
                if indexOfPreviousName != nil {
                     Label.names.remove(at: indexOfPreviousName!)
                }
            }
            self.name = name
            Label.names.append(name)
            return true
        } else {
            return false
        }
    }
    
    /**
     Associate a person with this label.
     THIS SHOULD ONLY BE INVOKED BY A PERSON OBJECT! DO NOT INVOKE
     THIS OUTSIDE OF THE PERSON CLASS.
     
     - parameter person: Person to associate with the label.
     - returns: true or false
         - True if the person was added.
         - False if the person already exists in this list.
    */
    func add(person: Person) -> Bool {
        let indexOfExistingPerson = self.people.index(of: person)
    
        // Check to see if this person already has this label.
        if indexOfExistingPerson != nil {
            return false
        }
        else {
            self.people.append(person)
            return true
        }

    }
    
}
