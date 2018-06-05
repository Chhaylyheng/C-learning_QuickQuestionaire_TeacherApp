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
import UICheckbox_Swift
import Kingfisher

class ThreadUpdateViewController: UIViewController {
    
    @IBOutlet weak var threadNameTF: UITextField!
    @IBOutlet weak var bodyTV: UITextView!
    @IBOutlet weak var notifyCheckBox: UICheckbox!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageStack: UIStackView!
    @IBOutlet weak var fileView1: UIView!
    @IBOutlet weak var fileView2: UIView!
    @IBOutlet weak var fileView3: UIView!
    @IBOutlet weak var fileLabel1: UILabel!
    @IBOutlet weak var fileLabel2: UILabel!
    @IBOutlet weak var fileLabel3: UILabel!
    
    var ctID = String()
    var bbID = String()
    var cn = String()
    var threadTitle = String()
    var threadBody = String()
    let alert = SweetAlert()
    var mail = 0
    
    var thread = [Thread]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenView()
        passDatatoUI()
        print(thread)
    }
    
    func passDatatoUI() {
        threadNameTF.text = thread[0].cTitle
        bodyTV.text = thread[0].cText
        if thread[0].fExt1 != nil {
            if thread[0].fExt1 == "png" ||  thread[0].fExt1 == "jpg" || thread[0].fExt1 == "jpeg" {
                view1.isHidden = false
                imageStack.isHidden = false
                let url = URL(string: "https://kit.c-learning.jp/getfile/s3file/\(thread[0].fID1!)")!
                print(url)
                imageView1.kf.setImage(with: url)
                
            } else {
                fileView1.isHidden = false
                fileLabel1.text = thread[0].fName1
            }
        }
        if thread[0].fExt2 != nil {
            if thread[0].fExt2 == "png" ||  thread[0].fExt2 == "jpg" || thread[0].fExt3 == "jpeg" {
                view2.isHidden = false
                imageStack.isHidden = false
                let url = URL(string: "https://kit.c-learning.jp/getfile/s3file/\(thread[0].fID2!)")!
                imageView2.kf.setImage(with: url)
                
            } else {
                fileView2.isHidden = false
                fileLabel2.text = thread[0].fName2
            }
        }
        if thread[0].fExt3 != nil {
            if thread[0].fExt3 == "png" ||  thread[0].fExt3 == "jpg" || thread[0].fExt3 == "jpeg" {
                view3.isHidden = false
                imageStack.isHidden = false
                let url = URL(string: "https://kit.c-learning.jp/getfile/s3file/\(thread[0].fID3!)")!
                imageView3.kf.setImage(with: url)
                
            } else {
                fileView3.isHidden = false
                fileLabel3.text = thread[0].fName3
            }
        }
        
    }
    
    func hiddenView() {
        imageStack.isHidden = true
        view1.isHidden = true
        view2.isHidden = true
        view3.isHidden = true
        fileView1.isHidden = true
        fileView2.isHidden = true
        fileView3.isHidden = true
    }
    
}


// MARK: Button Handler
extension ThreadUpdateViewController {
    
    @IBAction func deleteFile1(_ sender: Any) {
        fileView1.isHidden = true
        thread[0].fID1?.removeAll()
    }
    
    @IBAction func deleteFile2(_ sender: Any) {
        fileView2.isHidden = true
        thread[0].fID2?.removeAll()
    }
    
    @IBAction func deleteFile3(_ sender: Any) {
        fileView3.isHidden = true
        thread[0].fID3?.removeAll()
    }
    
    @IBAction func deleteImage1(_ sender: Any) {
        view1.isHidden = true
        thread[0].fID1?.removeAll()
    }
    
    @IBAction func deleteImage2(_ sender: Any) {
        view2.isHidden = true
        thread[0].fID2?.removeAll()
    }
    
    @IBAction func deleteImage3(_ sender: Any) {
        view3.isHidden = true
        thread[0].fID3?.removeAll()
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBTN(_ sender: Any) {
        
        if notifyCheckBox.isSelected == true {
            mail = 1
        } else {
            mail = 0
        }
        
        threadTitle = threadNameTF.text!
        threadBody = bodyTV.text!
        
        if (threadNameTF.text?.isEmpty)! {
            self.PresentAlert(message: "Please enter thread name", actionTitle: "okay")
        }
        
        if (bodyTV.text?.isEmpty)! {
            self.PresentAlert(message: "Please enter body for thread", actionTitle: "okay")
        }
        
        updateThread()
    }
}


// MARK: API Request
extension ThreadUpdateViewController {
    func updateThread() {
        
        
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
    
    func testUpdating() {
        var ID1 = ""
        var ID2 = ""
        var ID3 = ""
        if thread[0].fID1?.count == 1 {
            ID1 = thread[0].fID1!
        }
        if thread[0].fID1?.count == 1 {
            ID2 = thread[0].fID2!
        }
        if thread[0].fID1?.count == 1 {
            ID3 = thread[0].fID3!
        }
        
        Alamofire.request("https://kit.c-learning.jp/t/ajax/coop/CoopRes.json", method: .post, parameters: ["m":"pedit","ct":"c398223976","cc":bbID,"cn":cn,"c_title":threadTitle,"c_text":threadBody, "c_file1":ID1, "c_file2":ID2, "c_file3":ID3, "mail_student": mail]).responseJSON {
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


