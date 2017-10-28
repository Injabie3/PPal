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
    var person01: Person? = Person()
    var label01: Label? = Label()
    
    var labels = [Label?]()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        person01 = Person()
        label01 = Label()
        
        _ = person01!.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        label01!.editLabel(name: "Test")
        
        for index in 0..<10 {
            labels.append(Label())
            labels[index]?.editLabel(name: "Label Name \(index)")
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        person01?.clearAll()
        label01?.clearAll()
        for item in labels {
            item?.clearAll()
        }
        labels.removeAll()
        person01 = nil
        label01 = nil
    }
    
    /**
     Test to see if we can add a person to a (valid) label, and doesn't already have this label.
     */
    func testAddPersonToALabelFirstTime() {
        let result = person01!.add(label: label01!)
        
        XCTAssertTrue(result, "Could not add person to a label!")
    }
    
    /**
     Test to see if we can add a person to a label, but already has this label.
     */
    func testAddLabelToPersonButSameLabel() {
        var result = person01!.add(label: label01!)
        result = person01!.add(label: label01!)
        
        XCTAssertFalse(result, "Could not add person to a label!")
    }
    
    /**
     Test to see if we can remove a label from a person, in the case they have this label associated with them.
     */
    func testDeleteLabelFromPersonDefaultCase() {
        person01!.add(label: label01!)
        let resultFromPerson = person01!.del(label: label01!)
        let resultFromLabel = label01!.getPeople().contains(person01!)
        
        XCTAssertTrue(resultFromPerson, "Could not remove the label from the person!")
        XCTAssertFalse(resultFromLabel, "The person still exists in the label!")
    }
    
    /**
     Test to see if we can add a blank label to a person.
     */
    func testAddBlankLabelToPerson() {
        let label02 = Label()
        
        let resultFromPerson = person01!.add(label: label02)
        let resultFromLabel = label02.getPeople().contains(person01!)
        
        XCTAssertFalse(resultFromPerson, "You somehow added a label even though it was blank!")
        XCTAssertFalse(resultFromLabel, "The person still got added to the label!")
    }

    /**
     Test to see if we can remove a label from a person, but they don't have this label associated with them.
     */
    func testDeleteLabelFromPersonButPersonDoesNotHaveLabel() {
        person01!.add(label: labels[0]!)
        
        let resultFromPerson = person01!.del(label: labels[1]!)
        let resultFromLabel = labels[1]!.getPeople().contains(person01!)
        
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
        for item in labels {
            person01!.add(label: item!)
        }
        
        label01!.editLabel(name: "Test")
        
        let resultFromPerson = person01!.add(label: label01!)
        let resultFromLabel = label01!.getPeople().contains(person01!)
        
        XCTAssertFalse(resultFromPerson, "You somehow added a label to this person even though they have 10 labels!")
        XCTAssertFalse(resultFromLabel, "The person still got added to the label!")
    }
    
}
