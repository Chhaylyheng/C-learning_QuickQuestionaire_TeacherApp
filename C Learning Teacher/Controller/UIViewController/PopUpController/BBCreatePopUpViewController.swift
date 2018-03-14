//
//  BBCreatePopUpViewController.swift
//  C Learning Teacher
//
//  Created by kit on 3/8/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit

class BBCreatePopUpViewController: UIViewController, PopupContentViewController {
    
    @IBOutlet weak var bulletinName: UITextField!
    @IBOutlet weak var fair: DLRadioButton!
    @IBOutlet weak var failed: DLRadioButton!
    @IBOutlet weak var anonymous: DLRadioButton!
    @IBOutlet weak var register: DLRadioButton!
    @IBOutlet weak var instrucRegis: DLRadioButton!
    @IBOutlet weak var all: DLRadioButton!
    @IBOutlet weak var choice: DLRadioButton!
    @IBOutlet weak var none: DLRadioButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonStyle()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layer.cornerRadius = 5
    }
    
    class func instance() -> BBCreatePopUpViewController {
        let storyboard = UIStoryboard(name: "BBCreate", bundle: nil)
        return storyboard.instantiateInitialViewController() as! BBCreatePopUpViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sizeForPopup(_ popupController: PopupController, size: CGSize, showingKeyboard: Bool) -> CGSize {
        return CGSize(width: 350, height: 550)
    }
    
    func buttonStyle() {
        fair.layer.cornerRadius = 5
        fair.layer.borderWidth = 1
        failed.layer.cornerRadius = 5
        failed.layer.borderWidth = 1
        anonymous.layer.cornerRadius = 5
        anonymous.layer.borderWidth = 1
        register.layer.cornerRadius = 5
        register.layer.borderWidth = 1
        instrucRegis.layer.cornerRadius = 5
        instrucRegis.layer.borderWidth = 1
        all.layer.cornerRadius = 5
        all.layer.borderWidth = 1
        choice.layer.cornerRadius = 5
        choice.layer.borderWidth = 1
        none.layer.cornerRadius = 5
        none.layer.borderWidth = 1
        
    }
    
    
    
}
