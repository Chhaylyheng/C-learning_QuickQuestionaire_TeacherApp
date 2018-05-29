//
//  ThreadTableCell.swift
//  C Learning Teacher
//
//  Created by kit on 5/23/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit
import ImageSlideshow

protocol ThreadTableCellDelegate {
    func slideShowTapped(cell: ThreadTableCell)
}

class ThreadTableCell: UITableViewCell {
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet var optionMenuButton: UIButton!
    @IBOutlet weak var threadTitleLabel: UILabel!
    @IBOutlet weak var threadTextTextView: UITextView!
    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet weak var imageButton1: UIButton!
    @IBOutlet weak var imageButton2: UIButton!
    @IBOutlet weak var imageButton3: UIButton!
    @IBOutlet weak var fileTitleButton1: UIButton!
    @IBOutlet weak var fileTitleButton2: UIButton!
    @IBOutlet weak var fileTitleButton3: UIButton!
    @IBOutlet weak var threadTextHeight : NSLayoutConstraint!
    @IBOutlet weak var comButton : UIButton!
    @IBOutlet weak var seenButton : UIButton!
    
    @IBOutlet weak var file1StackView: UIStackView!
    @IBOutlet weak var file2StackView: UIStackView!
    @IBOutlet weak var file3StackView: UIStackView!
    
    var delegate: ThreadTableCellDelegate?
    @objc func cellTapped(sender: AnyObject) {
        delegate?.slideShowTapped(cell: self)
    }
    
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
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ThreadTableCell.cellTapped)))
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
