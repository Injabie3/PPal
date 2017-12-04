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
    
    /// The default constructor, will create a blank question, with blank choices.
    init() {
        id = -1
        text = ""
        image = ""
        choices = Array(repeating: Choice(), count: 4)
        choiceIndices = []
        correctAnswer = -1
        selectedAnswer = -1
    }
    
    /**
     Makes a copy of the Question that has a different reference.
     Implicitly makes a copy of each Choice with a different reference as well.
     This is useful when we want to add this Question to multiple quizzes,
     but we want the Question to be unique to the Quiz.
     */
    init(_ question: Question) {
        self.id = -1 // Since this is different reference, this is not in the database.
        self.text = question.text
        self.image = question.image
        self.correctAnswer = question.correctAnswer
        self.selectedAnswer = question.selectedAnswer
        self.choices = [Choice]()
        for choice in question.choices {
            // Make a copy of the choice, so it's a completely different reference.
            self.choices.append(Choice(choice))
        }
        self.choiceIndices = [Int]()
    }
    
    /// The database primary key, used to store this question
    private var id: Int
    
    /// The actual question (text) itself.
    var text: String
    
    /// A corresponding image for the question, in base64
    var image: String
    
    /// An array of Index position to keep track of the order when setting choice atIndex - Harry
    var choiceIndices: [Int]
    
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
     Shuffles the choices, but keeps track of where the correct answer is.  Use only before you give a question for a user to answer.
     */
    func shuffleChoices() {
        var randomizedChoiceArray = Array(repeating: Choice(), count: 4)
        var newArrayIndices = [0, 1, 2, 3]
        var originalArrayIndices = [0, 1, 2, 3]
        
        // Get the correct index before we start shuffling.
        var indexFromOriginalArray = self.correctAnswer
        var indexFromNewArray = Int(arc4random_uniform(UInt32(newArrayIndices.count)))
        
        // Copy the correct choice into the new randomized choice array.
        randomizedChoiceArray[newArrayIndices[indexFromNewArray]] = choices[originalArrayIndices[indexFromOriginalArray]]
        
        // Set the new correct answer index here, and then remove the indices.
        self.correctAnswer = indexFromNewArray
        
        originalArrayIndices.remove(at: indexFromOriginalArray)
        newArrayIndices.remove(at: indexFromNewArray)
        
        // We don't care where the other ones go, so we can loop this.
        for _ in 0..<3 {
            // Get a random index in the new and original array.
            indexFromOriginalArray = Int(arc4random_uniform(UInt32(originalArrayIndices.count)))
            indexFromNewArray = Int(arc4random_uniform(UInt32(newArrayIndices.count)))
            
            
            // Copy choice over.
            randomizedChoiceArray[newArrayIndices[indexFromNewArray]] = choices[originalArrayIndices[indexFromOriginalArray]]
            
            // Remove the indices; rinse and repeat.
            originalArrayIndices.remove(at: indexFromOriginalArray)
            newArrayIndices.remove(at: indexFromNewArray)
        }
        
        // Now assign the shuffled array back.
        self.choices = randomizedChoiceArray
        
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
            choiceIndices.append(atIndex)
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

extension Question: Equatable {
    
    /**
     Defines the equality operator to signify what is meant by
     having two Question objects being "equivalent".
     
     Basically two questions are equivalent if the choices are the same,
     the selected answer is the same, the correct answer is the same, the
     image is the same, and the text is the same.
     
     Referenced: https://developer.apple.com/documentation/swift/equatable
     */
    static func == (lhs: Question, rhs: Question) -> Bool {
        // Check the choices first.
        for choiceIndex in 0..<4 {
            if lhs.choices[choiceIndex] == rhs.choices[choiceIndex] {
                return true
            }
        }
        
        return
            lhs.selectedAnswer == rhs.selectedAnswer &&
            lhs.correctAnswer == rhs.correctAnswer &&
            lhs.image == rhs.image &&
            lhs.text == rhs.text
    }
    
}
