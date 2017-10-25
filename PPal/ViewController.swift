//
//  ViewController.swift
//  PPal
//
//  Created by rclui on 10/20/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var database: Connection!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        do {
            //create document and path URL
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, 
                in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("person").appendingPathExtension("sqlite3") //table name to be determined
            //make connection and create database
            let database = try Connection(fileUrl.path)
            self.database = database
            
        } catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

