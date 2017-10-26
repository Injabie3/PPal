//
//  PersonLabelTest.swift
//  PPalTests
//
//  Created by rclui on 10/25/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation
import XCTest
@testable import PPal

class PersonLabelTest: XCTestCase {
    var label01 = Label()
    var person01 = Person()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        _ = person01.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false, labels: [])
        _ = label01.editLabel(name: "Family")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
     Test to see if we can add a person to a label, and doesn't already have this label.
     */
    func testAddPersonToALabel_new() {
        
        label01 = Label()
        
        // This should succeed because the reference to the original Label with family no longer
        // has a reference.
        
        let result = person01.add(label: label01)
        XCTAssertTrue(result, "Could not add person to a label!")
    }
}
