//
//  QuestionTest.swift
//  PPalTests
//
//  Created by rclui on 11/10/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation
import XCTest
@testable import PPal

/**
 # QuestionTest Class
 This class contains the XCTests for the PeopleBank class methods, and additionally
 requires the following classes:
 - Choice class (from PPal)
 */

class QuestionTest: XCTestCase {
    
    var choice01 = Choice()
    var question01 = Question()
    
    override func setUp() {
        super.setUp()
        
        // Modify the choice to be valid.
        choice01.text = "Bob"
        choice01.pathToPhoto = "imageOfBob.jpg"
    }
    
    override func tearDown() {
        super.tearDown()
        
        // Reset.
        choice01 = Choice()
        question01 = Question()
    }
    
    /// Add a valid choice, and see if it successfully adds.
    func testSetChoiceValidChoice() {
        
        // Add the choice to the question.
        let result = question01.set(choice: choice01, atIndex: 0)
        XCTAssertTrue(result, "The choice could not be added to the question even though it's valid!")
    }
    
    /// Try to see if we can add an invalid choice.
    func testSetChoiceInvalidChoice() {
        // Choice 1 is valid, so let's make it invalid
        choice01.pathToPhoto = ""
        
        // Add the choice to the question.
        let result = question01.set(choice: choice01, atIndex: 0)
        XCTAssertFalse(result, "You managed to add the choice even though it was false!")
    }
    
    /// Test to see if we can add a valid choice to an invalid index.
    func testSetChoiceInvalidIndex() {
        // Choice 1 is valid.
        
        // Add the choice to the question
        var result = question01.set(choice: choice01, atIndex: -1)
        XCTAssertFalse(result, "You managed to add a choice even though you're not supposed to be able to!")
        
        result = question01.set(choice: choice01, atIndex: 4)
        XCTAssertFalse(result, "You managed to add a choice even though you're not supposed to be able to!")
    }
    
    /// Test to see if we can set the correct answer index.
    func testSetCorrectAnswerIndex() {
        var result = question01.set(correctAnswerIndex: 0)
        XCTAssertTrue(result, "Could not set the correct answer index even though a valid index was supplied.")
        XCTAssertTrue(question01.getCorrectAnswer() == 0, "The correct answer does not match what we set it to!")
        
        result = question01.set(correctAnswerIndex: -1)
        XCTAssertFalse(result, "Managed to set the correct answer index even though an invalid index was supplied.")
        
        result = question01.set(correctAnswerIndex: 4)
        XCTAssertFalse(result, "Managed to set the correct answer index even though an invalid index was supplied.")
    }
    
    /// Test to see if we can set the selected answer index.
    func testSetSelectedAnswerIndex() {
        var result = question01.set(selectedAnswerIndex: 0)
        XCTAssertTrue(result, "You supplied a valid index, but it was not set!")
        
        result = question01.set(selectedAnswerIndex: -1)
        XCTAssertFalse(result, "You managed to set it even though you're not supposed to be able to!")
        
        result = question01.set(selectedAnswerIndex: 4)
        XCTAssertFalse(false, "You managed to set it even though you're not supposed to be able to!")
    }
    
    /// Test to see if the question is valid if we give it 4 valid choices, and set the correct answer.
    func testValidQuestion() {
        
        // Let's create some valid choices.
        var choiceArray = [Choice]()
        for index in 0..<4 {
            choiceArray.append(Choice())
            choiceArray[index].text = "42"
            choiceArray[index].pathToPhoto = "anImageOf42.png"
        }
        
        // Let's add these valid choices to the question.
        let question = Question()
        for index in 0..<4 {
            _ = question.set(choice: choiceArray[index], atIndex: index)
        }
        
        // and let's set the correct index, arbitrary for now.
        _ = question.set(correctAnswerIndex: 2)
        
        // Alright, let's check the validity.
        XCTAssertTrue(question.valid, "The question should be valid, but it's not!")
    }
    
    /// Test the validity of the question, this time don't add any choices.
    func testValidQuestionBlankChoicesOnly() {
        _ = question01.set(correctAnswerIndex: 1)
        XCTAssertFalse(question01.valid, "This question is valid even though it's not supposed to be!")
    }
    
    /// Test the validity of the question, this time don't set the correct answer index.
    func testValidQuestionBlankCorrectAnswerOnly() {
        // Let's create some valid choices.
        var choiceArray = [Choice]()
        for index in 0..<4 {
            choiceArray.append(Choice())
            choiceArray[index].text = "42"
            choiceArray[index].pathToPhoto = "anImageOf42.png"
        }
        
        // Let's add these valid choices to the question.
        let question = Question()
        for index in 0..<4 {
            _ = question.set(choice: choiceArray[index], atIndex: index)
        }
        
        // Alright, let's check the validity.
        XCTAssertFalse(question.valid, "The question shouldn't be valid, but it is!")
        
    }
    
}
