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
    let PersonsTable = Table("persons")
    let Id = Expression<Int>("id")
    let PathToPhoto = Expression<String>("pathToPhoto")
    let FirstName = Expression<String>("firstName")
    let LastName = Expression<String>("lastName")
    let PhoneNumber = Expression<String>("phoneNumber")
    let Email = Expression<String>("email")
    let Address = Expression<String>("address")
    let HasHouseKeys = Expression<Bool>("hasHouseKeys")
    //we'll need to discuss how to store the labels ***
    
    //Establish connection to the database file
    let database = try Connection(fileUrl.path) //***** "fileUrl.path" needs to be replaced with reaql path <String>
    
    //Table creation
    //Which variables needs to be unique? needs to be discussed _mirac
    
    func createTable() -> Bool {
        
	let tryCreatingTable = self.PersonsTable.create { (table) in
	    table.column(self.Id, primaryKey: true)
	    table.column(self.PathToPhoto, unique: true)
       	    table.column(self.FirstName)
	    table.column(self.LastName)
	    table.column(self.PhoneNumber, unique: true)
	    table.column(self.Email, unique: true)
	    table.column(self.Address)
	    table.column(self.HasHouseKeys)
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
	let saveProfile = self.PersonsTable.insert(self.PathToPhoto <- pathToPhoto, self.FirstName <- firstName,
	   self.LastName <- lastName, self.PhoneNumber <- phoneNumber, self.Email <- email, self.Address <- address,
	   self.HasHouseKeys <- hasHouseKeys)
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
	    let profiles = try self.database.prepare(self.PersonsTable)
	    for profile in profiles {
	        if (id == profile[self.id]){
		    //can be modified to create an persons object instead of printing
		    print("userId: \(profile[self.id]), firstName: \(profile[self.firstName]), lastName: \(profile[self.lastName]), phoneNumber: \(profile[self.phoneNumber]), email: \(profile[self.email]), address: \(profile[self.address]), hasHouseKeys: \(profile[self.hasHouseKeys])")
		}
	    }
	    return true
	} catch {
	    print(error)
	    return false
	}

    }


    func deleteProfileById(id: Int) -> Bool {
            
        let profile = self.PersonsTable.filter(self.id == id)
        let deleteProfile = profile.delete()
        do {
            try self.database.run(deleteProfile)
	    return true
        } catch {
	    print(error)
	    return false
        }

}
