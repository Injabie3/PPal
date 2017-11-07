//
//  TableViewController.swift
//  PPal
//
//  Created by LinuxPlus on 2017-11-04.
//  Copyright © 2017 CMPT275. All rights reserved.
//
import UIKit

var copyPerson = Person()
var buttonState = true
class EmergencySettingsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var list: UITableView!
    
    @IBOutlet weak var toggle: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggle.isOn =  UserDefaults.standard.bool(forKey: "switchState")
        list.isHidden = buttonState
        
        // use these the two below to enable multiselect (should also uncomment deSelectfunction below to work hand in hand)
        
        /* tableView.allowsMultipleSelectionDuringEditing = true
         tableView.setEditing(true, animated: false) */
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        cell.textLabel?.text = PeopleBank.shared.getPeople()[indexPath.row].getName().firstName + " " + PeopleBank.shared.getPeople()[indexPath.row].getName().lastName // get person name with index.row from peoplebank
        
        return cell
        
    }
    
    /* override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
     myindex.remove(at:myindex.index(of: indexPath.row)!)
     } */
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        copyPerson = PeopleBank.shared.getPeople()[indexPath.row]
        performSegue(withIdentifier: "backtomainmenu", sender: self)
        
    }
    
    
    
    @IBAction func toggle(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
        if sender.isOn {
            list.isHidden = false
            buttonState = false
        }
        else {
            list.isHidden = true
            buttonState = true
        }
    
    }
    
}
