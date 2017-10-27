//
//  PeopleBank.swift
//  PPal
//
//  Created by Harry Gong on 10/20/17.
//  Modified by rclui on 10/26/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation
class PeopleBank{
    
    private var people = [Person]()
    
    /**
     Sorts the people list in alphabetical order by first name, and then by last name.
     */
    private func sort() {
        people.sort { (lhs, rhs) -> Bool in
            if lhs.getName().firstName < rhs.getName().firstName {
                return true
            }
            if lhs.getName().firstName == rhs.getName().firstName && lhs.getName().lastName < rhs.getName().lastName {
                return true
            }
            return false
        }
    }
    
    /**
     Add a person to the list.
     - parameter person: The Person to add.
     - returns: true or false
         - True if the person was successfully added.
         - False if the user is not valid, or already exists in the list.
     */
    func add(person: Person) -> Bool {
        // Check if this person is valid as per requirements.
        if !person.valid {
            return false
        }
        
        // Check to see if this person is already in the list.
        if people.contains(person) {
            return false
        }
        
        // If this person doesn't exist, add this person to the list and sort alphabetically.
        people.append(person)
        self.sort()
        
        return true
    }
    
    /**
     Remove a person from the list.
     - parameter person: The Person to remove.
     - returns: true or false
         - True if the person was successfully removed.
         - False if the person was not removed.  This is because the person is not in the list.
     */
    func del(person: Person) -> Bool {
        // Check to see if this person is on the list.
        if !people.contains(person) {
            return false
        }
        let indexToRemove = people.index(of: person)
        people.remove(at: indexToRemove!)
        
        return true
    }
    
//   // func getlist() -> [People]//[people]
//    func getcount() -> Int{} //int

}

