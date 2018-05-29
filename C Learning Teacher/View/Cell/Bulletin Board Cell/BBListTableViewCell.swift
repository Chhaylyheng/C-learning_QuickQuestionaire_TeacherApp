//
//  BBListTableViewCell.swift
//  C Learning Teacher
//
//  Created by kit on 3/7/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit

class BBListTableViewCell: UITableViewCell {

    @IBOutlet weak var bbCell: UIView!
    
    @IBOutlet weak var ccRange: UIButton!
    @IBOutlet weak var ccDate: UILabel!
    @IBOutlet weak var ccTotalSize: UILabel!
    @IBOutlet weak var ccName: UIButton!
    @IBOutlet weak var ccStudentWrite: UIImageView!
    @IBOutlet weak var ccAnonymous: UILabel!
    @IBOutlet weak var ccCharNum: UILabel!
    @IBOutlet weak var ccItemNum: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    

}
