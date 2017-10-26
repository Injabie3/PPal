//
//  PersonTest.swift
//  PPalTests
//
//  Created by rclui on 10/24/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation
import XCTest
@testable import PPal

class PersonTest: XCTestCase {
    
    let person1 = Person() // A Person object we will continuously use.s
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    /// Tests setting correct information using setInfo()
    func testSetInfo_correct() {
        let result = person1.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false, labels: [])
        
        XCTAssert(result, "Person information was not set correctly!")
        
    }

    /// Tests setting blank photo path
    func testSetInfo_photoBlank() {
        let result = person1.setInfo(pathToPhoto: "", firstName: "Ryan", lastName: "Lui", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false, labels: [])
        
        XCTAssertFalse(result, "Blank photo path not detected correctly!")
    }
    
    /// Tests setting blank first name.
    func testSetInfo_blankFirstName() {
        let result = person1.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "", lastName: "Lui", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false, labels: [])
        
        XCTAssertFalse(result, "Blank firstName not detected correctly!")
    }
    
    /// Tests setting blank last name.
    func testSetInfo_blankLastName() {
        // Tests setting blank last name.
        let result = person1.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false, labels: [])
        
        XCTAssertFalse(result, "Blank lastName not detected correctly!")
    }
    
    /// Tests setting blank phone number, and phone number with invalid characters.
    func testSetInfo_invalidPhoneNumber() {
        
        // 1. Test blank phone number
        var result = person1.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false, labels: [])
        
        XCTAssertFalse(result, "Blank phone number not detected correctly!")
        
        // 2a. Test invalid phone number - with alpha characters
        result = person1.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "", phoneNumber: "a+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false, labels: [])
        
        XCTAssertFalse(result, "Invalid phone number (alpha characters) not detected correctly!")
        
        // 2b. Test invalid phone number - with symbols
        result = person1.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "", phoneNumber: "$+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false, labels: [])
        
        XCTAssertFalse(result, "Invalid phone number (symbols not detected correctly!")
        
        result = person1.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "", phoneNumber: "+16041^234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false, labels: [])
        
        XCTAssertFalse(result, "Invalid phone number (symbols not detected correctly!")
        
    }
    
    /// Tests adding a label to a person.
    func testAddLabel_NonExistent() {
        let label01 = Label()
        _ = label01.editLabel(name: "Family")
        let result = person1.add(label: label01)
        
        XCTAssertTrue(result)
    }
    
    /// Tests adding a duplicate label to a person.
    func testAddLabel_Duplicate() {
        let label01 = Label()
        
        var result = person1.add(label: label01)
        
        // Try adding the same label again
        result = person1.add(label: label01)
        
        XCTAssertFalse(result, "The duplicate was added!")
    }
    
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
