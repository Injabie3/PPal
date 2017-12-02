//
//  xLabelsTableViewController.swift
//  PPal
//
//  Created by Mirac Chen on 11/5/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class XLabelsTableViewController: UITableViewController {

    @IBOutlet weak var list: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // use these the two below to enable multiselect (should also uncomment deSelectfunction below to work hand in hand)
        
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.setEditing(false, animated: false)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return PeopleBank.shared.getLabels().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.textLabel?.text = PeopleBank.shared.getLabels()[indexPath.row].getName() // get person name with index.row from peoplebank
        for label in selectedLabels {

            if ((cell.textLabel?.text)! == label.getName()) {
                cell.accessoryType = .checkmark
            }
        }

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
        var labelExists = Bool()
        labelExists = false
        for label in selectedLabels {
            if label == PeopleBank.shared.getLabels()[indexPath.row] {
                labelExists = true
            }
        }
        if !labelExists {
            selectedLabels.append(PeopleBank.shared.getLabels()[indexPath.row])
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        else if labelExists {
            let idToRemove = PeopleBank.shared.getLabels()[indexPath.row].getId()
            let indexToRemove = selectedLabels.index(where: {return $0.getId() == idToRemove})
            selectedLabels.remove(at: indexToRemove!)
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        
        // I don't think we need the following line...
        self.tableView(tableView, didDeselectRowAt: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    @IBAction func donePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
