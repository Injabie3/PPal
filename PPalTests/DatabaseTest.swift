//
//  DatabaseTest.swift
//  PPalTests
//
//  Created by rclui on 10/31/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation
import XCTest
import SQLite
@testable import PPal

class DatabaseTest: XCTestCase {
    
    var db: Database? = nil
    var person01: Person? = nil
    var label01: Label? = nil
    
    override func setUp() {
        super.setUp()
        db = Database()
        person01 = Person()
        _ = person01!.setInfo(pathToPhoto: "test.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "1234567890", email: "whatAnEmail@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        label01 = Label()
        label01?.editLabel(name: "Test")
        
    }
    
    override func tearDown() {
        super.tearDown()
        person01!.clearAll()
        label01!.clearAll()
        person01 = nil
        label01 = nil
        db = nil
    }

    
    /// Test to see if we can save a profile to the database.
    func testSaveProfileToDatabaseDefaultCase() {
        let result = db!.saveProfileToDatabase(profile: person01!)
        
        XCTAssertTrue(result, "Could not add this person into the database, even though we should be able to!")
    }
    
    /// Test to retrieve an entry in the database.
    func testRetrieveProfileById() {
        db?.retrieveProfileById(id: 1)
        
    }
}
