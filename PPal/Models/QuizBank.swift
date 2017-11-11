//
//  QuizBank.swift
//  PPal
//
//  Created by rclui on 11/10/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation

/**
 An encapsulating class that will hold the following:
 - Quiz history
 - Custom quiz questions (version 3)
 */
class QuizBank {
    
    /**
     The static variable to hold a copy of QuizBank, so that it is accessible
     from anywhere in the code
    */
    static var shared = QuizBank()
    
    // An array to store quizHistory
    var quizHistory: [Quiz]
    
    /// An array to hold the custom questions for the quiz, to be implemented
    /// in version 3
    private var customQuestions: [Question]
    
    private init() {
        quizHistory = [Quiz]()
        customQuestions = [Question]()
    }
    
    /**
     Adds a custom question into the quiz bank.
     - parameter question: A valid Question object.
     - returns: true or false
         - True if the Question was successfully added.
         - False if the Question was not added.  This is due to the Question being invalid.
     */
    func addCustom(question: Question) -> Bool {
        /// Stub function, to be implemented in version 3.
        return true
    }
    
    /**
     Removes the custom question into the quiz bank.
     - parameter question: A Question object, obtained from the getQuestions() method.
     - returns: true or false
         - True if the Question was successfully removed.
         - False if the Question was not removed.  This is due to the Question not being on
         the list.
     */
    func delCustom(question: Question) -> Bool {
        /// Stub function, to be implemented in version 3.
        return true
    }
    
    /**
     Generates a quiz with 10 questions.
     - returns: A Quiz object with 10 questions.
     */
    func generateQuestions() -> Quiz {
        let quizToReturn = Quiz()
        
        
        
        
        return quizToReturn
    }
    
}
