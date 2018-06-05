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
import TLPhotoPicker


class ThreadCreateViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TLPhotosPickerViewControllerDelegate {
    var uploadedAlert = false
    var cameraCapture = 0
    let alert = SweetAlert()
    var bbID : String = ""
    var threadName : String = ""
    var threadDescrip : String = ""
    let url = "https://kit.c-learning.jp/uploadfile"
    var fileID = [String]()
    var mail = 0
    var selectedAssets = [TLPHAsset]()
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    
    @IBOutlet weak var NotifyStuCheckBox: UICheckbox!
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var threadDes: UITextView!
    @IBOutlet weak var threadTitle: UITextField!
    
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
            
            let viewController = CustomPhotoPickerViewController()
            viewController.delegate = self
            viewController.didExceedMaximumNumberOfSelection = { picker in
                print("Out of number of selection")
            }
            var configure = TLPhotosPickerConfigure()
            configure.numberOfColumn = 3
            viewController.configure = configure
            viewController.selectedAssets = self.selectedAssets
            viewController.logDelegate = self as? TLPhotosPickerLogDelegate
            
            self.present(viewController, animated: true, completion: nil)
            
        })
        
        let selectFile = UIAlertAction(title: "Dropbox", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            DBChooser.default().open(for: DBChooserLinkTypePreview, from: self, completion: { results in
                print(results)
                if results != nil {
                    print("true")
                }
                if (results?.count != 0) || results != nil {
                    for case let result as DBChooserResult in results! {
                        
                        var currentText = self.threadDes.text
                        if self.threadDes.text.isEmpty {
                            currentText?.append("\(result.link.absoluteString)")
                            self.threadDes.text = currentText
                        } else {
                            currentText?.append("\n\(result.link.absoluteString)")
                            self.threadDes.text = currentText
                        }
                    }
                } else {
                    print("no results")
                }
            })
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        let img1 = UIImage(named: "photo-camera")
        let img2 = UIImage(named: "photo-of-a-landscape")
        let img3 = UIImage(named: "dropbox-logo")
        takePhoto.setValue(img1, forKey: "image")
        selectFromLibrary.setValue(img2, forKey: "image")
        selectFile.setValue(img3, forKey: "image")
        
        alertController.addAction(takePhoto)
        alertController.addAction(selectFromLibrary)
        alertController.addAction(selectFile)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        self.selectedAssets = withTLPHAssets
        self.fileID.removeAll()
        for i in 0..<selectedAssets.count {
            let asset = self.selectedAssets[i]
            if asset.type == .video {
                // This is video
            }
            
            if let image = asset.fullResolutionImage {
                uploadImageRequest(image: image)
                if i == 0 {
                    self.imageView1.image = image
                    self.view1.isHidden = false
                } else if i == 1 {
                    self.imageView2.image = image
                    self.view2.isHidden = false
                } else {
                    self.imageView3.image = image
                    self.view3.isHidden = false
                }
                uploadedAlert = true
            }
        }
        
    }
    
    @IBAction func deleteButton1(_ sender: Any) {
        view1.isHidden = true
        selectedAssets.removeFirst()
        fileID.removeFirst()
    }
    @IBAction func deleteButton2(_ sender: Any) {
        view2.isHidden = true
        if selectedAssets.count == 1 {
            selectedAssets.removeFirst()
            fileID.removeFirst()
        } else if selectedAssets.count == 2 {
            selectedAssets.removeLast()
            fileID.removeLast()
        } else {
            selectedAssets.remove(at: 2)
            fileID.remove(at: 2)
        }
    }
    @IBAction func deleteButton3(_ sender: Any) {
        view3.isHidden = true
        selectedAssets.removeLast()
        fileID.removeLast()
    }
    func deselectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
        print("deselectedPhoto")
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
        
        view1.isHidden = true
        view2.isHidden = true
        view3.isHidden = true
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if uploadedAlert {
           self.showAlert(fromController: self)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismiss(animated: true, completion: nil)
        imageView1.image = image
        view1.isHidden = false
        cameraCapture = 1
        uploadedAlert = true
        uploadImageRequest(image: image)
    }
    
    func uploadImageRequest(image: UIImage) {
        let parameters = ["prefix": "_coop_"]
        guard let mediaImage = Media(withImage: image, forKey: "file") else { return }
        guard let url = URL(string: "https://kit.c-learning.jp/uploadfile") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = generateBoundary()

        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let dataBody = createDataBody(withParameters: parameters, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: String]
                    let hval = json["hval"]
                    self.fileID.append(hval!)
                    if self.fileID.count == self.selectedAssets.count {
                        self.uploadedAlert = false
                        self.dismiss(animated: false, completion: nil)
                        
                    }
                    if self.cameraCapture == 1 && self.fileID.count == 1 {
                        self.uploadedAlert = false
                        self.dismiss(animated: false, completion: nil)
                        self.cameraCapture = 0
                    }
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }

    func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value) \(lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    
    
    func creatingThread() {
        var fileID1 = ""
        var fileID2 = ""
        var fileID3 = ""
        for i in 0..<fileID.count {
            if i == 0{
                fileID1 = fileID[0]
            } else if i == 1 {
                fileID2 = fileID[1]
            } else {
                fileID3 = fileID[2]
            }
        }
        
        Alamofire.request("https://kit.c-learning.jp/t/ajax/coop/make_a_thread", method: .post, parameters: ["ct":"c398223976", "sID":bbID, "mode":"pcreate", "ttID":"id1", "ttName":"Professor Kimhak", "fileID1": fileID1, "fileID2": fileID2, "fileID3": fileID3, "c_title": threadName, "c_text": threadDescrip, "mail-student": mail, "c_no":"0"] ).responseJSON {
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

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
