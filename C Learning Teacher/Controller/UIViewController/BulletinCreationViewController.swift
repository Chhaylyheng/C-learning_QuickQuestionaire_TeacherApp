//
//  BulletinCreationViewController.swift
//  C Learning Teacher
//
//  Created by kit on 2/28/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BulletinCreationViewController: UIViewController {
    
    @IBOutlet weak var fair: DLRadioButton!
    @IBOutlet weak var failed: DLRadioButton!
    @IBOutlet weak var anonymous: DLRadioButton!
    @IBOutlet weak var register: DLRadioButton!
    @IBOutlet weak var instrucRegis: DLRadioButton!
    @IBOutlet weak var all: DLRadioButton!
    @IBOutlet weak var choice: DLRadioButton!
    @IBOutlet weak var none: DLRadioButton!
    @IBOutlet weak var bulletinName: UITextField!
    
    var bulletin : String = ""
    var submission : String = ""
    var nonymous : String = ""
    var applicable : String = ""
    let alert = SweetAlert()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonStyle()
        setUpNavBar()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submission(_ sender: Any) {
        if (sender as AnyObject).tag == 1 {
            submission = "1"
        } else {
            submission = "0"
        }
    }
    @IBAction func Anonymous(_ sender: Any) {
        if (sender as AnyObject).tag == 1 {
            nonymous = "2"
        } else if (sender as AnyObject).tag == 2 {
            nonymous = "1"
        } else {
            nonymous = "0"
        }
    }
    @IBAction func Aplicable(_ sender: Any) {
        if (sender as AnyObject).tag == 1 {
            applicable = "2"
        } else if (sender as AnyObject).tag == 2 {
            applicable = "1"
        } else {
            applicable = "0"
        }
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
    
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.orange
        self.navigationItem.title = "Bulletin Board Creation"
        
        //For back button in navigation bar
//        let backButton = UIBarButtonItem()
//        backButton.title = "Cancel"
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func createAction(_ sender: Any) {
        bulletin = bulletinName.text!
        if (bulletinName.text?.isEmpty)! {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            PresentAlertController(title: "Warning", message: "Please enter Bulletin Board Name", actionTitle: "Okay")
        } else if submission.isEmpty {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            PresentAlertController(title: "Warning", message: "Please select Student Article Submission", actionTitle: "Okay")
        } else if nonymous.isEmpty {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            PresentAlertController(title: "Warning", message: "Please select the Anonymous Option", actionTitle: "Okay")
        } else if applicable.isEmpty {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            PresentAlertController(title: "Warning", message: "Please select the Applicable Student Option", actionTitle: "Okay")
        } else {
            self.createBulletin()
        }
    }
    
    func createBulletin() {
        Alamofire.request("https://kit.c-learning.jp/t/ajax/coop/cateCreate", method: .post, parameters: ["ctID":"c398223976","cc_name":bulletin, "cc_stuwrite":submission, "cc_anonymous": nonymous, "cc_sturange": applicable]).responseJSON {
            response in
            if response.result.isSuccess {
                let result = JSON(response.result.value!)
                if result["mes"] == "success" {
                    
                    self.alert.showAlert("Done", subTitle: "Create a new Bulletin Board is Done", style: AlertStyle.none ,buttonTitle: "Okay") { Void in
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                } else {
                    
                }
                
            }
            else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    

}
