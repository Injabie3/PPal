//
//  HumanNetworkVC.swift
//  PPal
//
//  Created by rmakkar on 10/30/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class HumanNetworkVC: UIViewController, CNContactPickerDelegate {
    var fromRoot = false
    var selectedContact1: CNContact = CNContact()
    @IBOutlet weak var ListViewField: UIView!
    @IBOutlet weak var MapViewField: UIView!
    @IBOutlet weak var LabelViewField: UIView!
    @IBOutlet weak var Segment: UISegmentedControl!
    
    @IBAction func SegmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.ListViewField.isHidden = false
            self.MapViewField.isHidden = true
            self.LabelViewField.isHidden = true
        case 1:
            self.ListViewField.isHidden = true
            self.MapViewField.isHidden = false
            self.LabelViewField.isHidden = true
        case 2:
            self.ListViewField.isHidden = true
            self.MapViewField.isHidden = true
            self.LabelViewField.isHidden = false
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        self.selectedContact1 = contact
        picker.dismiss(animated: true) {
            self.performSegue(withIdentifier: "SegueToCreateProfile", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueToCreateProfile" {
            fromRoot = true
            let viewVC = segue.destination as! AddContactVC
            viewVC.contact1 = self.selectedContact1
            viewVC.isImported = fromRoot
        }
        if segue.identifier == "SegueToCreateNewProfile" {
            let viewVC = segue.destination as! AddContactVC
            viewVC.isImported = fromRoot
        }
    }
    
    @IBAction func onAddTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add to Human Network", message: "Add New Contact or New Label", preferredStyle: .actionSheet)
        let addNewContact = UIAlertAction(title: "Add New Contact", style: .default) { (action) in
            print("Add New Contact")
            self.onContactTapped(UIAlertAction())
        }
        let addNewLabel = UIAlertAction(title: "Add New Label", style: .default) { (action) in
            print("Add New Label")
            self.onLabelTapped(UIAlertAction())
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addNewContact)
        alert.addAction(addNewLabel)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onLabelTapped(_ sender: UIAlertAction?) {
        if sender != nil {
            let labelAlert = UIAlertController(title: "Add New", message: "Add New Label", preferredStyle: .alert)
            labelAlert.addTextField { (textField) in
                textField.placeholder = "Add New Label"
                textField.keyboardType = .default
            }
            let addLabel = UIAlertAction(title: "Add New Label", style: .default) { (action) in
                print("Add Label in second UIAlertController")
                self.performSegue(withIdentifier: "SegueToAddLabelToContacts", sender: self)
            }

            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            labelAlert.addAction(addLabel)
            labelAlert.addAction(cancel)
            present(labelAlert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func onContactTapped(_ sender: UIAlertAction?) {
        if sender != nil {
            let contactAlert = UIAlertController(title: "Add New Contact", message: "Add From Contacts or Create New Contact", preferredStyle: .actionSheet)
            let addFromContacts = UIAlertAction(title: "Add From Contacts", style: .default) { (action) in
                self.importFromContactsButton(UIAlertAction())
            }
            let createNew = UIAlertAction(title: "Create New Contact", style: .default) { (action) in
                self.performSegue(withIdentifier: "SegueToCreateNewProfile", sender: self)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            contactAlert.addAction(addFromContacts)
            contactAlert.addAction(createNew)
            contactAlert.addAction(cancel)
            present(contactAlert, animated: true, completion: nil)
        }
    }

    @IBAction func unwindFromCreateProfileVC(unwindSegue: UIStoryboardSegue){
    }
    
}
