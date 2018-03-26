//
//  ThreadTableViewCell.swift
//  C Learning Teacher
//
//  Created by kit on 3/11/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit

class ThreadTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var commentNum: UIButton!
    @IBOutlet weak var viewNum: UIButton!
    @IBOutlet weak var optionItem: UIButton!
    
    
    // MARK: - Dynamic Cell Height for Tweet with/without image
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    var defaultTweetImageViewHeightConstraint: CGFloat!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if imageHeight != nil && defaultTweetImageViewHeightConstraint != nil {
            imageHeight.constant = defaultTweetImageViewHeightConstraint
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
