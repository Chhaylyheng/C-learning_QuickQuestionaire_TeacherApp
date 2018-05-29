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
import Photos
import UICheckbox_Swift

class ThreadCreateViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let alert = SweetAlert()
    var bbID : String = ""
    var threadName : String = ""
    var threadDescrip : String = ""
    let url = "https://kit.c-learning.jp/uploadfile"
    var hval : String = ""
    var mail = 0
    
    
    @IBOutlet weak var NotifyStuCheckBox: UICheckbox!
    @IBOutlet weak var uploadImage: UIImageView!
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var threadDes: UITextView!
    @IBOutlet weak var threadTitle: UITextField!
    
    @IBAction func notifyStudent(_ sender: Any){
        print("HELLO")
    }
    @IBAction func selectFiles(_ sender: Any) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            
        })
        
        let selectFromLibrary = UIAlertAction(title: "Photo Library", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.allowsEditing = false
                self.imagePicker.navigationBar.tintColor = .black
                self.imagePicker.navigationBar.titleTextAttributes = [
                    NSAttributedStringKey.foregroundColor : UIColor.black
                ]
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            
        })
        
        let selectFile = UIAlertAction(title: "File", style: .default, handler: { (alert: UIAlertAction!) -> Void in
//            let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF)], in: .import)
//            importMenu.delegate = self
//            importMenu.modalPresentationStyle = .formSheet
//            self.present(importMenu, animated: true, completion: nil)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        let img1 = UIImage(named: "photo-camera")
        let img2 = UIImage(named: "photo-of-a-landscape")
        let img3 = UIImage(named: "attach-icon")
        takePhoto.setValue(img1, forKey: "image")
        selectFromLibrary.setValue(img2, forKey: "image")
        selectFile.setValue(img3, forKey: "image")
        
        alertController.addAction(takePhoto)
        alertController.addAction(selectFromLibrary)
        alertController.addAction(selectFile)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func DoneAction(_ sender: Any) {
        threadName = threadTitle.text!
        threadDescrip = threadDes.text
        if NotifyStuCheckBox.isSelected == true {
            mail = 1
        } else {
            mail = 0
        }
        
        if (threadTitle.text?.isEmpty)! {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            PresentAlertController(title: "Warning", message: "Please enter Thread Name", actionTitle: "Okay")
        } else if (threadDes.text?.isEmpty)! {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            PresentAlertController(title: "Warning", message: "Please some description for thread", actionTitle: "Okay")
        } else {
            creatingThread()
        }
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        uploadImage.image = image
        
        let data = UIImageJPEGRepresentation(image, 1.0)
        // get the image path url
        //let imageURL = info[UIImagePickerControllerImageURL] as! NSURL
        //let fileName = imageURL.absoluteString
        
        dismiss(animated: true, completion: nil)
        requestWith(endUrl: url, imageData: data, parameters: ["prefix": "_coop_"])
    }
    
    
    
    func requestWith(endUrl: String, imageData: Data?, parameters: [String : Any], onCompletion: ((JSON?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        
        let headers: HTTPHeaders = [
            /* "Authorization": "your_access_token",  in case you need authorization header */
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData{
                multipartFormData.append(data, withName: "file", fileName: "imageName.jpeg", mimeType: "image/jpeg")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    print(response.result.value as Any)
                    
                    let repsoneResult = response.result.value as? NSDictionary
                    self.hval = repsoneResult!["hval"] as! String
                    print(self.hval)
                    
                    if let err = response.error{
                        onError?(err)
                        print(err)
                        return
                    }
                    onCompletion?(nil)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
    
    
    
    func createThread() {
        Alamofire.request("https://kit.c-learning.jp/s/ajax/coop/res", method: .post, parameters: ["stID":"s566481448","stName":"Professor Kimhak", "mode":"pcreate", "ccID": bbID, "c_title": threadName, "c_text": threadDescrip, "ttID": "id1" ]).responseJSON {
            response in
            if response.result.isSuccess {
                _ = JSON(response.result.value!)
                
                self.alert.showAlert("Done", subTitle: "Thread was created", style: AlertStyle.none ,buttonTitle: "Okay") { Void in
                    self.dismiss(animated: true, completion: nil)
                }
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    func creatingThread() {
        Alamofire.request("https://kit.c-learning.jp/t/ajax/coop/make_a_thread", method: .post, parameters: ["ct":"c398223976", "sID":bbID, "c_no":"0", "mode":"pcreate", "ttID":"id1", "ttName":"Professor Kimhak", "fileID1": hval, "c_title": threadName, "c_text": threadDescrip, "mail-student": mail] ).responseJSON {
            response in
            if response.result.isSuccess {
                _ = JSON(response.result.value!)
                
                self.alert.showAlert("Done", subTitle: "Thread was created", style: AlertStyle.none ,buttonTitle: "Okay") { Void in
                    self.dismiss(animated: true, completion: nil)
                }
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
}
