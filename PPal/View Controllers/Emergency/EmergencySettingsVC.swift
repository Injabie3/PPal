//
//  TableViewController.swift
//  PPal
//
//  Created by LinuxPlus on 2017-11-04.
//  Copyright © 2017 CMPT275. All rights reserved.
//
import UIKit

var copyPerson = Person()

class EmergencySettingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var list: UITableView!
    
    @IBOutlet weak var toggle: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggle.isOn =  UserDefaults.standard.bool(forKey: "switchState")
       
        
        // use these the two below to enable multiselect (should also uncomment deSelectfunction below to work hand in hand)
        
        /* tableView.allowsMultipleSelectionDuringEditing = true
         tableView.setEditing(true, animated: false) */
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        list.isHidden = !toggle.isOn
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return PeopleBank.shared.getPeople().count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PersonTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PersonTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PersonTableViewCell.")
        }
        
        // Fetches the appropriate person for the data source layout.
        
        // let person = PeopleBank.shared.getPeople()[indexPath.row]
        let person = PeopleBank.shared.getPeople()[indexPath.row]
        
        cell.profileImage.image = person.getInfo().pathToPhoto.toImage
        cell.nameLabel.text = "\(person.getName().firstName) \(person.getName().lastName)"
        cell.phoneNumberLabel.text = person.getInfo().phoneNumber
        if (indexPath.row % 2) != 0 {
            cell.backgroundColor = UIColor .white
        }
        else {
            cell.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.93, alpha: 1.0)
        }
       
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
//        cell.textLabel?.text = PeopleBank.shared.getPeople()[indexPath.row].getName().firstName + " " + PeopleBank.shared.getPeople()[indexPath.row].getName().lastName // get person name with index.row from peoplebank
        if (PeopleBank.shared.getPeople()[indexPath.row].getId() == UserDefaults.standard.integer(forKey: "emergencyID"))
        {
            cell.accessoryType = .checkmark
        }
        
        return cell
        
    }
    
    /* override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
     myindex.remove(at:myindex.index(of: indexPath.row)!)
     } */
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UserDefaults.standard.set(PeopleBank.shared.getPeople()[indexPath.row].getId(), forKey: "emergencyID")
        
        
        let numberOfRows = tableView.numberOfRows(inSection: 0)
        
        // Uncheck everything
        for index in 0..<numberOfRows {
            tableView.cellForRow(at: IndexPath(row: index, section: 0))?.accessoryType = .none
        }
        
        // Check only the one we selected.
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        // if UserDefaults.standard.integer(forKey: "emergencyID") == 0 {
        //    UserDefaults.standard.set(false, forKey: "switchState")
        //    
        // }
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func toggle(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
        if sender.isOn
        {
            list.isHidden = false
            
        }
        else
        {
            list.isHidden = true
            UserDefaults.standard.removeObject(forKey: "emergencyID")
        }
    
    }
    
}
