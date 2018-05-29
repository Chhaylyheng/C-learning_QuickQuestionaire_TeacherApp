//
//  ReplyTableViewCell.swift
//  C Learning Teacher
//
//  Created by kit on 4/30/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit
import ImageSlideshow

class ReplyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var threadTextTextView: UITextView!
    @IBOutlet weak var threadTextHeight : NSLayoutConstraint!
    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet weak var imageButton1: UIButton!
    @IBOutlet weak var imageButton2: UIButton!
    @IBOutlet weak var imageButton3: UIButton!
    @IBOutlet weak var fileTitleButton1: UIButton!
    @IBOutlet weak var fileTitleButton2: UIButton!
    @IBOutlet weak var fileTitleButton3: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    @IBOutlet weak var file1StackView: UIStackView!
    @IBOutlet weak var file2StackView: UIStackView!
    @IBOutlet weak var file3StackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        file1StackView.isHidden = true
        file2StackView.isHidden = true
        file3StackView.isHidden = true
        slideshow.isHidden = true
        threadTextTextView.isHidden = true
        
        slideshow.backgroundColor = UIColor.white
        //slideshow.slideshowInterval = 0
        slideshow.pageControlPosition = PageControlPosition.underScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in
            print("current page:", page)
        }
        
        threadTextTextView.linkTextAttributes = [ NSAttributedStringKey.foregroundColor.rawValue: UIColor.blue ]
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
