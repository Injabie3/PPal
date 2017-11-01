//
//  Database.swift
//  PPal
//
//  Created by Mirac Chen on 10/29/2017.
//  Copyright © 2017 CMPT275. All rights reserved.
//


import Foundation
import SQLite

class Database {

    //Table variable declaration for persons
    let personsTable = Table("persons")
    let id = Expression<Int>("id")
    let pathToPhoto = Expression<String>("pathToPhoto")
    let firstName = Expression<String>("firstName")
    let lastName = Expression<String>("lastName")
    let phoneNumber = Expression<String>("phoneNumber")
    let email = Expression<String>("email")
    let address = Expression<String>("address")
    let hasHouseKeys = Expression<Bool>("hasHouseKeys")
    let labels = Expression<String>("labels")
    var database: Connection!
    
    //Table variable declaration for labels
    let labelTable = Table("labels")
    let labelId = Expression<Int>("id")
    let label = Expression<String>("label")
    var labelDatabase: Connection!
    
    //we'll need to discuss how to store the labels ***
    //create document path URL if not existed
    init () {
        do {
            //creating persons database
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("persons").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            self.createTable()
            
            //creating labels database
            let labelDocumentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let labelFileUrl = labelDocumentDirectory.appendingPathComponent("labels").appendingPathExtension("sqlite3")
            let labelDatabase = try Connection(labelFileUrl.path)
            self.labelDatabase = labelDatabase
            self.createTableForLabel()
            
        } catch {
            print(error)
        }    //Establish connection to the database file
    }
    
    /// Table creation for Person class
    private func createTableForLabel() {
        
        let tryCreatingLabelTable = self.labelTable.create { (table) in
            table.column(self.labelId, primaryKey: true)
            table.column(self.label, unique: true)
            print("Label Table Created!")
        }

        do {
            try self.labelDatabase.run(tryCreatingLabelTable)
        } catch {
            print(error)
        }
 	
    }
    
    /// Table creation for Person class
    private func createTable() {
        
        let tryCreatingTable = self.personsTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.pathToPhoto, unique: true)
            table.column(self.firstName)
            table.column(self.lastName)
            table.column(self.phoneNumber, unique: true)
            table.column(self.email, unique: true)
            table.column(self.address)
            table.column(self.hasHouseKeys)
            table.column(self.labels)
            print("Person Table Created!")
        }
        
        do {
            try self.database.run(tryCreatingTable)
        } catch {
            print(error)
        }
        
    }
    
    /**
     Saves a label to the database for the first time.
     - parameter label: A Label object.
     - returns: true or false.
         - True if the label was saved to the database.
         - False if the label could not be saved.
     */
    func saveLabelToDatabase (label: Label) -> Bool {
        
        let saveLabel = self.labelTable.insert(self.label <- label.getName())
        do {
            let rowid = try self.labelDatabase.run(saveLabel)
            label.set(id: Int(truncatingBitPattern: rowid))
            print("Saved label (rowid: \(rowid)) to database")
            return true
        } catch {
            print(error)
            return false
        }
        
    }
    
    /**
     Saves a person to the database for the first time.
     - parameter profile: A Person object.
     - returns: true or false.
         - True if the person was saved to the database.
         - False if the person could not be saved.
     */
    func saveProfileToDatabase(profile: Person) -> Bool {
        
        var labelArray = [String]()
        for label in profile.getInfo().labels {
            labelArray.append(label.getName())
        }
        
        let labelString = labelArray.joined(separator: ",")
        
        // Save profile entry to database
        let saveProfile = self.personsTable.insert(self.pathToPhoto <- profile.getInfo().pathToPhoto,
                                                   self.firstName <- profile.getInfo().firstName,
                                                   self.lastName <- profile.getInfo().lastName,
                                                   self.phoneNumber <- profile.getInfo().phoneNumber,
                                                   self.email <- profile.getInfo().email,
                                                   self.address <- profile.getInfo().address,
                                                   self.hasHouseKeys <- profile.getInfo().hasHouseKeys,
                                                   self.labels <- labelString)
        do {
            let rowid = try self.database.run(saveProfile)
            profile.set(id: Int(truncatingBitPattern: rowid))
            print("Saved profile (rowid: \(rowid)) to database")
            return true
        } catch {
            print(error)
            return false
        }

    }
    
    //Search and return label by ID
    func retrieveLabelById(id: Int) {
        
        let label = self.labelTable.filter(self.labelId == id)
        do {
            let labels = try self.labelDatabase!.prepare(label)
            for selectedLabel in labels {
                print("labelID: \(selectedLabel[self.labelId]), label: \(selectedLabel[self.label])")
            }
        } catch {
            print (error)
        }
        
    }
    
	

    //Search and return profile by ID
    func retrieveProfileById(id: Int) {

        let profile = self.personsTable.filter(self.id == id)
        do {
            let people = try self.database!.prepare(profile)
            for person in people {
                print("userId: \(person[self.id]), firstName: \(person[self.firstName]), lastName: \(person[self.lastName]), phoneNumber: \(person[self.phoneNumber]), email: \(person[self.email]), address: \(person[self.address]), hasHouseKeys: \(person[self.hasHouseKeys]), labels: \(person[self.labels])")
            }
        } catch {
            print (error)
        }

    }



    /**
     Deletes a Person from the database
     - parameter id: The ID of the Person, which can be obtained from the getId() method of the person.
     - returns: true or false
         - True if the person was successfully deleted from the database.
         - False if the person could not be deleted.
     */
    //delete profile entry by ID
    func deleteProfileById(id: Int) -> Bool {
            
        let profile = self.personsTable.filter(self.id == id)
        let deleteProfile = profile.delete()
        do {
            try self.database.run(deleteProfile)
            return true
        } catch {
            print(error)
            return false
        }
    }
	
    /**
     Deletes a Label from the database
     - parameter id: The ID of the Label, which can be obtained from the getId() method of the label.
     - returns: true or false
         - True if the label was successfully deleted from the database.
         - False if the label could not be deleted.
     */
    func deleteLabelById(id: Int) -> Bool {
        
        let label = self.labelTable.filter(self.id == id)
        let deleteLabel = label.delete()
        do {
            try self.labelDatabase.run(deleteLabel)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    /**
     Updates a Person profile in the database.
     - parameter profile: A person object.
     - returns: true or false
         - True if the update was successful.
         - False if it could not be updated.
     */
    func updateProfile(profile: Person) -> Bool {
        
        var labelArray = [String]()
        for label in profile.getInfo().labels {
            labelArray.append(label.getName())
        }
        
        let labelString = labelArray.joined(separator: ",")
        
        let updateProfile = self.personsTable.update(self.pathToPhoto <- profile.getInfo().pathToPhoto,
                                                     self.firstName <- profile.getInfo().firstName,
                                                     self.lastName <- profile.getInfo().lastName,
                                                     self.phoneNumber <- profile.getInfo().phoneNumber,
                                                     self.email <- profile.getInfo().email,
                                                     self.address <- profile.getInfo().address,
                                                     self.hasHouseKeys <- profile.getInfo().hasHouseKeys,
                                                     self.labels <- labelString)
        do {
            try self.database.run(updateProfile)
            let rowid = profile.getId()
            print("Updated profile (rowid: \(rowid)) in database")
            return true
        } catch {
            print(error)
            return false
        }
        
        
    }
    
    
    /**
     Updates a Label in the database.
     - parameter label: A Label object.
     - returns: true or false
         - True if the update was successful.
         - False if it could not be updated.
     */
    func updateLabel(label: Label) -> Bool {
        

        let updateLabel = self.labelTable.update(self.label <- label.getName())
        do {
            try self.labelDatabase.run(updateLabel)
            let rowid = label.getId()
            print("Updated label (rowid: \(rowid)) in database")
            return true
        } catch {
            print(error)
            return false
        }

    }
    
    /**
     Builds the PeopleBank class from the database.
     
     - returns: A PeopleBank object.
     - by Ryan on Oct 31, 2017
     */
    func getAllData() -> PeopleBank {
        let bank = PeopleBank()
        
        do {
            let labelsInDatabase = try self.labelDatabase!.prepare(labelTable)
            for label in labelsInDatabase {
                print("Id: \(label[self.labelId]), name: \(label[self.label])")
                
                // Create a Label object per result, and add this label into the bank.
                let labelObject = Label()
                labelObject.set(id: label[self.labelId])
                labelObject.editLabel(name: label[self.label])
                
                _ = bank.add(label: labelObject)
            }
        } catch {
            print (error)
        }
        
        // At this point, all the labels are in the PeopleBank.
        let labelObjectArray = bank.getLabels()
        do {
            // Get all the people from the database.
            let peopleInDatabase = try self.database!.prepare(personsTable)
            
            for person in peopleInDatabase {
                print("userId: \(person[self.id]), firstName: \(person[self.firstName]), lastName: \(person[self.lastName]), phoneNumber: \(person[self.phoneNumber]), email: \(person[self.email]), address: \(person[self.address]), hasHouseKeys: \(person[self.hasHouseKeys]), labels: \(person[self.labels])")
                
                // For each person, construct a Person object with the information from the database.
                let personObject = Person()
                _ = personObject.setInfo(pathToPhoto: person[pathToPhoto],
                                         firstName: person[firstName],
                                         lastName: person[lastName],
                                         phoneNumber: person[phoneNumber],
                                         email: person[email],
                                         address: person[address],
                                         hasHouseKeys: person[hasHouseKeys])
                
                personObject.set(id: person[self.id])
                let labelTextArray = person[self.labels].components(separatedBy: ",")
                
                // Now add the labels that this person has to it.  Since we only have the names of the labels, we have to search for the label
                // object using this.
                for labelText in labelTextArray {
                    // Get the associated label object, and associate it with the person.
                    // If the label object doesn't exist, then don't add it to the person.
                    let labelIndex = labelObjectArray.index(where: { $0.getName().lowercased() == labelText.lowercased() })
                    if labelIndex != nil {
                        personObject.add(label: labelObjectArray[labelIndex!])
                    }
                }
                
                // Now this person object is ready, and we can now add it to the bank.
                _ = bank.add(person: personObject)
            }
        } catch {
            print (error)
        }
        
        return bank
    }
    
    
    
    
	

}
