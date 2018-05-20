//
//  QuestionsTableViewCell.swift
//  C Learning Teacher
//
//  Created by kit on 2/7/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit

class QuestionsTableViewCell: UITableViewCell {
    @IBOutlet weak var reveal: UILabel!
    
    @IBOutlet weak var DateNTime: UILabel!
    
    @IBOutlet weak var quest: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
