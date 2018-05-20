//
//  ThreadHeadTableViewCell.swift
//  C Learning Teacher
//
//  Created by kit on 4/30/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit

class ThreadHeadTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postdateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var imageImageView: UIImageView!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var seenButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        captionTextView.isScrollEnabled = false
        let fixedWidth = captionTextView.frame.size.width
        let newSize = captionTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        captionTextView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        captionTextView.linkTextAttributes = [ NSAttributedStringKey.foregroundColor.rawValue: UIColor.blue ]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
