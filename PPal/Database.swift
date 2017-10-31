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
    init (){
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
    
    //Table creation for Person class
    
    func createTableForLabel() {
        
        let tryCreatingLabelTable = self.labelTable.create { (table) in
            table.column(self.labelId, primaryKey: true)
            table.column(self.label, unique: true)
            print("Label Table Created!")
        }

        do {
            try self.database.run(tryCreatingLabelTable)
        } catch {
            print(error)
        }
 	
    }

    
    
    //Table creation for Person class
    
    func createTable() {
        
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
    
    
    
    //Taking in Label type and save it into database
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
    
    
    
    //Taking in Person type and save it into database
    func saveProfileToDatabase (profile: Person) -> Bool {
        
        var labelArray = [String]()
        for label in profile.getInfo().labels {
            labelArray.append(label.getName())
        }
        
        let labelString = labelArray.joined(separator: ",")
        
        //save profile entry to database
        let saveProfile = self.personsTable.insert(self.pathToPhoto <- profile.getInfo().pathToPhoto, self.firstName <- profile.getInfo().firstName,
                                                   self.lastName <- profile.getInfo().lastName, self.phoneNumber <- profile.getInfo().phoneNumber, self.email <- profile.getInfo().email,
                                                   self.address <- profile.getInfo().address, self.hasHouseKeys <- profile.getInfo().hasHouseKeys, self.labels <- labelString)
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
    func retrieveLabelById (id: Int) {
        
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
    func retrieveProfileById (id: Int) {

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
	

    //Only updating email address by user ID, need to discuss how this should work
    func updateProfile(id: Int, email: String) -> Bool {
            
        let profile = self.personsTable.filter(self.id == id)
        let updateProfile = profile.update(self.email <- email)
        do {
            try self.database.run(updateProfile)
            return true
        } catch {
            print(error)
            return false
        }
    }
	

}
