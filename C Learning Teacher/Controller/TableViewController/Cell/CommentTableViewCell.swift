//
//  CommentTableViewCell.swift
//  C Learning Teacher
//
//  Created by kit on 3/27/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileUser: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var postDateCell: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func replyComment(_ sender: Any) {
        
    }
    

}
