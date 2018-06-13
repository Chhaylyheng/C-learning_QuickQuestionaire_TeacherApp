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

// Start again


class ThreadCreateViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TLPhotosPickerViewControllerDelegate {
    
    var uploadedAlert = false
    let alert = SweetAlert()
    var bbID : String = ""
    var threadName : String = ""
    var threadDescrip : String = ""
    let url = "https://kit.c-learning.jp/uploadfile"
    var fileIDs = [String]()
    var fileExts = [String]()
    var imageIDS = [String]()
    var imageExts = [String]()
    var captureImages = [UIImage]()
    var mail = 0
    var selectedAssets = [TLPHAsset]()
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var NotifyStuCheckBox: UICheckbox!
    @IBOutlet weak var threadDes: UITextView!
    @IBOutlet weak var threadTitle: UITextField!
    
    @IBAction func selectFiles(_ sender: Any) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            if self.fileIDs.count != 3 {
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.imagePicker.sourceType = .camera
                    self.imagePicker.allowsEditing = false
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            } else {
                self.PresentAlert(message: "You already selected 3 images", actionTitle: "okay")
            }
        })
        
        let selectFromLibrary = UIAlertAction(title: "Photo Library", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            var configure = TLPhotosPickerConfigure()
            if self.captureImages.count == 0 {
                configure.maxSelectedAssets = 3
            } else if self.captureImages.count == 1 {
                configure.maxSelectedAssets = 2
            } else {
                configure.maxSelectedAssets = 1
            }
            
            let viewController = CustomPhotoPickerViewController()
            viewController.delegate = self
            viewController.didExceedMaximumNumberOfSelection = { picker in
                print("Out of number of selection")
            }
            configure.numberOfColumn = 3
            viewController.configure = configure
            viewController.selectedAssets = self.selectedAssets
            viewController.logDelegate = self as? TLPhotosPickerLogDelegate
            
            self.present(viewController, animated: true, completion: nil)
            
        })
        
        let selectFile = UIAlertAction(title: "Dropbox", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            DBChooser.default().open(for: DBChooserLinkTypePreview, from: self, completion: { results in

                if (results?.count != 0) && results != nil {
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
    
    
    // Remove the first element from the arrays
    func removeFirstElement() {
        if fileExts[0] == "xx" {
            captureImages.removeFirst()
            fileExts.removeFirst()
            fileIDs.removeFirst()
        } else {
            selectedAssets.removeFirst()
            fileExts.removeFirst()
            fileIDs.removeFirst()
            imageIDS.removeFirst()
            imageExts.removeFirst()
        }
    }
    
    
    @IBAction func deleteButton1(_ sender: Any) {
        view1.isHidden = true
        removeFirstElement()
    }
    
    @IBAction func deleteButton2(_ sender: Any) {
        view2.isHidden = true
        if fileIDs.count == 1 {
            removeFirstElement()
        } else {
            if fileExts[1] == "xx" {
                if captureImages.count == 1 {
                    captureImages.removeFirst()
                    fileExts.remove(at: 1)
                    fileIDs.remove(at: 1)
                } else {
                    captureImages.remove(at: 1)
                    fileExts.remove(at: 1)
                    fileIDs.remove(at: 1)
                }
            } else {
                if selectedAssets.count == 1 {
                    selectedAssets.removeFirst()
                    imageIDS.removeFirst()
                    imageExts.removeFirst()
                    fileExts.remove(at: 1)
                    fileIDs.remove(at: 1)
                } else {
                    selectedAssets.remove(at: 1)
                    imageIDS.remove(at: 1)
                    imageExts.remove(at: 1)
                    fileExts.remove(at: 1)
                    fileIDs.remove(at: 1)
                }
            }
        }
    }
    @IBAction func deleteButton3(_ sender: Any) {
        view3.isHidden = true
        if fileExts.last == "xx" {
            captureImages.removeLast()
            fileExts.removeLast()
            fileIDs.removeLast()
        } else {
            selectedAssets.removeLast()
            imageIDS.removeLast()
            imageExts.removeLast()
            fileExts.removeLast()
            fileIDs.removeLast()
        }
    }
    
    func deselectedPhoto(picker: TLPhotosPickerViewController, at: Int) {
        print("deselectedPhoto")
    }
    
    @IBAction func DoneAction(_ sender: Any) {
        threadName = threadTitle.text!
        threadDescrip = threadDes.text
        if NotifyStuCheckBox.isSelected == true {
            mail = 1
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
        
        hidenView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if uploadedAlert {
            self.showAlert(fromController: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hidenView() {
        view1.isHidden = true
        view2.isHidden = true
        view3.isHidden = true
    }
    
    
    // When finish taking the photo
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        hidenView()
        
        // Display Previous Image
        for i in 0..<fileIDs.count {
            if i == 0 {
                view1.isHidden = false
                if fileExts[0] == "xx" {
                    imageView1.image = captureImages[0]
                } else {
                    let asset = self.selectedAssets[0]
                    if let img = asset.fullResolutionImage {
                        imageView1.image = img
                    }
                }
            } else if i == 1 {
                view2.isHidden = false
                if fileExts[1] == "xx" {
                    if captureImages.count == 1 {
                        imageView2.image = captureImages[0]
                    } else {
                        imageView2.image = captureImages[1]
                    }
                } else {
                    if selectedAssets.count == 1 {
                        let asset = self.selectedAssets[0]
                        if let img = asset.fullResolutionImage {
                            imageView2.image = img
                        }
                    } else {
                        let asset = self.selectedAssets[1]
                        if let img = asset.fullResolutionImage {
                            imageView2.image = img
                        }
                    }
                }
            }
        }
        
        
        // Display and append new image
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismiss(animated: true, completion: nil)
        if fileIDs.count == 0 {
            view1.isHidden = false
            imageView1.image = image
            fileExts.append("xx")
        } else if fileIDs.count == 1 {
            view2.isHidden = false
            imageView2.image = image
            fileExts.append("xx")
        } else {
            view3.isHidden = false
            imageView3.image = image
            fileExts.append("xx")
        }
        
        uploadedAlert = true
        captureImages.append(image)
        uploadImageRequest(image: image)
    }
    
    
    
    // After choosing images from the Photo
    
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        let temporayAssets = selectedAssets
        self.selectedAssets = withTLPHAssets
        let tempImageID = imageIDS
        let tempImageEX = imageExts
        imageIDS.removeAll()
        imageExts.removeAll()
        
        for (j,k) in zip(fileIDs, fileExts) {
            if k == "xy" {
                let index = fileIDs.index(of: j)
                fileIDs.remove(at: index!)
                fileExts.remove(at: index!)
            }
        }
        
        for i in 0..<selectedAssets.count {
            let asset = self.selectedAssets[i]
            if asset.type == .video {
                // This is video
            }
            print(asset)
            print(asset.fullResolutionImage)
            
            if let image = asset.fullResolutionImage {
                if temporayAssets.contains(selectedAssets[i]) {
                    let indexofA = temporayAssets.index(of: selectedAssets[i])
                    fileIDs.append(tempImageID[indexofA!])
                    fileExts.append(tempImageEX[indexofA!])
                    imageIDS.append(tempImageID[indexofA!])
                    imageExts.append(tempImageEX[indexofA!])
                } else {
                    self.imageExts.append("xy")
                    self.fileExts.append("xy")
                    uploadImageRequest(image: image)
                    if uploadedAlert == false && imageExts.count == selectedAssets.count {
                        uploadedAlert = true
                    }
                }
            }
        }
        
        
        hidenView()
        
        // Display all the images
        
        for i in 0..<fileExts.count {
            if i == 0 {
                view1.isHidden = false
                if fileExts[0] == "xx" {
                    imageView1.image = captureImages[0]
                } else {
                    let asset = self.selectedAssets[0]
                    if let img = asset.fullResolutionImage {
                        imageView1.image = img
                    }
                }
            } else if i == 1 {
                view2.isHidden = false
                if fileExts[1] == "xx" {
                    if captureImages.count == 1 {
                        imageView2.image = captureImages[0]
                    } else {
                        imageView2.image = captureImages[1]
                    }
                } else {
                    if selectedAssets.count == 1 {
                        let asset = self.selectedAssets[0]
                        if let img = asset.fullResolutionImage {
                            imageView2.image = img
                        }
                    } else {
                        let asset = self.selectedAssets[1]
                        if let img = asset.fullResolutionImage {
                            imageView2.image = img
                        }
                    }
                }
            } else {
                view3.isHidden = false
                if fileExts[2] == "xx" {
                    if captureImages.count == 1 {
                        imageView3.image = captureImages[0]
                    } else if captureImages.count == 2 {
                        imageView3.image = captureImages[1]
                    } else {
                        imageView3.image = captureImages[2]
                    }
                } else {
                    if selectedAssets.count == 1 {
                        let asset = self.selectedAssets[0]
                        if let img = asset.fullResolutionImage {
                            imageView3.image = img
                        }
                    } else if selectedAssets.count == 2 {
                        let asset = self.selectedAssets[1]
                        if let img = asset.fullResolutionImage {
                            imageView3.image = img
                        }
                    } else {
                        let asset = self.selectedAssets[2]
                        if let img = asset.fullResolutionImage {
                            imageView3.image = img
                        }
                    }
                }
            }
        }
        
    }
    
    
    // For uploading images
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
                    self.fileIDs.append(hval!)
                    if self.fileExts.last == "xy" {
                        self.imageIDS.append(hval!)
                    }
                    
                    if self.fileIDs.count == self.fileExts.count {
                        self.uploadedAlert = false
                        self.dismiss(animated: false, completion: nil)
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
        for i in 0..<fileIDs.count {
            if i == 0{
                fileID1 = fileIDs[0]
            } else if i == 1 {
                fileID2 = fileIDs[1]
            } else {
                fileID3 = fileIDs[2]
            }
        }
        let parameters = [
            "ct":"c398223976",
            "sID":bbID,
            "mode":"pcreate",
            "ttID":"id1",
            "ttName":"Professor Kimhak",
            "fileID1": fileID1,
            "fileID2": fileID2,
            "fileID3": fileID3,
            "c_title": threadName,
            "c_text": threadDescrip,
            "mail-student": mail,
            "c_no":"0"
            ] as [String : Any]
        print(parameters)
        
        Alamofire.request("https://kit.c-learning.jp/t/ajax/coop/make_a_thread", method: .post, parameters: parameters ).responseJSON {
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
