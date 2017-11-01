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
    var personArray = [Person?]()
    var label01: Label? = nil
    var label02: Label? = nil
    
    override func setUp() {
        super.setUp()
        db = Database()
        person01 = Person()
        personArray = [Person]()
        for index in 0..<10 {
            personArray.append(Person())
            personArray[index]?.setInfo(pathToPhoto: "test\(index).jpg", firstName: "First\(index)", lastName: "Last\(index)", phoneNumber: "\(index)", email: "r\(index)@sfu.ca", address: "\(index) Street", hasHouseKeys: false)
        }
        _ = person01!.setInfo(pathToPhoto: "test.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "1234567890", email: "whatAnEmail@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        label01 = Label()
        label01?.editLabel(name: "Test")
        label02 = Label()
        label02!.editLabel(name: "Family")
        
    }
    
    override func tearDown() {
        super.tearDown()
        person01!.clearAll()
        label01!.clearAll()
        label02!.clearAll()
        do
        {
            try db?.database.run(db!.personsTable.drop())
            try db?.labelDatabase.run(db!.labelTable.drop())
        } catch {
            print(error)
        }
        person01 = nil
        label01 = nil
        label02 = nil
        db = nil
    }

    
    /// Test to see if we can save a profile to the database.
    func testSaveProfileToDatabaseDefaultCase() {
        person01!.add(label: label01!)
        person01!.add(label: label02!)
        let result = db!.saveProfileToDatabase(profile: person01!)
        
        XCTAssertTrue(result, "Could not add this person into the database, even though we should be able to!")
    }
    
    /// Test to retrieve an entry in the database.
    func testRetrieveProfileById() {
        _ = person01!.add(label: label01!)
        
        // Save the information into the database.
        _ = db!.saveProfileToDatabase(profile: person01!)
        _ = db!.saveLabelToDatabase(label: label01!)
        
        // Simulate having no objects.
        person01?.clearAll()
        label01?.clearAll()
        person01 = Person()
        label01 = Label()
        
        // Get the people Bank.
        let peopleBank = db?.getAllData()
        
        let result = peopleBank!.getPeople()[0]
        XCTAssertTrue(result.getInfo().firstName == "Ryan")
        
    }
}
