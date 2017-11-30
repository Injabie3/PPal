//
//  QuestionListTableViewCell.swift
//  PPal
//
//  Created by Mirac Chen on 11/25/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class QuestionListTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var questionPhoto: UIImageView!
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var selectedAns: UILabel!
    @IBOutlet weak var correctAns: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
