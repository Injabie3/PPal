//
//  PeopleBankTest.swift
//  PPalTests
//
//  Created by rclui on 10/27/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation
import XCTest
@testable import PPal

class PeopleBankTest: XCTestCase {
    var label01: Label? = Label()
    var person01: Person? = Person()
    var listOfPeople = PeopleBank()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        label01 = Label()
        person01 = Person()
        listOfPeople = PeopleBank()
        
        _ = person01!.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        label01!.editLabel(name: "Family")
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        person01!.clearAll()
        label01!.clearAll()
    }
    
    /// Test to see if we can add a valid person to the PeopleBank
    func testAddValidPersonToBank() {
        person01!.add(label: label01!)
        
        let result = listOfPeople.add(person: person01!)
        
        XCTAssertTrue(result, "Could not add a valid person to the bank!")
    }
    
    /// Test to see if we can add the same person into the PeopleBank
    func testAddValidPersonToBankTwice() {
        person01!.add(label: label01!)
        
        // Add the person into the bank.
        var result = listOfPeople.add(person: person01!)
        result = listOfPeople.add(person: person01!)
        
        XCTAssertFalse(result, "Could not add a valid person to the bank!")
    }
}
