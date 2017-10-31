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

    //Table variable declaration
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
    
    //we'll need to discuss how to store the labels ***
    //create document path URL if not existed
    init (){
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("persons").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
            self.createTable()
        } catch {
            print(error)
        }    //Establish connection to the database file
    }
    
    //Table creation
    //Which variables needs to be unique? needs to be discussed _mirac
    
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
            //again missing labels here***
        }

        do {
            try self.database.run(tryCreatingTable)
        } catch {
            print(error)
        }
 	
    }

	
    //can be modified to accept class type
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
            try self.database.run(saveProfile)
            return true
        } catch {
            print(error)
            return false
        }

    }
	
	


    func retrieveProfileById (id: Int) {

        let profile = self.personsTable.filter(self.id == id)
        //can be modified to create an persons object instead of printing
        print("userId: \(profile[self.id]), firstName: \(profile[self.firstName]), lastName: \(profile[self.lastName]), phoneNumber: \(profile[self.phoneNumber]), email: \(profile[self.email]), address: \(profile[self.address]), hasHouseKeys: \(profile[self.hasHouseKeys]), labels: \(profile[self.labels])")

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
