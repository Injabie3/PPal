//
//  ChoiceTest.swift
//  PPalTests
//
//  Created by rclui on 11/9/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation
import XCTest
@testable import PPal

/**
 # ChoiceTest Class
 This class contains the XCTests for the Choice class methods/properties.
 */

class ChoiceTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
        
    }
    
    /// Test to see if we can validate a choice.
    func testValidChoiceDefaultCase() {
        let choice01 = Choice()
        
        choice01.text = "Question"
        choice01.pathToPhoto = "someRandomPathForNow.jpg"
        XCTAssertTrue(choice01.valid, "The choice is not valid even though it's supposed to be!")
        
    }
    
    /// Test to see if blank text makes the choice invalid.
    func testValidChoiceBlankText() {
        let choice01 = Choice()
        
        choice01.text = ""
        choice01.pathToPhoto = "someRandomPathForNow.jpg"
        XCTAssertFalse(choice01.valid, "The choice is valid even though it's not supposed to be!")
        
    }
    
    /// Test to see if blank photo path makes the choice invalid.
    func testValidChoiceBlankPhotoPath() {
        let choice01 = Choice()
        
        choice01.text = "Question"
        choice01.pathToPhoto = ""
        XCTAssertFalse(choice01.valid, "The choice is valid even though it's not supposed to be!")
        
    }
    
}
