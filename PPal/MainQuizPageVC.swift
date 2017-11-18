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
    
}
