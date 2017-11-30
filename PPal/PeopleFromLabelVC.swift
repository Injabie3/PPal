//
//  PeopleFromLabelVC.swift
//  PPal
//
//  Created by Harry Gong on 11/29/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class PeopleFromLabelVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var peopleTableView: UITableView!
    var peopleInLabel: [Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        peopleTableView.delegate = self
        peopleTableView.dataSource = self
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
        let cellIdentifier = "PersonInLabelViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PersonInLabelViewCell  else {
            fatalError("The dequeued cell is not an instance of PersonInLabelViewCell.")
        }
        
        cell.imageOfPerson.image = peopleInLabel![indexPath.row].getInfo().pathToPhoto.toImage
        cell.nameOfPerson.text = peopleInLabel![indexPath.row].getName().firstName
        cell.phoneNumberOfPerson.text = peopleInLabel![indexPath.row].getInfo().phoneNumber
        
        
        
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
    

}
