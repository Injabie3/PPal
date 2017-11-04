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
    var listOfPeople: PeopleBank? = PeopleBank.shared
    var arrayOfPeople: [Person?] = [Person]()
    var arrayOfLabels: [Label?] = [Label]()
    var mixedUpListOfPeopleToSort: [Person?] = [Person]()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Create objects
        label01 = Label()
        person01 = Person()
        listOfPeople = PeopleBank.shared
        listOfPeople!.clearAll()
        arrayOfPeople = [Person]()
        arrayOfLabels = [Label]()
        mixedUpListOfPeopleToSort = [Person]()
        
        for index in 0..<10 {
            arrayOfPeople.append(Person())
            _ = arrayOfPeople[index]!.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan \(index)", lastName: "Lui \(index)", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        }
        
        _ = person01!.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        
        label01!.editLabel(name: "Family")
        
        // Time to create different people with a photo, different names, phone numbers and email addresses
        for index in 0..<5 {
            mixedUpListOfPeopleToSort.append(Person())
            mixedUpListOfPeopleToSort[index]!.add(label: label01!)
        }
        _ = mixedUpListOfPeopleToSort[0]!.setInfo(pathToPhoto: "ayyy.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "16041234567", email: "myValidEmail@sfu.ca", address: "", hasHouseKeys: false)
        _ = mixedUpListOfPeopleToSort[1]!.setInfo(pathToPhoto: "andAnotherOne.png", firstName: "Ranbir", lastName: "Makkar", phoneNumber: "273733", email: "tryingToHaveSomeFun@sfu.ca", address: "", hasHouseKeys: false)
        _ = mixedUpListOfPeopleToSort[3]!.setInfo(pathToPhoto: "anotherOne.jpg", firstName: "Mirac", lastName: "Chen", phoneNumber: "234", email: "whatAmIDoing@sfu.ca", address: "", hasHouseKeys: false)
        _ = mixedUpListOfPeopleToSort[2]!.setInfo(pathToPhoto: "DJKhaled.jpg", firstName: "Maple", lastName: "Tan", phoneNumber: "123", email: "tryingToComeUpWithEmailsLike@sfu.ca", address: "", hasHouseKeys: false)
        _ = mixedUpListOfPeopleToSort[4]!.setInfo(pathToPhoto: "andAnother1.jpg", firstName: "Harry", lastName: "Gong", phoneNumber: "3456", email: "theLabIsEmptyAtNight@sfu.ca", address: "", hasHouseKeys: false)
        
        // Lets also create an array of labels to add to people that are different.
        for index in 0..<10 {
            arrayOfLabels.append(Label())
            arrayOfLabels[index]!.editLabel(name: "Another Label \(index)")
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        // Prepare to destroy objects.
        person01!.clearAll()
        label01!.clearAll()
        
        
        // Objects should be destroyed because this should be the last strong reference.
        person01 = nil
        label01 = nil
        listOfPeople = nil
        for index in 0..<10 {
            arrayOfPeople[index]!.clearAll()
        }
        arrayOfPeople.removeAll()
        arrayOfPeople = [nil]
        
        for index in 0..<mixedUpListOfPeopleToSort.count {
            mixedUpListOfPeopleToSort[index]!.clearAll()
        }
        mixedUpListOfPeopleToSort.removeAll()
        mixedUpListOfPeopleToSort = [nil]
        
        for index in 0..<arrayOfLabels.count {
            arrayOfLabels[index]!.clearAll()
        }
        arrayOfLabels.removeAll()
        arrayOfLabels = [nil]
    }
    
    /// Test to see if we can add a valid person to the PeopleBank
    func testAddValidPersonToBank() {
        person01!.add(label: label01!)
        
        let result = listOfPeople!.add(person: person01!)
        
        XCTAssertTrue(result, "Could not add a valid person to the bank!")
    }
    
    /// Test to see if we can add the same person into the PeopleBank
    func testAddValidPersonToBankTwice() {
        person01!.add(label: label01!)
        
        // Add the person into the bank.
        var result = listOfPeople!.add(person: person01!)
        result = listOfPeople!.add(person: person01!)
        
        XCTAssertFalse(result, "Could not add a valid person to the bank!")
    }
    
    /// Test to see if we can add two people with the same first and last name into the bank
    func testAddTwoValidPersonWithTheSameName() {
        arrayOfPeople[0]!.add(label: label01!)
        arrayOfPeople[0]!.add(label: label01!)
        
        _ = arrayOfPeople[0]!.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        
        _ = arrayOfPeople[1]!.setInfo(pathToPhoto: "aPathToAPhoto.jpg", firstName: "Ryan", lastName: "Lui", phoneNumber: "+16041234567", email: "rclui@sfu.ca", address: "123 Fake Street", hasHouseKeys: false)
        
        // Add the person into the bank.
        var result = listOfPeople!.add(person: arrayOfPeople[0]!)
        
        // This should fail, so it should be set to false.
        result = listOfPeople!.add(person: arrayOfPeople[1]!)
        
        XCTAssertFalse(result, "You managed to add two people with the same name in when this should not happen!")
    }
    
    /// Test to see if we can add a valid label to the bank.
    func testAddValidLabelToBank() {
        // Add the label into the bank
        let result = listOfPeople!.add(label: label01!)
        
        XCTAssertTrue(result, "Could not add the label even though it is valid!")
    }
    
    /// Test to see if we can add the same valid label twice.
    func testAddValidLabelToBankTwice() {
        // Add the label into the bank
        var result = listOfPeople!.add(label: label01!)
        // and then try to add it again.
        result = listOfPeople!.add(label: label01!)
        
        XCTAssertFalse(result, "You managed to add the label to the list even though it's already on the list!")
    }
    
    /// Test to see if we can add a valid label to the bank, and then remove it.
    func testRemoveLabelFromBankThatExistsInBank() {
        // Add the label into the bank
        var result = listOfPeople!.add(label: label01!)
        // and then remove it.
        result = listOfPeople!.del(label: label01!)
        
        XCTAssertTrue(result, "Could not remove the label even though it's supposed to exist in the bank!")
    }
    
    /**
     Test to see if a label that is associated to multiple people has its references removed from all
     of its people upon removal from the bank.
    */
    func testRemoveLabelAssociatedWithMultiplePeople() {
        
        // Add the label to the bank first.
        _ = listOfPeople!.add(label: label01!)
        
        // Associate multiple people with this label.
        for item in 0..<arrayOfPeople.count {
            arrayOfPeople[item]!.add(label: label01!)
            _ = listOfPeople!.add(person: arrayOfPeople[item]!)
            
            XCTAssertTrue(label01!.getPeople().contains(arrayOfPeople[item]!), "The label was not correctly added to person \(item)!")
        }
        
        // Alright, time to remove this label!!
        _ = listOfPeople!.del(label: label01!)
        
        // Time to check
        for item in 0..<arrayOfPeople.count {
            XCTAssertFalse(arrayOfPeople[item]!.getLabels().contains(label01!), "Even though this label was removed, it's still showing up in person \(item)!")
        }
        
    }
    
    /**
     Test to see if a person that is associated with multiple label has its references removed from all
     of its labels upon removal from the bank.
     */
    func testRemovePersonAssociatedWithMultipleLabels() {
        for item in 0..<arrayOfLabels.count {
            _ = listOfPeople!.add(label: arrayOfLabels[item]!)
            person01!.add(label: arrayOfLabels[item]!)
            
            XCTAssertTrue(arrayOfLabels[item]!.getPeople().contains(person01!), "The person was not correctly added to label \(item)!")
        }
        
        _ = listOfPeople!.add(person: person01!)
        
        // Alright, time to remove this person!
        _ = listOfPeople!.del(person: person01!)
        
        // Time to check
        for item in 0..<arrayOfLabels.count {
            XCTAssertFalse(arrayOfLabels[item]!.getPeople().contains(person01!), "Even though this person was removed, it's still showing up in label \(item)!")
        }
        
    }
    
    /**
     Test to see if the list is sorted correctly in alphabetical order.
     */
    func testSortingFirstName() {
        
        _ = listOfPeople!.add(label: label01!)
        
        for item in 0..<mixedUpListOfPeopleToSort.count {
            mixedUpListOfPeopleToSort[item]!.add(label: label01!)
            _ = listOfPeople!.add(person: mixedUpListOfPeopleToSort[item]!)
        }
        
        let list = listOfPeople!.getPeople()
        
        for item in 1..<list.count {
            XCTAssertTrue(list[item-1].getName().firstName < list[item].getName().firstName, "First names are not in alphabetical order!")
        }
        
    }
    

}
