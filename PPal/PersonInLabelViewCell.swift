//
//  PersonInLabelViewCell.swift
//  PPal
//
//  Created by Harry Gong on 11/29/17.
//  Copyright © 2017 CMPT275. All rights reserved.
//

import UIKit

class PersonInLabelViewCell: UITableViewCell {

    @IBOutlet weak var imageOfPerson: UIImageView!
    @IBOutlet weak var phoneNumberOfPerson: UILabel!
    @IBOutlet weak var nameOfPerson: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
