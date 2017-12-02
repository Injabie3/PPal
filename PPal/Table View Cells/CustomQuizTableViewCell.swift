//
//  CustomQuizTableViewCell.swift
//  PPal
//
//  Created by Harry Gong on 12/1/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class CustomQuizTableViewCell: UITableViewCell {

    
    @IBOutlet weak var CustomQuizLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
