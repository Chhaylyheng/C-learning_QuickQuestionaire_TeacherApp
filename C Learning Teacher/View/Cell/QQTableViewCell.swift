//
//  QQTableViewCell.swift
//  C Learning Teacher
//
//  Created by kit on 3/20/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit

class QQTableViewCell: UITableViewCell {
    
    @IBOutlet weak var publics: UIButton!
    @IBOutlet weak var questionTitle: UIButton!
    @IBOutlet weak var answerNum: UIButton!
    @IBOutlet weak var preview: UIButton!
    @IBOutlet weak var dropDown: UIButton!
    @IBOutlet weak var totalResult: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
