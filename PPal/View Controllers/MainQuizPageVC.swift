//
//  MainQuizPageVC.swift
//  PPal
//
//  Created by Maple Tan on 11/8/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class MainQuizPageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func unwindBackToQuizMenu(unwindSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func playPressed(_ sender: UIButton) {
        if PeopleBank.shared.getPeople().count < 4
        {
            let alert = UIAlertController(title: "Cannot Play Quiz", message: "You do not have at least four people in your contact list", preferredStyle: .alert)
            let alertAction =  UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    
}
