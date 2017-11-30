//
//  EndQuizVC.swift
//  PPal
//
//  Created by Matthew Thomas on 11/14/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class EndQuizVC: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    var endPoints: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(endPoints)
        scoreLabel.text = "Score:" + String(endPoints)
    }
   
}
