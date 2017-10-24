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
        let label1 = Label(name: "Test")
        
        let result = label1.editLabel(name: "Family")
        
        XCTAssertTrue(result, "Could not successfully change the name!")
    }
    
}
