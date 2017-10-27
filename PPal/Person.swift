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
    
    try database.run(personsTable.create { (table) in
        table.column(self.id, primaryKey: true)
        table.column(self.pathToPhoto, unique: true)
        table.column(self.firstName)
        table.column(self.lastName)
        table.column(self.phoneNumber, unique: true)
        table.column(self.email, unique: true)
        table.column(self.address)
        table.column(self.hasHouseKeys)
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
            let saveProfile = self.personsTable.insert(self.pathToPhoto <- pathToPhoto, self.firstName <- firstName,
               self.lastName <- lastName, self.phoneNumber <- phoneNumber, self.email <- email, self.address <- address,
               self.hasHouseKeys <- hasHouseKeys)
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

