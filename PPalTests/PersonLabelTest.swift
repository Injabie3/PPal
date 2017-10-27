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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
     Test to see if we can add a person to a label, and doesn't already have this label.
     */
    func testAddPersonToALabelFirstTime() {
        let person01 = Person()
        let label01 = Label()
        
        _ = person01.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        
        label01.editLabel(name: "Family")
        let result = person01.add(label: label01)
        
        XCTAssertTrue(result, "Could not add person to a label!")
    }
    
    /**
     Test to see if we can add a person to a label, but already has this label.
     */
    func testAddLabelToPersonButSameLabel() {
        let person01 = Person()
        let label01 = Label()
        
        _ = person01.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        
        label01.editLabel(name: "Test")
        
        var result = person01.add(label: label01)
        result = person01.add(label: label01)
        
        XCTAssertFalse(result, "Could not add person to a label!")
    }
    
    /**
     Test to see if we can remove a label from a person, in the case they have this label associated with them.
     */
    func testDeleteLabelFromPersonDefaultCase() {
        let person01 = Person()
        let label01 = Label()
        
        _ = person01.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        
        label01.editLabel(name: "Friends")
        
        person01.add(label: label01)
        let resultFromPerson = person01.del(label: label01)
        let resultFromLabel = label01.getPeople().contains(person01)
        
        XCTAssertTrue(resultFromPerson, "Could not remove the label from the person!")
        XCTAssertFalse(resultFromLabel, "The person still exists in the label!")
    }
    
    /**
     Test to see if we can add a blank label to a person.
     */
    func testAddBlankLabelToPerson() {
        let person01 = Person()
        let label01 = Label()
        
        _ = person01.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        
        let resultFromPerson = person01.add(label: label01)
        let resultFromLabel = label01.getPeople().contains(person01)
        
        XCTAssertFalse(resultFromPerson, "You somehow added a label even though it was blank!")
        XCTAssertFalse(resultFromLabel, "The person still got added to the label!")
    }

    /**
     Test to see if we can remove a label from a person, but they don't have this label associated with them.
     */
    func testDeleteLabelFromPersonButPersonDoesNotHaveLabel() {
        let person01 = Person()
        let label01 = Label()
        let label02 = Label()
        
        _ = person01.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        
        label01.editLabel(name: "Test")
        person01.add(label: label01)
        let resultFromPerson = person01.del(label: label02)
        let resultFromLabel = label02.getPeople().contains(person01)
        
        XCTAssertFalse(resultFromPerson, "You somehow removed the label from the person even though they don't have it!")
        XCTAssertFalse(resultFromLabel, "The person still exists in the label!")
    }
    
//    /**
//     Test to see if we can add more than 10 labels to a person.
//     */
//    func testAddMoreThan10LabelsToPerson() {
//        for item in labels {
//            person01.add(label: item)
//        }
//
//        let label01 = Label()
//        
//        label01.editLabel(name: "Test")
//
//        let resultFromPerson = person01.add(label: label01)
//        let resultFromLabel = label01.getPeople().contains(person01)
//
//        XCTAssertFalse(resultFromPerson, "You somehow added a label to this person even though they have 10 labels!")
//        XCTAssertFalse(resultFromLabel, "The person still got added to the label!")
//    }
    
    /**
     Test to see if we can add 10 labels, and then remove them all.
     */
    func testAdd10LabelsAndRemove10Labels() {
        let person01 = Person()
        
        _ = person01.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        
        var labels = [Label]()
        for index in 0..<10 {
            labels.append(Label())
            labels[index].editLabel(name: "Label Name \(index)")
        }
        for item in labels {
            person01.add(label: item)
        }
        
        let label01 = Label()
        
        label01.editLabel(name: "Test")
        
        let resultFromPerson = person01.add(label: label01)
        let resultFromLabel = label01.getPeople().contains(person01)
        
        XCTAssertFalse(resultFromPerson, "You somehow added a label to this person even though they have 10 labels!")
        XCTAssertFalse(resultFromLabel, "The person still got added to the label!")
    }
    
}
