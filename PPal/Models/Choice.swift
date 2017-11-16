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
    
    init() {
        id = -1
        pathToPhoto = ""
        text = ""
        person = nil
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
