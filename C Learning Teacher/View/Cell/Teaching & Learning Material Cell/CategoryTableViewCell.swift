//
//  CategoryTableViewCell.swift
//  C Learning Teacher
//
//  Created by kit on 5/25/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var CategoryNameLabel: UILabel!
    @IBOutlet weak var PublicLabel: UILabel!
    @IBOutlet weak var LastDateLabel: UILabel!
    @IBOutlet weak var CapacityLabel: UILabel!
    @IBOutlet weak var pushImageView: UIImageView!
    @IBOutlet weak var EditButton: UIButton!
    @IBOutlet weak var DeleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
