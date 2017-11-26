//
//  QuizListTableViewCell.swift
//  PPal
//
//  Created by Mirac Chen on 11/25/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class QuizListTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var quizSessionNumber: UILabel!
    @IBOutlet weak var quizScore: UILabel!
    @IBOutlet weak var quizDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
