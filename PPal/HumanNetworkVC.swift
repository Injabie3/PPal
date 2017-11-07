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

class HumanNetworkVC: UIViewController, CNContactPickerDelegate, UITableViewDelegate, UITableViewDataSource {
    var fromRoot = false
    var selectedContact1: CNContact = CNContact()
    @IBOutlet weak var listViewField: UIView!
    @IBOutlet weak var mapViewField: UIView!
    @IBOutlet weak var labelViewField: UIView!
    @IBOutlet weak var Segment: UISegmentedControl!
    
    @IBOutlet weak var labelTableView: UITableView! // The table view for the list of label
    @IBOutlet weak var listViewTableView: UITableView! // The table view for the list of people.
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.listViewField.isHidden = false
            self.mapViewField.isHidden = true
            self.labelViewField.isHidden = true
        case 1:
            self.listViewField.isHidden = true
            self.mapViewField.isHidden = false
            self.labelViewField.isHidden = true
        case 2:
            self.listViewField.isHidden = true
            self.mapViewField.isHidden = true
            self.labelViewField.isHidden = false
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Associate the table view data source and delegates
        listViewTableView.delegate = self
        listViewTableView.dataSource = self
        
        labelTableView.delegate = self
        labelTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Reload data upon loading this screen.
        listViewTableView.reloadData()
        labelTableView.reloadData()
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
                
                let labelName = labelAlert.textFields
                
                // Save the label into the database and data model.
                for item in labelName! {
                    let label = Label()
                    label.editLabel(name: item.text!)
                    _ = PeopleBank.shared.add(label: label)
                    _ = Database.shared.saveLabelToDatabase(label: label)
                    
                }
                // Reload the table view.
                self.labelTableView.reloadData()
                
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

    // Table view function to get the number of items to display.
    // This will need to be modified for both the label and people table views.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return Database.shared.getAllData().numberOfPeople
        
        // Get the number of people to display for the list view.
        if tableView == self.listViewTableView {
            return PeopleBank.shared.getPeople().count
            // return people.count
        }
        // Get the number of labels to display for the label list view.
        if tableView == self.labelTableView {
            return PeopleBank.shared.getLabels().count
        }
        return 1
    }
    
    // Table view function to display each item
    // This will need to be modified for both the label and people table views.
    // Should do a check for the respective table views.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        if tableView == self.listViewTableView {
            let cellIdentifier = "PersonTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PersonTableViewCell  else {
                fatalError("The dequeued cell is not an instance of PersonTableViewCell.")
            }
            
            // Fetches the appropriate person for the data source layout.
            
            let person = PeopleBank.shared.getPeople()[indexPath.row]
            
            cell.nameLabel.text = "\(person.getName().firstName) \(person.getName().lastName)"
            cell.phoneNumberLabel.text = person.getInfo().phoneNumber
            
            return cell
        }
            
        else { // tableView == self.labelTableView {
            let cellIdentifier = "LabelTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LabelTableViewCell  else {
                fatalError("The dequeued cell is not an instance of LabelTableViewCell.")
            }
            
            // Fetches the appropriate label for the data source layout.
            
            let label = PeopleBank.shared.getLabels()[indexPath.row]
            
            cell.labelName.text = label.getName()
            
            return cell
        }
        
    }
    
    // Table view function to support editing.
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if tableView == labelTableView {
            if editingStyle == .delete {
                // Delete the row from the data source
                let labels = PeopleBank.shared.getLabels()
                _ = Database.shared.deleteLabelById(id: labels[indexPath.row].getId())
                _ = PeopleBank.shared.del(label: labels[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
            // For the People List View
        else if tableView == listViewTableView {
            if editingStyle == .delete {
                // Delete the row from the data source
                let people = PeopleBank.shared.getPeople()
                _ = Database.shared.deleteProfileById(id: people[indexPath.row].getId())
                _ = PeopleBank.shared.del(person: people[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            } else if editingStyle == .insert {
                // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            }
        }
    }
    
    /// Table view function to support tapping on a row.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If we tap on a contact, we want to be able to go view the details of this person.
        if tableView == listViewTableView {
            let person = PeopleBank.shared.getPeople()[indexPath.row]
            let edit = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddContactVC") as! AddContactVC
            edit.person = person
            navigationController?.pushViewController(edit, animated: true)
            
        }
            
        else if tableView == labelTableView {
            let label = PeopleBank.shared.getLabels()[indexPath.row]
            //
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func unwindFromCreateProfileVC(unwindSegue: UIStoryboardSegue) {
    }
    
}
