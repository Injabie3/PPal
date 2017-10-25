//
//  ViewController.swift
//  PPal
//
//  Created by rclui on 10/20/17.
//  Last modified by mirac on 10/24/2017
//  ***This view controller is only for profile creation page, should creat one view controller for each view _mirac
//  Reference: SQLite tutorial by Kilo Loco on YouTube
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import SQLite
//We also need to make use of the Persons class as well, I haven't implemented it yet _mirac 

class ViewController: UIViewController {
    
    var database: Connection!
    
    //Table creation and defining columns
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        do {
            //create document path URL if not existed
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, 
                in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("persons).appendingPathExtension("sqlite3") //table name to be determined
            //make connection and create database
            let database = try Connection(fileUrl.path)
            self.database = database
            
        } catch {
            print(error)
        }
    }
    
    
    //IBAction is a way to hook storyboard up to the custum code
    //This function is for table creation, NOT for profile creation, this should be called automatically when first user is added
    @IBAction func createTable(){
        //Which variables needs to be unique? needs to be discussed _mirac
        let createTable = self.personsTable.create { (table) in
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
        //***The following block should only run once - when the first user is created, so we NEED to move this block elsewhere,
        //I just put it here for reference***
        //***Start of block
        do {
            try self.database.run(createTable)
            print("Table created")
        } catch {
            print(error)
        }
        //***End of block
        
    }

    //Function for profile creation
    @IBAction func createProfile(){
        //The following code should only be run when the user inputs are obtained, i.e. self.firstName, self.lastName, etc. 
        //should already hold the values to be stored. Currently it will not work because all the variables are out
        //of scope and not set
        
        //User ID will be incremented and set automatically because it's set to be primaryKey above
        //how to set pathToPhoto and Labels not sure yet
        //we're also not sure if hasHouseKeys should be set here, but it's probably a good idea?
        
        let createProfile = self.personsTable.insert(self.pathToPhoto <- pathToPhoto, self.firstName <- firstName,
            self.lastName <- lastName, self.phoneNumber <- phoneNumber, self.email <- email, self.address <- address,
            self.hasHouseKeys <- hasHouseKeys)
        do {
            try self.database.run(createProfile)
            print("Profile created")
        } catch {
            print(error)
        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

