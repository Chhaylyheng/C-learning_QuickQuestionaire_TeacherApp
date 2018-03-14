//
//  ThreadCreateViewController.swift
//  C Learning Teacher
//
//  Created by kit on 3/14/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ThreadCreateViewController: UIViewController {

    var bbID : String = ""
    var threadName : String = ""
    var threadDescrip : String = ""
    let alert = SweetAlert()
    
    @IBOutlet weak var threadDes: UITextView!
    @IBOutlet weak var threadTitle: UITextField!
    
    @IBAction func notifyStudent(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func RegisterThread(_ sender: Any) {
        //print(bbID, "id in creation")
        threadName = threadTitle.text!
        threadDescrip = threadDes.text
        
        if (threadTitle.text?.isEmpty)! {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            PresentAlertController(title: "Warning", message: "Please enter Thread Name", actionTitle: "Okay")
        } else if (threadDes.text?.isEmpty)! {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            PresentAlertController(title: "Warning", message: "Please some description for thread", actionTitle: "Okay")
        } else {
            createThread()
        }
    }
    
    func createThread() {
        Alamofire.request("https://kit.c-learning.jp/s/ajax/coop/res", method: .post, parameters: ["stID":"s566481448","stName":"Professor Kimhak", "mode":"pcreate", "ccID": bbID, "c_title": threadName, "c_text": threadDescrip, "ttID": "id1" ]).responseJSON {
            response in
            if response.result.isSuccess {
                let result = JSON(response.result.value!)
                
                self.alert.showAlert("Done", subTitle: "Thread was created", style: AlertStyle.none ,buttonTitle: "Okay") { Void in
                    self.dismiss(animated: true, completion: nil)
                }
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    
    

}
