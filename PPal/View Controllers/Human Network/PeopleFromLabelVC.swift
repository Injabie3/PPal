//
//  PeopleFromLabelVC.swift
//  PPal
//
//  Created by Harry Gong on 11/29/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class PeopleFromLabelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var navTitle: UINavigationItem!
    
    @IBOutlet weak var peopleTableView: UITableView!
    var label: Label?
    var peopleInLabel: [Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        peopleTableView.delegate = self
        peopleTableView.dataSource = self
        
        if label != nil {
            navTitle.title = label?.getName()
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peopleInLabel!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "PersonTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PersonTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PersonTableViewCell.")
        }
        
        cell.profileImage.image = peopleInLabel![indexPath.row].getInfo().pathToPhoto.toImage
        cell.nameLabel.text = "\(peopleInLabel![indexPath.row].getName().firstName) \(peopleInLabel![indexPath.row].getName().lastName)"
        cell.phoneNumberLabel.text = peopleInLabel![indexPath.row].getInfo().phoneNumber
        
        // Include Mirac's colour alternating scheme.
        if (indexPath.row % 2) != 0 {
            cell.backgroundColor = UIColor .white
        }
        else {
            cell.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.93, alpha: 1.0)
        }
        
        return cell
    }
    
    /// Table view function to support tapping on a row.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // This does nothing for now, just deselects the cell if it's tapped.
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
