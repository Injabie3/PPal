//
//  LabelTest.swift
//  PPalTests
//
//  Created by rclui on 10/24/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation
import XCTest
@testable import PPal

class LabelTest: XCTestCase {
    
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// Test to see if we can successfully change the name of a label.
    func testEditLabelName() {
        let label01 = Label()
        let result = label01.editLabel(name: "Family")
        
        XCTAssertTrue(result, "Could not successfully change the name!")
    }
    
    /// Test to see if we can change the name of a label to be blank.
    func testEditLabelName_blankName() {
        let label01 = Label()
        let result = label01.editLabel(name: "")
        
        XCTAssertFalse(result, "You managed to change the label name to be blank!")
    }
    
    /// Test to see if we can create two labels, and change them to the same name.
    func testEditLabelName_sameName() {
        let label01 = Label()
        let label02 = Label()
        
        _ = label01.editLabel(name: "Family")
        
        // This should fail because Family already exists.
        let result02 = label02.editLabel(name: "Family")
        
        
        XCTAssertFalse(result02, "You managed to set the name even though you're not supposed to!")
    }
    
    /**
     Test to see if we can create two labels:
     - Change the first label to Test.
     - Overwrite the original label with a new one, so it gets destroyed.
     - Change the second label to Test.
     */
    func testEditLabelName_sameNameButOriginalObjectReplaced() {
        var label01 = Label()
        let label02 = Label()
        
        _ = label01.editLabel(name: "Family")
        
        label01 = Label()
        
        // This should succeed because the reference to the original Label with family no longer
        // has a reference.
        let result02 = label02.editLabel(name: "Family")
        
        
        XCTAssertTrue(result02, "You can't change the name even though this name doesn't exist!")
    }
    
}
