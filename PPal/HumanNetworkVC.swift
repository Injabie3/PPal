//
//  HumanNetworkVC.swift
//  PPal
//
//  Created by rmakkar on 10/30/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class HumanNetworkVC: UIViewController {

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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //return Database.shared.getAllData().numberOfPeople
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "PersonTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PersonTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PersonTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        
        //personArray needs to be
        let person01 = Person()
        person01.setInfo(pathToPhoto: "", firstName: "Mirac", lastName: "Chen", phoneNumber: "1234", email: "hah@sfu.ca", address: "1234 fake street", hasHouseKeys: false)
        let person02 = Person()
        person02.setInfo(pathToPhoto: "", firstName: "Ranbir", lastName: "Makkar", phoneNumber: "4567", email: "cool@sfu.ca", address: "123 Fake Ave", hasHouseKeys: false)
        //let personArray = Database.shared.getAllData().getPeople()[indexPath.row]
        let personArray = person01
        let fullName = "\(personArray.getName().firstName) \(personArray.getName().lastName)"
        
        cell.nameLabel.text = fullName
        cell.phoneNumberLabel.text = personArray.getInfo().phoneNumber
        
        return cell
        
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
