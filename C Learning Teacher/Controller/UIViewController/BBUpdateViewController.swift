//
//  BBUpdateViewController.swift
//  C Learning Teacher
//
//  Created by kit on 3/10/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BBUpdateViewController: UIViewController {
    
    @IBOutlet weak var bulletinName: UITextField!
    @IBOutlet weak var fair: DLRadioButton!
    @IBOutlet weak var failed: DLRadioButton!
    @IBOutlet weak var anonymous: DLRadioButton!
    @IBOutlet weak var instrucRegis: DLRadioButton!
    @IBOutlet weak var register: DLRadioButton!
    @IBOutlet weak var all: DLRadioButton!
    @IBOutlet weak var choice: DLRadioButton!
    @IBOutlet weak var none: DLRadioButton!
    
    let alert = SweetAlert()
    
    var ccID : String = ""
    var bulletin : String = ""
    var stuWrite : String = ""
    var nonymous : String = ""
    var stuRange : String = ""
    var radioSubmission : String = ""
    var radioAnonymous : String = ""
    var radioApplicable : String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        buttonStyle()
        dataValue()
        
//        print(" @@@@@@ ")
//        print(ccID, " ? ccID in Update controller")
//        print(bulletin)
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.orange
        self.navigationItem.title = "Edit Bulletin Board"
        
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
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
    
    func dataValue() {
        bulletinName.text = bulletin
        if stuWrite == "1" {
            fair.isSelected = true;
        } else {
            failed.isSelected = true;
        }
        
        if nonymous == "0" {
            anonymous.isSelected = true;
        } else if nonymous == "1" {
            instrucRegis.isSelected = true;
        } else {
            register.isSelected = true;
        }
        
        if stuRange == "0" {
            none.isSelected = true;
        } else if stuRange == "1" {
            choice.isSelected = true;
        } else {
            all.isSelected = true;
        }
    }
    
    @IBAction func SubmissionAction(_ sender: DLRadioButton) {
        if sender.tag == 1 {
            radioSubmission = "1"
        } else if sender.tag == 2 {
            radioSubmission = "0"
        } else {
            radioSubmission = stuWrite
        }
    }
    
    @IBAction func AnonymousAction(_ sender: DLRadioButton) {
        if sender.tag == 1 {
            radioAnonymous = "2"
        } else if sender.tag == 2 {
            radioAnonymous = "1"
        } else if sender.tag == 3 {
            radioAnonymous = "0"
        } else {
            radioAnonymous = nonymous
        }
    }
    
    @IBAction func ApplicableAction(_ sender: DLRadioButton) {
        if sender.tag == 1 {
            radioApplicable = "2"
        } else if sender.tag == 2 {
            radioApplicable = "1"
        } else if sender.tag == 3{
            radioApplicable = "0"
        } else {
            radioApplicable = stuRange
        }
    }
    
    
    
    @IBAction func Cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func UpdateAction(_ sender: Any) {
        bulletin = bulletinName.text!
        if (bulletinName.text?.isEmpty)! {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            PresentAlertController(title: "Warning", message: "Please Bulletin Board Name", actionTitle: "Okay")
        } else {
            updateBulletin()
        }
    }
    
    func updateBulletin() {
        Alamofire.request("https://kit.c-learning.jp/t/ajax/coop/cateedit", method: .post, parameters: ["ccID":ccID,"cc_name":bulletin, "cc_stuwrite":radioSubmission, "radioAnonymous": nonymous, "cc_sturange": radioApplicable]).responseJSON {
            response in
            if response.result.isSuccess {
                let result = JSON(response.result.value!)
                if result["mes"] == "sucess" {
                    
                    self.alert.showAlert("Done", subTitle: "Bulletin Board Updated", style: AlertStyle.none ,buttonTitle: "Okay") { Void in
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
