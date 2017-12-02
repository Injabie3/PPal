//
//  SelectPeopleForNewLabelTableViewController.swift
//  PPal
//
//  Created by Harry Gong on 11/30/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit
var peopleList = [Person]()

class SelectPeopleForNewLabelTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(false, animated: false)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    override func viewWillAppear(_ animated: Bool) {
        peopleList.removeAll()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let saveAlert = UIAlertController(title: "Are You Sure?", message: "Are you sure you want to add?", preferredStyle: .alert)
        
        let alertYes = UIAlertAction(title: "Yes", style: .destructive) { action in
            // PLEASE NOTE
            // The below line will need to be fixed when implementing the search bar with this.
            for people in peopleList {
                people.add(label: newLabel)
                _ = Database.shared.updateProfile(profile: people)
            }
            
            _ = Database.shared.updateLabel(label: newLabel)
            
            self.dismiss(animated: true, completion: nil)
        }
        
        let alertNo = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        saveAlert.addAction(alertYes)
        saveAlert.addAction(alertNo)
        
        present(saveAlert, animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return PeopleBank.shared.getPeople().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PersonTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PersonTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PersonTableViewCell.")
        }
        
        cell.profileImage.image = PeopleBank.shared.getPeople()[indexPath.row].getInfo().pathToPhoto.toImage
        cell.nameLabel.text = "\(PeopleBank.shared.getPeople()[indexPath.row].getName().firstName) \(PeopleBank.shared.getPeople()[indexPath.row].getName().lastName)"
        cell.phoneNumberLabel.text = PeopleBank.shared.getPeople()[indexPath.row].getInfo().phoneNumber
        
        // Include Mirac's colour alternating scheme.
        if (indexPath.row % 2) != 0 {
            cell.backgroundColor = UIColor .white
        }
        else {
            cell.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.93, alpha: 1.0)
        }
        
        return cell
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        //        var labelExists = Bool()
        //        labelExists = false
        //        for label in selectedLabels {
        //            if label == PeopleBank.shared.getLabels()[indexPath.row]{
        //                labelExists = true
        //            }
        //        }
        //
        //        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var peopleExists = Bool()
        peopleExists = false
        for people in peopleList {
            if people == PeopleBank.shared.getPeople()[indexPath.row] {
                peopleExists = true
            }
        }
        if !peopleExists {
            peopleList.append(PeopleBank.shared.getPeople()[indexPath.row])
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        else if peopleExists {
            let idToRemove = PeopleBank.shared.getPeople()[indexPath.row].getId()
            let indexToRemove = peopleList.index(where: {return $0.getId() == idToRemove})
            peopleList.remove(at: indexToRemove!)
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
