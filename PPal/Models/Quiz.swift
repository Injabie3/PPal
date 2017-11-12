//
//  Quiz.swift
//  PPal
//
//  Created by rclui on 11/10/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation

/**
 The encapsulating class that will hold the necessary properties that define
 a quiz.  This is used for holding the questions and choices for a particular
 quiz, as well as the number of correct answers chosen by the user in the quiz.
 To be used for quiz history, as per our requirements.
 
 This is public because just need it to hold data.
 */
class Quiz {
   
    /// The number of correct answers that the user had for this quiz.
    var score: Int
    
    /// The Question(s) associated with this quiz.
    var questions: [Question]
    
    /// The date and time of when this quiz was taken.
    var dateTaken: Date
    
    init() {
        score = 0
        questions = [Question]()
        dateTaken = Date(timeIntervalSince1970: 0)
    }
    
}
