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

class HumanNetworkVC: UIViewController, CNContactPickerDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    var fromRoot = false
    var selectedContact1: CNContact = CNContact()
    @IBOutlet weak var listViewField: UIView!
    @IBOutlet weak var mapViewField: UIView!
    @IBOutlet weak var labelViewField: UIView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var labelTableView: UITableView! // The table view for the list of label
    @IBOutlet weak var listViewTableView: UITableView! // The table view for the list of people.
    
    // To implement the search bar
    var filteredArrayToSearch = [Person]()
    var filteredLabelArrayToSearch = [Label]()
    
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
        
        // Associate the search bar delegate
        searchBar.delegate = self
        
        filteredArrayToSearch = PeopleBank.shared.getPeople()
        filteredLabelArrayToSearch = PeopleBank.shared.getLabels()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Reload data upon loading this screen.
        filteredArrayToSearch = PeopleBank.shared.getPeople()
        filteredLabelArrayToSearch = PeopleBank.shared.getLabels()
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
            let addLabel = UIAlertAction(title: "Save", style: .default) { (action) in
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
            return filteredArrayToSearch.count // Use this to implement search bar.
            // return PeopleBank.shared.getPeople().count
            // return people.count
        }
        // Get the number of labels to display for the label list view.
        if tableView == self.labelTableView {
            return filteredLabelArrayToSearch.count
            // return PeopleBank.shared.getLabels().count
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
            
            // let person = PeopleBank.shared.getPeople()[indexPath.row]
            let person = self.filteredArrayToSearch[indexPath.row]
            
            cell.profileImage.image = person.getInfo().pathToPhoto.toImage
            cell.nameLabel.text = "\(person.getName().firstName) \(person.getName().lastName)"
            cell.phoneNumberLabel.text = person.getInfo().phoneNumber
            if (indexPath.row % 2) != 0 {
                cell.backgroundColor = UIColor .white
            }
            else {
                cell.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.93, alpha: 1.0)
            }
            return cell
        }
            
        else { // tableView == self.labelTableView {
            let cellIdentifier = "LabelTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? LabelTableViewCell  else {
                fatalError("The dequeued cell is not an instance of LabelTableViewCell.")
            }
            
            // Fetches the appropriate label for the data source layout.
            
            // let label = PeopleBank.shared.getLabels()[indexPath.row]
            let label = self.filteredLabelArrayToSearch[indexPath.row]
            
            cell.labelName.text = label.getName()
            if (indexPath.row % 2) != 0 {
                cell.backgroundColor = UIColor .white
            }
            else {
                cell.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.93, alpha: 1.0)
            }
            return cell
        }
        
    }
    
    /// Table view function to support swiping left for different options such as Edit and Delete
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // Program the Edit button for the label table view
        let editLabel = UITableViewRowAction(style: .default, title: "Edit") { action, index in
            
            let labelAlert = UIAlertController(title: "Edit Label", message: "", preferredStyle: .alert)
            // PLEASE NOTE
            // The below line will need to be fixed when implementing the search bar with this.
            let labels = PeopleBank.shared.getLabels()
            let label = labels[indexPath.row] // Get the label that was selected.
            
            labelAlert.addTextField { (textField) in
                textField.placeholder = "Label Name"
                textField.text = label.getName()
                textField.keyboardType = .default
            }
            
            let alertEditLabel = UIAlertAction(title: "Save", style: .default) { (action) in
                
                let labelName = labelAlert.textFields
                
                // Edit the label into the database and data model.
                // Also have to update each person in the database!
                for item in labelName! {
                    label.editLabel(name: item.text!)
                    _ = Database.shared.updateLabel(label: label)
                    for person in label.getPeople() {
                        _ = Database.shared.updateProfile(profile: person)
                    }
                }
                
                // Reload the table view.
                self.labelTableView.reloadData()
                
            }
            
            let alertCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            labelAlert.addAction(alertEditLabel)
            labelAlert.addAction(alertCancel)
            
            // Show the edit prompt.
            self.present(labelAlert, animated: true, completion: nil)
        }
        
        // Program the Delete button for the label table view.
        let deleteLabel = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            // Delete the row from the data source
            var ableToDelete = true // Represents: Can we delete this label?
            let labels = PeopleBank.shared.getLabels()
            let label = labels[indexPath.row]
            let labelAlert: UIAlertController?
            
            for person in label.getPeople() {
                if person.getLabels().count == 1 {
                    ableToDelete = false
                }
            }
            
            if ableToDelete {
                labelAlert = UIAlertController(title: "Warning", message: "Are you sure you want to delete this label?", preferredStyle: .alert)
                
                let alertYes = UIAlertAction(title: "Yes", style: .destructive) { action in
                    // PLEASE NOTE
                    // The below line will need to be fixed when implementing the search bar with this.
                    let peopleWithDeletedLabel = label.getPeople()
                    _ = Database.shared.deleteLabelById(id: label.getId())
                    _ = PeopleBank.shared.del(label: label)
                    
                    // Update each person in the database
                    for person in peopleWithDeletedLabel {
                        _ = Database.shared.updateProfile(profile: person)
                    }
                    
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
                let alertNo = UIAlertAction(title: "No", style: .cancel, handler: nil)
                
                labelAlert!.addAction(alertYes)
                labelAlert!.addAction(alertNo)
            }
            else { // Cannot delete!
                labelAlert = UIAlertController(title: "Error!", message: "Cannot delete this label, because there is a person that contains only this label!", preferredStyle: .alert)
                
                let alertOK = UIAlertAction(title: "OK", style: .default)
                
                labelAlert!.addAction(alertOK)
                
            }
            
            // Show the alert prompt.
            self.present(labelAlert!, animated: true, completion: nil)
        }
        
        // Program the Delete button for the Person List table view.
        let deletePerson = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            // Delete the row from the data source
            
            let personAlert = UIAlertController(title: "Warning", message: "Are you sure you want to delete this person?", preferredStyle: .alert)
            
            let alertYes = UIAlertAction(title: "Yes", style: .destructive) { action in
                // This line below was before we implemented the search bar.
                // let people = PeopleBank.shared.getPeople()
                let people = self.filteredArrayToSearch
                _ = Database.shared.deleteProfileById(id: people[indexPath.row].getId())
                _ = PeopleBank.shared.del(person: people[indexPath.row])
                
                // Make the table view consistent again.
                self.filteredArrayToSearch = PeopleBank.shared.getPeople()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            let alertNo = UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            personAlert.addAction(alertYes)
            personAlert.addAction(alertNo)
            
            // Confirm with the user if they want to delete the person.
            self.present(personAlert, animated: true, completion: nil)
        }
        
        editLabel.backgroundColor = .blue
        deleteLabel.backgroundColor = .red
        
        // Display the corresponding buttons in the table views when we swipe left.
        if tableView == listViewTableView {
            return [deletePerson]
        }
        else { // tableView == labelTableView {
            return [editLabel, deleteLabel]
            
        }
    }
    
    /// Table view function to support tapping on a row.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If we tap on a contact, we want to be able to go view the details of this person.
        if tableView == listViewTableView {
            let person = filteredArrayToSearch[indexPath.row]
            let edit = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddContactVC") as! AddContactVC
            edit.person = person
            navigationController?.pushViewController(edit, animated: true)
            
        }
            
        else if tableView == labelTableView {
            let label = filteredLabelArrayToSearch[indexPath.row]
            let peopleToPass = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PeopleFromLabelVC") as! PeopleFromLabelVC
            peopleToPass.peopleInLabel = label.getPeople()
            peopleToPass.label = label
            navigationController?.pushViewController(peopleToPass, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func unwindFromCreateProfileVC(unwindSegue: UIStoryboardSegue) {
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            filteredArrayToSearch = PeopleBank.shared.getPeople()
            filteredLabelArrayToSearch = PeopleBank.shared.getLabels()
        } else {
            filteredArrayToSearch = PeopleBank.shared.getPeople().filter { "\($0.getName().firstName) \($0.getName().lastName)".lowercased().contains(searchText.lowercased())}
            filteredLabelArrayToSearch = PeopleBank.shared.getLabels().filter { $0.getName().lowercased().contains(searchText.lowercased())}
        }
        self.listViewTableView.reloadData()
        self.labelTableView.reloadData()
    }
    
    // This will make the keyboard disappear when you tap away.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.resignFirstResponder()
        self.view.endEditing(true)
    }
    
}
