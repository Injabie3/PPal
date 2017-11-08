//
//  ViewController.swift
//  PPal
//
//  Created by rclui on 10/20/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ViewController: UIViewController, CNContactPickerDelegate {
    
    var selectedContact: CNContact = CNContact()
    var fromRoot = false
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func unwindFromCreateVC(unwindSegue: UIStoryboardSegue) {
    }

    @IBAction func importFromContactsButton(_ sender: Any) {
        let entityType = CNEntityType.contacts
        let authStatus = CNContactStore.authorizationStatus(for: entityType)
        
        if authStatus == CNAuthorizationStatus.notDetermined {
            
            let contactStore = CNContactStore.init()
            contactStore.requestAccess(for: entityType, completionHandler: { (success, nil) in
                if success {
                    self.openContacts()
                }
                else {
                    print("Not authorized")
                }
            })
        }
        else if authStatus == CNAuthorizationStatus.authorized {
            self.openContacts()
        }

    }
    
    func openContacts() {
        let contactPicker = CNContactPickerViewController.init()
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        picker.dismiss(animated: true)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        
        // When user selects a contact, do something here
        self.selectedContact = contact
        picker.dismiss(animated: true) {
            self.performSegue(withIdentifier: "SegueToCreateUserProfile", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        fromRoot = true
        if segue.identifier == "SegueToCreateUserProfile" {
            let viewVC = segue.destination as! CreateUserProfileVC
            viewVC.contact = self.selectedContact
            viewVC.isImported = fromRoot
        }
    }
    
}
