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
    
    var person1: Person? = Person() // A Person object we will continuously use.
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        person1 = Person()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        person1?.clearAll()
        person1 = nil
    }
    

    /// Tests setting correct information using setInfo()
    func testSetInfoDefaultCase() {
        let result = person1!.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        
        XCTAssert(result, "Person information was not set correctly!")
        
    }

    /// Tests setting blank photo path
    func testSetInfoButPhotoBlank() {
        let result = person1!.setInfo(pathToPhoto: "", firstName: "Ryan", lastName: "Lui", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        
        XCTAssertFalse(result, "Blank photo path not detected correctly!")
    }
    
    /// Tests setting blank first name.
    func testSetInfoButBlankFirstName() {
        let result = person1!.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "", lastName: "Lui", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        
        XCTAssertFalse(result, "Blank firstName not detected correctly!")
    }
    
    /// Tests setting blank last name.
    func testSetInfoButBlankLastName() {
        // Tests setting blank last name.
        let result = person1!.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        
        XCTAssertFalse(result, "Blank lastName not detected correctly!")
    }
    
    /// Tests setting blank phone number, and phone number with invalid characters.
    func testSetInfoButInvalidPhoneNumber() {
        
        // 1. Test blank phone number
        var result = person1!.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        
        XCTAssertFalse(result, "Blank phone number not detected correctly!")
        
        // 2a. Test invalid phone number - with alpha characters
        result = person1!.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "a+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        
        XCTAssertFalse(result, "Invalid phone number (alpha characters) not detected correctly!")
        
        // 2b. Test invalid phone number - with symbols
        result = person1!.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "$+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        
        XCTAssertFalse(result, "Invalid phone number (symbols not detected correctly!")
        
        result = person1!.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "+16041^234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        
        XCTAssertFalse(result, "Invalid phone number (symbols not detected correctly!")
        
    }
    
    /// Tests setting the name in the default working case.
    func testSetNameDefaultCase() {
        let firstNameToTest = "Ryan"
        let lastNameToTest = "Lui"
        
        let result = person1!.set(firstName: firstNameToTest, lastName: lastNameToTest)
        
        XCTAssertTrue(result, "Could not set the name even though you're supposed to be able to!")
        
        let checkValue = person1!.getName()
        XCTAssertTrue(checkValue.firstName == firstNameToTest, "The first name was not set properly!")
        XCTAssertTrue(checkValue.lastName == lastNameToTest, "The last name was not set properly!")
    }
    
    /// Tests setting the name with blanks.
    func testSetNameButBlanks() {
        let firstNameToTest = "Ryan"
        let lastNameToTest = "Lui"
        var result: Bool
        
        // Blank first name check.
        result = person1!.set(firstName: "", lastName: lastNameToTest)
        XCTAssertFalse(result, "You managed to set the name even though you have a blank first name!")

        // Blank last name check.
        result = person1!.set(firstName: firstNameToTest, lastName: "")
        XCTAssertFalse(result, "You managed to set the name even though you have a blank last name!")
        
        // Blank all
        result = person1!.set(firstName: "", lastName: "")
        XCTAssertFalse(result, "You managed to set the name even though you have blanks!")
    }
    
    /// Tests setting the email in the default working case.
    func testSetEmailDefaultCase() {
        let emailToTest = "thisValidEmail@sfu.ca"
        
        let result = person1!.set(email: emailToTest)
        
        XCTAssertTrue(result, "Could not set the email even though you're supposed to be able to!")
        
        let checkValue = person1!.getInfo()
        XCTAssertTrue(checkValue.email == emailToTest, "The email was not set properly!")
    }
    
    /// Tests setting the email in the default working case.
    func testSetEmailButInvalidEmail() {
        var result: Bool
        
        result = person1!.set(email: "")
        XCTAssertFalse(result, "You set the email even though you had a blank!")
        
        result = person1!.set(email: "iek#")
        XCTAssertFalse(result, "You set the email even though you're not supposed to!")
        
        result = person1!.set(email: "whatisthis")
        XCTAssertFalse(result, "You set the email even though you're not supposed to!")
        
        result = person1!.set(email: "test@ine^")
        XCTAssertFalse(result, "You set the email even though you're not supposed to!")
    }
    
    /// Tests setting the phone number in the default working case.
    func testSetPhoneNumberDefaultCase() {
        var result: Bool
        let phoneNumberToTest = ["+17781234567", "17781234567", "+1-778-123-4567"]
        
        for item in phoneNumberToTest {
            result = person1!.set(phoneNumber: item)
            XCTAssertTrue(result, "You couldn't set the phone number even though you're supposed to be able to!")
            
            let valueCheck = person1!.getInfo()
            XCTAssertTrue(valueCheck.phoneNumber == item, "The phone number was not set correctly!")
        }
    }
    
    /// Tests setting invalid phone numbers.
    func testSetPhoneNumberButInvalid() {
        var result: Bool
        
        result = person1!.set(phoneNumber: "")
        XCTAssertFalse(result, "You managed to set the phone number even though it was blank!")
        
        result = person1!.set(phoneNumber: "778?x1234567")
        XCTAssertFalse(result, "You managed to set the phone number even though you're not supposed to!")
        
        result = person1!.set(phoneNumber: "p6041234567")
        XCTAssertFalse(result, "You managed to set the phone number even though you're not supposed to!")
        
        result = person1!.set(phoneNumber: "01185212345671/2")
        XCTAssertFalse(result, "You managed to set the phone number even though you're not supposed to!")
    }
    
    /// Tests adding a label to a person.
    func testAddLabelDefaultCase() {
        let label01 = Label()
        _ = label01.editLabel(name: "Friends")
        let result = person1!.add(label: label01)
        
        XCTAssertTrue(result, "Could not add label!")
        
        label01.clearAll()
    }
    
    /// Tests adding a duplicate label to a person.
    func testAddLabelButDuplicate() {
        let label01 = Label()
        
        var result = person1!.add(label: label01)
        
        // Try adding the same label again
        result = person1!.add(label: label01)
        
        XCTAssertFalse(result, "The duplicate was added!")
        
        label01.clearAll()
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
