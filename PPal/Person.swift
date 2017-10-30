//
//  Person.swift
//  PPal
//
//  Created by rclui on 10/20/17.
//  Last modified by mirac on 10/27/2017
//  Copyright © 2017 CMPT275. All rights reserved.
//

import Foundation
import UIKit
import SQLite

class Person {
    init () {
        self.photo = nil
        //self.labels = []
    }
    
    private var photo: UIImage? // An image of the person. Not sure if we should use UIImage here, probably want a path here.
    private var firstName: String = ""
    private var lastName: String = ""
    private var phoneNumber: String = ""
    private var email: String = ""
    private var address: String = ""
    private var hasHouseKeys: Bool = false
    //private var labels: [Label]
    
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
    
    try database.run(PersonsTable.create { (table) in
        table.column(self.Id, primaryKey: true)
        table.column(self.PathToPhoto, unique: true)
        table.column(self.FirstName)
        table.column(self.LastName)
        table.column(self.PhoneNumber, unique: true)
        table.column(self.Email, unique: true)
        table.column(self.Address)
        table.column(self.HasHouseKeys)
        //again missing labels here***
    })


    func getName() -> String {
        if (firstName == "" || lastName == "") {
            return ""
        }
        else
        {
            return "\(firstName) \(lastName)"
        }
    }
    
    func setInfo (
        photo: UIImage?, //pathToPhoto?
        firstName: String,
        lastName: String,
        phoneNumber: String,
        email: String,
        address: String,
        hasHouseKeys: Bool
        //labels: [Labels]
        ) -> Bool {
        
        //Do error checking here.
        if (photo == nil || firstName == "" || lastName == "" || phoneNumber == "") {
            return false
        }
        else {
            self.photo = photo //pathToPhoto?
            self.firstName = firstName
            self.lastName = lastName
            self.phoneNumber = phoneNumber
            self.email = email
            self.address = address
            self.hasHouseKeys = hasHouseKeys
            
            
            //save profile entry to database
            let saveProfile = self.PersonsTable.insert(self.PathToPhoto <- pathToPhoto, self.FirstName <- firstName,
               self.LastName <- lastName, self.PhoneNumber <- phoneNumber, self.Email <- email, self.Address <- address,
               self.HasHouseKeys <- hasHouseKeys)
            do {
                try self.database.run(saveProfile)
                print("Profile saved")
            } catch {
                print(error)
            }   
            
            return true
            
        }
        
    }
    
    func getInfo() -> (
        photo: UIImage,firstName: String, lastName: String, phoneNumber: String, email: String, address: String, hasHouseKeys: Bool) {
            return (self.photo!, self.firstName, self.lastName, self.phoneNumber, self.email, self.address, self.hasHouseKeys)
    }
    
}

