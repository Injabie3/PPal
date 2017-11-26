//
//  Choice.swift
//  PPal
//
//  Created by rclui on 11/9/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation

/**
 The Choice class that encapsulates everything that represents a Choice
 for a question.
 */
class Choice {
    
    /// The default constructor, will create a blank Choice.
    init() {
        id = -1
        pathToPhoto = ""
        text = ""
        person = nil
    }
    
    /**
     Makes a copy of the Choice that has a different reference.
     This is useful when we want to add this choice to multiple questions,
     but we want the Choice to be unique to the Question.
     */
    init(_ choice: Choice) {
        self.id = -1 // Since this is a different reference, this is not in the database.
        self.pathToPhoto = choice.pathToPhoto
        self.text = choice.text
        self.person = choice.person // We can reference the same person (if referenced), so this is fine.
    }
    
    /// The database primary key, used to store this choice.
    var id: Int
    
    /// Another string for now.
    var pathToPhoto: String
    
    /// The text associated with the choice.
    var text: String
    
    /// The person associated with the Choice.  If this is not nil, we can use it
    /// to bring up the person's profile for review if need be.
    weak var person: Person?
    
    /**
     Determines if the Choice is valid.
     Must contain:
     - An image.
     - Non-blank text.
     */
    var valid: Bool {
        get {
            if pathToPhoto == "" {
                return false
            }
            if text == "" {
                return false
            }
            
            // We've made it this far, it's valid fam.
            return true
        }
        
    }
    
}

extension Choice: Equatable {
    
    /**
     Defines the equality operator to signify what is meant by
     having two Choice objects being "equivalent"
     
     Two choices are the same if their photo and text are the same.
     
     Referenced: https://developer.apple.com/documentation/swift/equatable
     */
    static func == (lhs: Choice, rhs: Choice) -> Bool {
        return
            lhs.pathToPhoto == rhs.pathToPhoto &&
            lhs.text == rhs.text
    }
    
}
