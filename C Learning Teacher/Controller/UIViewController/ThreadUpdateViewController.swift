//
//  ThreadUpdateViewController.swift
//  C Learning Teacher
//
//  Created by kit on 4/1/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ThreadUpdateViewController: UIViewController {
    
    var ctID = String()
    var bbID = String()
    var cn = String()
    var threadTitle = String()
    var threadBody = String()
    let alert = SweetAlert()
    
    @IBOutlet weak var threadNameTF: UITextField!
    @IBOutlet weak var bodyTV: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        dataValue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dataValue() {
        threadNameTF.text = threadTitle
        bodyTV.text = threadBody
        
    }

}


// MARK: Button Handler
extension ThreadUpdateViewController {
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBTN(_ sender: Any) {
        
        threadTitle = threadNameTF.text!
        threadBody = bodyTV.text!
        
        if (threadNameTF.text?.isEmpty)! {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            PresentAlertController(title: "Warning", message: "Please enter thread name", actionTitle: "Okay")
        }
        
        if (bodyTV.text?.isEmpty)! {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            PresentAlertController(title: "Warning", message: "Please enter body for thread", actionTitle: "Okay")
        }
        
        updateThread()
    }
}


// MARK: API Request
extension ThreadUpdateViewController {
    func updateThread() {
        
        print(ctID, " ? ctID Title")
        print(bbID, " ? bbID")
        print(cn, " ? cn")
        print(threadTitle, " ? thread Title")
        print(threadBody, " ? threadBody")
        
        Alamofire.request("https://kit.c-learning.jp/t/ajax/coop/CoopReply", method: .post, parameters: ["m":"edit","ct":"c398223976","cc":bbID,"cn":cn,"c_title":threadTitle,"c_text":threadBody]).responseJSON {
            response in
            if response.result.isSuccess {
                let result = JSON(response.result.value!)
                if result["data"] == 1 {
                    self.alert.showAlert("Done", subTitle: "Thread was Updated", style: AlertStyle.none ,buttonTitle: "Okay") { Void in
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    print("? Error")
                }
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
        
    }
    
}


