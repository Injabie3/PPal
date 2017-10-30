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
    //we'll need to discuss how to store the labels ***
    
    //Establish connection to the database file
    let database = try Connection(fileUrl.path) //***** "fileUrl.path" needs to be replaced with reaql path <String>
    
    //Table creation
    //Which variables needs to be unique? needs to be discussed _mirac
    
    func createTable() -> Bool {
        
	let tryCreatingTable = self.personsTable.create { (table) in
	    table.column(self.id, primaryKey: true)
	    table.column(self.pathToPhoto, unique: true)
       	    table.column(self.firstName)
	    table.column(self.lastName)
	    table.column(self.phoneNumber, unique: true)
	    table.column(self.email, unique: true)
	    table.column(self.address)
	    table.column(self.hasHouseKeys)
	    //again missing labels here***
	}

        do {
            try self.database.run(tryCreatingTable)
            return true
        } catch {
	    print(error)
            return false
        }
 	
    }

	
    //can be modified to accept class type
    func saveProfileToDataBase (
        pathToPhoto photo: String,
        firstName: String,
        lastName: String,
        phoneNumber: String,
        email: String,
        address: String,
        hasHouseKeys: Bool
	//labels: [Labels]
        ) -> Bool {
        
	//save profile entry to database
	let saveProfile = self.personsTable.insert(self.pathToPhoto <- pathToPhoto, self.firstName <- firstName,
	   self.lastName <- lastName, self.phoneNumber <- phoneNumber, self.email <- email, self.address <- address,
	   self.hasHouseKeys <- hasHouseKeys)
	do {
	    try self.database.run(saveProfile)
	    return true
	} catch {
	    print(error)
	    return false
	}

    }
	
	


    func retrieveProfileById (id: Int) -> Bool {

	do {
	    let profile = self.personsTable.filter(self.id == id)
	    //can be modified to create an persons object instead of printing
	    print("userId: \(profile[self.id]), firstName: \(profile[self.firstName]), lastName: \(profile[self.lastName]), phoneNumber: \(profile[self.phoneNumber]), email: \(profile[self.email]), address: \(profile[self.address]), hasHouseKeys: \(profile[self.hasHouseKeys])")
	    return true
	} catch {
	    print(error)
	    return false
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
	

}
