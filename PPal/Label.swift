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
    
    init (name: String) {
        self.name = name
        self.people = []
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
     - returns: true or false
         True if the label name **was changed**.
         False if the label name **could not be changed**.
     */
    func editLabel(name: String) -> Bool {
        if (name == "") {
            return false
        } else {
            self.name = name
            return true
        }
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
