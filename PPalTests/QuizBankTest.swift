//
//  QuizBankTest.swift
//  PPalTests
//
//  Created by rclui on 11/16/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation
import XCTest
@testable import PPal

/**
 # QuizBankTest Class
 This class contains the XCTests for the QuizBank class methods/properties.
 */

class QuizBankTest: XCTestCase {
    
    /// Set up test case environment.
    override func setUp() {
        super.setUp()
        
        var personArray = [Person]()
        
        let label = Label()
        label.editLabel(name: "Family")
        
        PeopleBank.shared.add(label: label)
        for index in 0..<10 {
            personArray.append(Person())
            
            personArray[index].add(label: label)
            personArray[index].setInfo(pathToPhoto: "aBase64Image\(index)", firstName: "Name\(index)", lastName: "Name\(index)", phoneNumber: "12345\(index)", email: "email\(index)@sfu.ca", address: "123 \(index) Fake Street", hasHouseKeys: false)
            
            PeopleBank.shared.add(person: personArray[index])
            
        }
        
        
        
        
        
    }
    
    override func tearDown() {
        super.tearDown()
        
        PeopleBank.shared.clearAll()
    }
    
    func testQuizBank() {
        let test = QuizBank.shared.generateQuestions()
        
        print("test")
    }
    
}
