//
//  Label.swift
//  PPal
//
//  Created by rclui on 10/24/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation

class Label {
    private var id: Int // The id for the database.
    private var name: String // The name of the label.
    private var people: [Person] // An array of Person that have this label.
    static private var names: [String] = [] // An array that contains the currently used names.
    
    init?(name: String) {
        
        if Label.names.contains(name) {
            return nil
        }
        Label.names.append(name)
        self.id = 0
        self.name = name
        self.people = []
    }
    
    init() {
        self.id = 0
        self.name = ""
        self.people = []
    }
    
    deinit {
        // Make sure to get rid of the name on the list.
        if let indexToRemove = Label.names.index(of: self.name) {
            print("removing ", self.name)
            Label.names.remove(at: indexToRemove)
        }
    }
    
    /**
     Determines if the label is valid.  Must have a name, and cannot contain a comma.
     */
    var valid: Bool {
        get {
            return name != "" || name.rangeOfCharacter(from: CharacterSet(charactersIn: ",")) != nil
        }
    }
    
    /**
     The number of people that are associated with this label.
     */
    var count: Int {
        get {
            return people.count
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
     Gets the name of the label
     
     - returns: Name of label as a String.
     */
    func getName() -> String {
        return self.name
    }
    
    /**
     Edit the Label name.
     
     - parameter name: The name of the label.  Cannot be blank.
     - get: true or false
         - True if the label name **was changed**.
         - False if the label name **could not be changed**.
             This can be due to an existing label already having the same name,
             the name supplied is blank, or the name contains a comma.
     */
    @discardableResult
    func editLabel(name: String) -> Bool {
        if name == "" {
            return false
        }
        if name.rangeOfCharacter(from: CharacterSet(charactersIn: ",")) != nil {
            return false
        }
        
        // See if the name to change to is already being used by another label,
        // and if it is, refuse the change.
        guard Label.names.index(of: name) != nil else {
            
            if let oldNameIndex = Label.names.index(of: self.name) {
                Label.names.remove(at: oldNameIndex)
            }
            
            self.name = name
            Label.names.append(name)
            return true
        }
        return false
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
    
    /**
     Delete/disassociate a person with this label.
     THIS SHOULD ONLY BE INVOKED BY A PERSON OBJECT! DO NOT INVOKE
     THIS OUTSIDE OF THE PERSON CLASS.
     
     - parameter person: Person to disassociate with the label.
     - returns: true or false
     - True if the person was deleted.
     - False if the person could not be removed, or was not on this list.
     */
    func del(person: Person) -> Bool {
        let indexOfExistingPerson = self.people.index(of: person)
        
        // Check to see if this person already has this label.
        if indexOfExistingPerson == nil {
            return false
        }
        else {
            self.people.remove(at: indexOfExistingPerson!)
            return true
        }
    }
    
    /**
     Sets the ID of the person in the database table.
     - parameter id: The primary key id in the table.
     */
    func set(id: Int) {
        self.id = id
    }
    
    /**
     Gets the ID of the person, which is associated with the database.
     - returns: The primary key id in the table.
     */
    func getId() -> Int {
        return id
    }
    
    /**
     Clears (removes) all references that this object has to/from its list of people.
     
     This is to avoid cyclic strong references
     
     You must RUN this in the following situations:
     - Before "removing" the label.
     */
    func clearAll() {
        for item in people {
            _ = item.del(label: self)
        }
        // Just to be safe.
        people.removeAll()
    }
    
}

extension Label: Equatable {
    
    /**
     Defines the equality operator to signify what is meant by
     having two Label objects being "equivalent"
     
     Referenced: https://developer.apple.com/documentation/swift/equatable
     */
    static func == (lhs: Label, rhs: Label) -> Bool {
        return lhs.getName() == rhs.getName()
    }
    
}
