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
    var labelArray = [Label?]()
    var label01: Label? = nil
    var label02: Label? = nil
    
    override func setUp() {
        super.setUp()
        // Set up the objects
        db = Database()
        person01 = Person()
        personArray = [Person]()
        
        // Create some labels
        for index in 0..<3 {
            labelArray.append(Label())
            _ = labelArray[index]!.editLabel(name: "Label \(index)")
        }
        
        // Create some people, and associate them with the labels above.
        for index in 0..<10 {
            personArray.append(Person())
            _ = personArray[index]?.setInfo(pathToPhoto: "test\(index).jpg", firstName: "First\(index)", lastName: "Last\(index)", phoneNumber: "\(index)", email: "r\(index)@sfu.ca", address: "\(index) Street", hasHouseKeys: false)
            for item in 0..<3 {
                _ = personArray[index]?.add(label: labelArray[item]!)
            }
        }
        
        _ = person01!.setInfo(pathToPhoto: "test.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "1234567890", email: "whatAnEmail@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        label01 = Label()
        label01?.editLabel(name: "Test")
        label02 = Label()
        label02!.editLabel(name: "Family")
        
    }
    
    override func tearDown() {
        super.tearDown()
        
        // Get rid of cyclic references.
        person01?.clearAll()
        label01?.clearAll()
        label02?.clearAll()
        
        for item in 0..<personArray.count {
            personArray[item]?.clearAll()
        }
        
        for item in 0..<labelArray.count {
            labelArray[item]?.clearAll()
        }
        
        // Drop all tables from the database to start from scratch every time.
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
    func testGetAllDataOnePersonAndOneLabel() {
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
        
        // Get rid of the items.
        for item in peopleBank!.getLabels() {
            item.clearAll()
        }
        
        for item in peopleBank!.getPeople() {
            item.clearAll()
        }
        
        
    }
    
    /**
     Tests to see if we can save 10 valid Person and Label objects to the database,
     and then see if we can retreive them without a problem.
     */
    func testGetAllDataTenPersonAnd3Label() {
        
        // Save people and labels into database.
        for item in personArray {
            _ = db!.saveProfileToDatabase(profile: item!)
        }
        for item in labelArray {
            _ = db!.saveLabelToDatabase(label: item!)
        }
        
        // We can remove the objects we've stored here, so remove cyclic references.
        for item in 0..<personArray.count {
            personArray[item]?.clearAll()
        }
        
        for item in 0..<labelArray.count {
            labelArray[item]?.clearAll()
        }
        
        // Destroy objects here.
        personArray.removeAll()
        labelArray.removeAll()
        
        // Reconstruct objects, and check to make sure they're ok.
        let bank = db!.getAllData()
        
        personArray = bank.getPeople()
        labelArray = bank.getLabels()
        
        // Make sure the objects that were stored originally have the values we expect!
        for indexOfPerson in 0..<personArray.count {
            let personInfo = personArray[indexOfPerson]!.getInfo()
            XCTAssertTrue(personInfo.pathToPhoto == "test\(indexOfPerson).jpg", "The photo path does not match!")
            XCTAssertTrue(personInfo.firstName == "First\(indexOfPerson)", "First name does not match!")
            XCTAssertTrue(personInfo.lastName == "Last\(indexOfPerson)", "Last name does not match!")
            XCTAssertTrue(personInfo.email == "r\(indexOfPerson)@sfu.ca", "The email does not match!")
            XCTAssertTrue(personInfo.address == "\(indexOfPerson) Street", "The address does not match!")
            XCTAssertFalse(personInfo.hasHouseKeys, "The person is not supposed to have keys!")
            for label in labelArray {
                XCTAssertTrue(personInfo.labels.contains(label!),"The label is supposed to be in this array, but it's not!")
            }
        }
        
    }
    
    /// Test to see if we can save a profile to the database, change the name of the profile, and update the database.
    func testUpdateProfileEverything() {
        // Save the original profile and label to the database.
        // This should have Ryan Lui as the first and last name, respectively.
        _ = person01!.add(label: label01!)
        _ = db?.saveLabelToDatabase(label: label01!)
        _ = db?.saveProfileToDatabase(profile: person01!)
        
        // Now make a change to this person.
        _ = person01!.setInfo(pathToPhoto: "coolsauce.jpg", firstName: "Ranbir", lastName: "Makkar", phoneNumber: "+16041231234", email: "aWholeNewWorld@sfu.ca", address: "124 Another Street", hasHouseKeys: true)
        
        // Now update the database.
        _ = db?.updateProfile(profile: person01!)
        
        // Get rid of this object first to simulate starting from scratch
        person01?.clearAll()
        label01?.clearAll()
        person01 = nil
        label01 = nil
        
        let bank = db?.getAllData()
        let infoToCheck = bank!.getPeople()[0].getInfo()
        // Should only be one person here, so we will access
        XCTAssertTrue(infoToCheck.pathToPhoto == "coolsauce.jpg", "Photo path doesn't match the change we made!")
        XCTAssertTrue(infoToCheck.firstName == "Ranbir", "First name doesn't match the change we made!")
        XCTAssertTrue(infoToCheck.lastName == "Makkar", "Last name doesn't match the change we made!")
        XCTAssertTrue(infoToCheck.phoneNumber == "+16041231234", "Phone number doesn't match the change we made!")
        XCTAssertTrue(infoToCheck.email == "aWholeNewWorld@sfu.ca", "Email doesn't match the change we made!")
        XCTAssertTrue(infoToCheck.address == "124 Another Street", "Address doesn't match the change we made!")
        XCTAssertTrue(infoToCheck.hasHouseKeys, "HasHouseKeys doesn't match the change we made!")
        
    }
    
    /// Test to see if we can save a profile to the database, change all fields of the profile, and then update the database.
    func testUpdateProfileNameOnly() {
        // Save the original profile to the database.
        // This should have Ryan Lui as the first and last name, respectively.
        _ = person01!.add(label: label01!)
        _ = db?.saveLabelToDatabase(label: label01!)
        _ = db?.saveProfileToDatabase(profile: person01!)
        
        // Now make a change to this person.
        _ = person01!.set(firstName: "Maple", lastName: "Tan")
        
        // Now update the database.
        _ = db?.updateProfile(profile: person01!)
        
        // Get rid of this object first to simulate starting from scratch
        person01?.clearAll()
        label01?.clearAll()
        person01 = nil
        label01 = nil
        
        let bank = db?.getAllData()
        let people = bank!.getPeople()
        
        // Should only be one person here, so we will access
        XCTAssertTrue(people[0].getName().firstName == "Maple", "First name doesn't match the change we made!")
        XCTAssertTrue(people[0].getName().lastName == "Tan", "Last name doesn't match the change we made!")
    }
    
    /// Test to see if we can save a label to the database, change its name, and then update the database.
    func testUpdateLabelDefault() {
        // Set a name for this label here so we know what we're looking for, and then
        // save this to the database.
        label01?.editLabel(name: "Cool Friends")
        _ = db!.saveLabelToDatabase(label: label01!)
        
        // Alright, now we'll change the name, and attempt to update it.
        label01?.editLabel(name: "Fishing Buddies")
        _ = db!.updateLabel(label: label01!)
        
        // Destroy the label object.
        label01 = nil
        
        // Fetch from the database.  There should only be one thing.
        let labelToTest = db!.getAllData().getLabels()[0]
        
        XCTAssertTrue(labelToTest.getName() == "Fishing Buddies", "The name was not correctly updated!")
        
    }
    
    /// Test to see if we can delete a label from the database
    func testDeleteLabel() {
        // Save the label to the database.
        _ = db!.saveLabelToDatabase(label: label01!)
        
        let idToDeleteLater = label01!.getId()
        
        // Destroy the label object, and fetch the labels from the database from scratch.
        label01 = nil
        
        var labelsFromDatabase = db!.getAllData().getLabels()
        XCTAssertTrue(labelsFromDatabase.count == 1, "Labels were not retrieved properly!")
        
        // Now delete.
        _ = db!.deleteLabelById(id: idToDeleteLater)
        
        // Fetch again, and check.
        labelsFromDatabase.removeAll()
        labelsFromDatabase = db!.getAllData().getLabels()
        XCTAssertTrue(labelsFromDatabase.count == 0, "The label was not deleted properly!")
        
    }
    
    /// Test to see if we can delete a person from the database.
    func testDeletePerson() {
        // First, make the person valid by adding a label, then save both to db.
        _ = person01!.add(label: label01!)
        _ = db!.saveLabelToDatabase(label: label01!)
        _ = db!.saveProfileToDatabase(profile: person01!)
        
        let idToDeleteLater = person01!.getId()
        
        // Destroy the label and person object, and fetch the labels from the database from scratch.
        label01?.clearAll()
        person01?.clearAll()
        label01 = nil
        person01 = nil
        
        var peopleFromDatabase = db!.getAllData().getPeople()
        XCTAssertTrue(peopleFromDatabase.count == 1, "People were not retrieved properly!")
        
        // Now delete.
        _ = db!.deleteProfileById(id: idToDeleteLater)
        
        // Fetch again, and check.
        peopleFromDatabase.removeAll()
        peopleFromDatabase = db!.getAllData().getPeople()
        XCTAssertTrue(peopleFromDatabase.count == 0, "The profile was not deleted properly!")
        
    }
}
