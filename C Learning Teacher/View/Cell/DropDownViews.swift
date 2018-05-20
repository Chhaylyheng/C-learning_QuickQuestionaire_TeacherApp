//
//  ZBDropDownMenu.swift
//  zigbang_ios
//
//  Created by YiSeungyoun on 2017. 2. 13..
//  Copyright © 2017년 chbreeze. All rights reserved.
//

import UIKit
import YNDropDownMenu

class ZBFilterMemeView: YNDropDownView {
    @IBOutlet var tradeTypeSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var yesno: UIView!
    @IBOutlet weak var yesnocomment: UIView!
    @IBOutlet weak var agreedisagree: UIView!
    @IBOutlet weak var agreedisagreecomment: UIView!
    @IBOutlet weak var twochoices: UIView!
    @IBOutlet weak var twochoicescomment: UIView!
    @IBOutlet weak var threechoices: UIView!
    @IBOutlet weak var threechoicescomment: UIView!
    @IBOutlet weak var fourchoices: UIView!
    @IBOutlet weak var fourchoicescomment: UIView!
    @IBOutlet weak var fivechoices: UIView!
    @IBOutlet weak var fivechoicescomment: UIView!
    @IBOutlet weak var commentonly: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initViews()
    }
    @IBAction func confirmButtonClicked(_ sender: Any) {
        self.normalSelected(at: 1)
        self.hideMenu()
    }
    @IBAction func cancelButtonClicked(_ sender: Any) {
//        self.changeMenu(title: "Changed", at: 1)
//        self.changeMenu(title: "Changed", status: .selected, at: 0)
        self.alwaysSelected(at: 1)
//        self.alwaysSelected(at: 2)
//        self.alwaysSelected(at: 3)
        self.hideMenu()

    }
    
    override func dropDownViewOpened() {
        print("dropDownViewOpened")
    }
    
    override func dropDownViewClosed() {
        print("dropDownViewClosed")
    }

    func initViews() {
        
    }

}



