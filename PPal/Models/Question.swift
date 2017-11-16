//
//  Question.swift
//  PPal
//
//  Created by rclui on 11/9/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation

/**
 An encapsulating class that defines a question for the quiz portion
 of our application.
 */
class Question {
    
    init() {
        id = -1
        text = ""
        image = ""
        choices = Array(repeating: Choice(), count: 4)
        correctAnswer = -1
        selectedAnswer = -1
    }
    
    /// The database primary key, used to store this question
    private var id: Int
    
    /// The actual question (text) itself.
    var text: String
    
    /// A corresponding image for the question, in base64
    var image: String
    
    /// An array to hold the four possible choices for each question.
    private var choices: [Choice]
    
    /// Index to the correct answer of the array of choices.
    private var correctAnswer: Int
    
    /// Index to the selected answer of the array of choices.  This is set by the user when they are playing the quiz.
    private var selectedAnswer: Int
    
    
    /**
     Determines if the Question is valid.
     Must contain:
     - Text that explains the question.
     - 4 valid questions.
     - A correct answer
     */
    var valid: Bool {
        get {
            // Check for blank question.
            if text == "" {
                return false
            }
            
            // Check that choices are valid.
            for choice in choices {
                if !choice.valid {
                    return false
                }
            }
            
            // And check if the correct answer is set.
            return choices.count == 4 && correctAnswer != -1
        }
    }
    
    /**
     Sets the correct Choice in the array for this question.
     - parameter index: The index corresponding to the correct Choice in the choices array stored by the class.
     - returns: true or false.
         - True if the correct answer index was set successfully.
         - False if the index supplied was invalid, and nothing is set.
     */
    func set(correctAnswerIndex index: Int) -> Bool {
        if index < 0 || index > 3 {
            return false
        }
        else {
            correctAnswer = index
            return true
        }
    }
    
    /**
     Sets the selected answer in the array.  This is to indicate which answer the user
     selected during the quiz.
     - parameter index: The index corresponding to the selected Choice
         in the choices array stored by the class.
     - returns: true or false.
         - True if the correct answer index was set successfully.
         - False if the index supplied was invalid, and nothing is set.
     */
    func set(selectedAnswerIndex index: Int) -> Bool {
        if index < 0 || index > 3 {
            return false
        }
        else {
            selectedAnswer = index
            return true
        }
    }
    
    /**
     Sets the provided choice at the provided index of the choice array.
     - parameter choice: The choice to add to the question.
     - parameter atIndex: The index you want to add this question at.
     - returns: true or false.
         - True if the choice was set correctly.
         - False if the choice was not set.  This is due to the Choice being invalid, or the index supplied is out of bounds.
     */
    func set(choice: Choice, atIndex: Int) -> Bool {
        if !choice.valid || atIndex < 0 || atIndex > 3 {
            return false
        }
        else {
            choices[atIndex] = choice
            return true
        }
    }
    
    /**
     Sets the ID fo the question in the database table.
     - parameter id: The primary key id in the table.
     */
    func set(id: Int) {
        self.id = id
    }
    
    /**
     Returns the index to the correct choice/answer.
     - returns: An index to the correct answer.  Use this index to access the correct element of the getChoices() method.
     */
    func getCorrectAnswer() -> Int {
        return correctAnswer
    }
    
    /**
     Returns the index to the selected choice/answer that the user made to the question.
     - returns: An index to the selected answer.  Use this index to access the correct element of the getChoices() method.  If this returns -1, then the user has not answered this question.
     */
    func getSelectedAnswer() -> Int {
        return selectedAnswer
    }
    
    /**
     Gets the ID fo the question in the database table.
     - returns: The primary key id in the table.
     */
    func getId() -> Int {
        return self.id
    }
    
    /**
     Gets the array of choices for the question.
     - returns: An array of Choice(s)
     */
    func getChoices() -> [Choice] {
        return choices
    }
    
}
