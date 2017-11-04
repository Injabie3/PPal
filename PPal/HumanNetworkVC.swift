//
//  HumanNetworkVC.swift
//  PPal
//
//  Created by rmakkar on 10/30/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class HumanNetworkVC: UIViewController,  UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var ListViewField: UIView! // People List View
    @IBOutlet weak var MapViewField: UIView! // Map View
    @IBOutlet weak var LabelViewField: UIView! // Label List View
    @IBOutlet weak var Segment: UISegmentedControl!
    @IBOutlet weak var listViewTableView: UITableView! // The table view for the list of people.
    @IBOutlet weak var labelTableView: UITableView! // The table view for the list of label
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
    
    // Edit button pressed on the bar, will toggle the correct table view's edit mode.
    @IBAction func editPressed(_ sender: UIBarButtonItem) {
        // People List View
        if !ListViewField.isHidden {
            if !listViewTableView.isEditing {
                listViewTableView.setEditing(true, animated: true)
            }
            else {
                listViewTableView.setEditing(false, animated: true)
            }
        }
        // Label List View
        else if !LabelViewField.isHidden {
            if !labelTableView.isEditing {
                labelTableView.setEditing(true, animated: true)
            }
            else {
                labelTableView.setEditing(false, animated: true)
            }
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
    
    // Overloading this function as per StackOverflow to reload tableviews when we
    // come back from adding a label or person.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listViewTableView.reloadData()
        labelTableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAddTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Add to Human Network", message: "Add New Contact or New Label", preferredStyle: .actionSheet)
        let addNewContact = UIAlertAction(title: "Add New Contact", style: .default) { (action) in
            print("Add New Contact")
            self.performSegue(withIdentifier: "SegueToCreateProfile", sender: self)
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

    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    // Table view function to get the number of items to display.
    // This will need to be modified for both the label and people table views.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //return Database.shared.getAllData().numberOfPeople
        
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
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
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
        
        else { //tableView == self.labelTableView {
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func unwindFromCreateProfileVC(unwindSegue: UIStoryboardSegue){
    }
    
    /* @IBAction func DismissPopUp(_ sender: UIButton) {
         dismiss(animated: true, completion: nil)
     }*/

}
