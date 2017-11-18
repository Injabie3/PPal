//
//  DataPopulation.swift
//  PPalTests
//
//  Created by rclui on 11/17/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation
import XCTest
@testable import PPal

/**
 # DataPopulation class.
 This class exists only to prepopulate the database with information,
 so that we don't have to re enter information every time after we run our test cases.
 
 */

class DataPopulation: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    /// This function populates the database with information.
    func testDataPopulation() {
        let db = Database.shared
        // Get rid of the databases, and start from scratch.
        do
        {
            try db.database.run(db.personsTable.drop())
            try db.labelDatabase.run(db.labelTable.drop())
            try db.choicesDatabase.run(db.choiceTable.drop())
            try db.questionsDatabase.run(db.questionTable.drop())
            try db.quizzesDatabase.run(db.quizTable.drop())
        } catch {
            print(error)
        }
        db.recreateDatabase()
        
        // Let's start populating
        // Labels
        let label01 = Label()
        let label02 = Label()
        label01.editLabel(name: "CMPT 275")
        label02.editLabel(name: "SFU")
        _ = db.saveLabelToDatabase(label: label01)
        _ = db.saveLabelToDatabase(label: label02)
        
        let person = Person()
        _ = person.setInfo(pathToPhoto: #imageLiteral(resourceName: "lui").toBase64, firstName: "Ryan", lastName: "Lui", phoneNumber: "123-456-7890", email: "lui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        person.add(label: label01)
        person.add(label: label02)
        _ = db.saveProfileToDatabase(profile: person)
        
        _ = person.setInfo(pathToPhoto: #imageLiteral(resourceName: "harry").toBase64, firstName: "Harry", lastName: "Gong", phoneNumber: "234-123-1234", email: "harry@sfu.ca", address: "125 Fake Street", hasHouseKeys: false)
        _ = db.saveProfileToDatabase(profile: person)
        
        _ = person.setInfo(pathToPhoto: #imageLiteral(resourceName: "mirac").toBase64, firstName: "Mirac", lastName: "Chen", phoneNumber: "111-222-3333", email: "mirac@sfu.ca", address: "222 Cool Street", hasHouseKeys: false)
        _ = db.saveProfileToDatabase(profile: person)
        
        _ = person.setInfo(pathToPhoto: #imageLiteral(resourceName: "ranbir").toBase64, firstName: "Ranbir", lastName: "Makkar", phoneNumber: "111-123-1234", email: "ranbir@sfu.ca", address: "8888 University Street", hasHouseKeys: false)
        _ = db.saveProfileToDatabase(profile: person)
        
        _ = person.setInfo(pathToPhoto: #imageLiteral(resourceName: "maple").toBase64, firstName: "Maple", lastName: "Tan", phoneNumber: "999-999-9999", email: "maple@sfu.ca", address: "1 SFU Street", hasHouseKeys: false)
        _ = db.saveProfileToDatabase(profile: person)
        
    }
    
    
    
}
