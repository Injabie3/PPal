//
//  PeopleBank.swift
//  PPal
//
//  Created by Harry Gong on 10/20/17.
//  Modified by rclui on 10/26/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation

/**
 The encapsulating class that will hold people and labels, and
 their relationships between each other.
 */
class PeopleBank {
    
    private var people = [Person]()
    private var labels = [Label]()
    
    /**
     If this has no more references, we should clear the references between labels and people,
     and also clear the lists.
     */
    deinit {
        for item in people {
            item.clearAll()
        }
        for item in labels {
            item.clearAll()
        }
        people.removeAll()
        labels.removeAll()
    }
    
    /**
     Sorts the people list in alphabetical order by first name, and then by last name.
     */
    private func sortPeople() {
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
     Sorts the label list in alphabetical order by name.
     */
    private func sortLabels() {
        labels.sort { (lhs, rhs) -> Bool in
            return lhs.getName() < rhs.getName()
        }
    }
    
    /**
     The number of Person(s) in this bank of people.
     */
    var numberOfPeople: Int {
        get {
            return self.people.count
        }
    }
    
    /**
     The number of Label(s) in this bank of people.
     */
    var numberOfLabels: Int {
        get {
            return self.labels.count
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
        
        // Check to see if there is already another Person in the list with the same first and last name.
        // Check to see if there is already a label in the list with the same name.
        if people.contains(where: {
            let inList = $0.getName()
            let toAdd = person.getName()
            return inList.firstName.lowercased() == toAdd.firstName.lowercased() && inList.lastName.lowercased() == toAdd.lastName.lowercased()            
        }) {
            return false
        }
        
        // If this person doesn't exist, add this person to the list and sort alphabetically.
        people.append(person)
        self.sortPeople()
        
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
        
        person.clearAll() // Remove cyclic references to its label.
        let indexToRemove = people.index(of: person)
        people.remove(at: indexToRemove!)
        
        return true
    }
    
    /**
     Add a label to the list.
     - parameter label: The Label to add.
     - returns: true or false
     - True if the label was successfully added.
     - False if the label is not valid, or already exists in the list.
     */
    func add(label: Label) -> Bool {
        // Check if this label is valid as per requirements.
        if !label.valid {
            return false
        }
        
        // Check to see if this label is already in the list.
        if labels.contains(label) {
            return false
        }
        
        // Check to see if there is already a label in the list with the same name.
        if labels.contains(where: { $0.getName() == label.getName() }) {
            return false
        }
        
        
        // If this label doesn't exist in the list, add this label to the list and sort alphabetically.
        labels.append(label)
        self.sortLabels()
        
        return true
    }
    
    /**
     Remove a label from the list.
     - parameter label: The Label to remove.
     - returns: true or false
     - True if the label was successfully removed.
     - False if the label was not removed.  This is because the label is not in the list.
     */
    func del(label: Label) -> Bool {
        // Check to see if this label is on the list.
        if !labels.contains(label) {
            return false
        }
        
        label.clearAll() // Remove cyclic references to its list of people.
        
        let indexToRemove = labels.index(of: label)
        labels.remove(at: indexToRemove!)
        
        return true
    }
    
    /**
     Gets the list of people.
     - returns: An array of Person objects.
     */
    func getPeople() -> [Person] {
        return people
    }
    
    /**
     Gets the list of labels.
     - returns: An array of Label objects.
     */
    func getLabels() -> [Label] {
        return labels
    }

}

