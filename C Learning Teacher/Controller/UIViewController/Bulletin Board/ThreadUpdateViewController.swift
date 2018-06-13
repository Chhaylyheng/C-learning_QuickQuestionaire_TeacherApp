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
import TLPhotoPicker

class ThreadUpdateViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, TLPhotosPickerViewControllerDelegate {
    
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
    var selectedAssets = [TLPHAsset]()
    var imagePicker = UIImagePickerController()
    var uploadedAlert = false
    
    var thread = [Thread]()
    var fileIDs = [String]()
    var fileExts = [String]()
    var fileName = [String]()
    var imageIDS = [String]()
    var imageExts = [String]()
    var captureImages = [UIImage]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenView()
        passDatatoUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if uploadedAlert {
            self.showAlert(fromController: self)
        }
    }
    
    func passDatatoUI() {
        threadNameTF.text = thread[0].cTitle
        bodyTV.text = thread[0].cText
        passfileDataToUI()
    }
    
    func passfileDataToUI() {
        if thread[0].fExt1 != nil {
            fileIDs.append(thread[0].fID1!)
            fileExts.append(thread[0].fExt1!)
            fileName.append(thread[0].fName1!)
            if thread[0].fExt1 == "png" ||  thread[0].fExt1 == "jpg" || thread[0].fExt1 == "jpeg" {
                view1.isHidden = false
                imageStack.isHidden = false
                let url = URL(string: "https://kit.c-learning.jp/getfile/s3file/\(thread[0].fID1!)")!
                imageView1.kf.setImage(with: url)
                
            } else {
                fileView1.isHidden = false
                fileLabel1.text = thread[0].fName1
            }
        }
        if thread[0].fExt2 != nil {
            fileIDs.append(thread[0].fID2!)
            fileExts.append(thread[0].fExt2!)
            fileName.append(thread[0].fName2!)
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
            fileIDs.append(thread[0].fID3!)
            fileExts.append(thread[0].fExt3!)
            fileName.append(thread[0].fName3!)
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
        fileIDs.removeFirst()
        fileExts.removeFirst()
        fileName.removeFirst()
    }
    
    @IBAction func deleteFile2(_ sender: Any) {
        // Case happen: only when there are two files
        fileView2.isHidden = true
        if fileIDs.count == 1 {
            fileIDs.removeFirst()
            fileExts.removeFirst()
            fileName.removeFirst()
        } else {
            if fileView1.isHidden == true && view1.isHidden == true {
                fileIDs.removeFirst()
                fileExts.removeFirst()
                fileName.removeFirst()
            } else {
                fileIDs.remove(at: 1)
                fileExts.remove(at: 1)
                fileName.remove(at: 1)
            }
        }
        
    }
    
    @IBAction func deleteFile3(_ sender: Any) {
        // Case happen: Only when there are 3 files
        fileView3.isHidden = true
        fileIDs.removeLast()
        fileExts.removeLast()
        fileName.removeLast()
    }
    
    @IBAction func deleteImage1(_ sender: Any) {
        view1.isHidden = true
        if fileExts[0] == "png" || fileExts[0] == "jpg" || fileExts[0] == "jpeg" {
            fileView1.isHidden = true
            fileName.removeFirst()
        } else if fileExts[0] == "xx" {
            captureImages.removeFirst()
        } else if fileExts[0] == "xy" {
            selectedAssets.removeFirst()
            imageExts.removeFirst()
            imageIDS.removeFirst()
        }
        
        fileIDs.removeFirst()
        fileExts.removeFirst()
        if fileIDs.count == 0 {
            imageStack.isHidden = true
        }
    }
    
    @IBAction func deleteImage2(_ sender: Any) {
        view2.isHidden = true
        
        if fileIDs.count == 1 {
            if fileExts[0] == "png" || fileExts[0] == "jpg" || fileExts[0] == "jpeg" {
                fileName.removeFirst()
            } else if fileExts[0] == "xx" {
                captureImages.removeFirst()
            } else {
                selectedAssets.removeFirst()
                imageIDS.removeFirst()
                imageExts.removeFirst()
            }
            
            fileIDs.removeFirst()
            fileExts.removeFirst()
        } else {
            if fileView1.isHidden == true && view1.isHidden == true {
                if fileExts[0] == "png" || fileExts[0] == "jpg" || fileExts[0] == "jpeg" {
                    fileName.removeFirst()
                } else if fileExts[0] == "xx" {
                    captureImages.removeFirst()
                } else {
                    selectedAssets.removeFirst()
                    imageIDS.removeFirst()
                    imageExts.removeFirst()
                }
                fileIDs.removeFirst()
                fileExts.removeFirst()
            } else {
                if fileExts[1] == "png" || fileExts[1] == "jpg" || fileExts[1] == "jpeg" {
                    fileName.remove(at: 1)
                } else if fileExts[1] == "xx" {
                    captureImages.remove(at: 1)
                } else {
                    selectedAssets.remove(at: 1)
                    imageIDS.remove(at: 1)
                    imageExts.remove(at: 1)
                }
                fileIDs.remove(at: 1)
                fileExts.remove(at: 1)
            }
        }
        
        if fileIDs.count == 0 {
            imageStack.isHidden = true
        }
    }
    
    @IBAction func deleteImage3(_ sender: Any) {
        view3.isHidden = true
        
        if fileExts.last == "png" || fileExts.last == "jpg" || fileExts.last == "jpeg" {
            fileName.removeLast()
        } else if fileExts.last == "xx" {
            captureImages.removeLast()
        } else {
            selectedAssets.removeLast()
            imageIDS.removeLast()
            imageExts.removeLast()
        }
        
        fileIDs.removeLast()
        fileExts.removeLast()
        if fileIDs.count == 0 {
            imageStack.isHidden = true
        }
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateAction(_ sender: Any) {
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
                self.PresentAlert(message: "Out of number selection", actionTitle: "okay")
            }
            var configure = TLPhotosPickerConfigure()
            let number = self.fileIDs.count - self.imageIDS.count
            
            switch number {
                case 3 :
                    configure.maxSelectedAssets = 0
                    break
                case 2 :
                    configure.maxSelectedAssets = 1
                    break
                case 1 :
                    configure.maxSelectedAssets = 2
                    break
                default:
                    configure.maxSelectedAssets = 3
                    break
            }
            viewController.configure = configure
            viewController.selectedAssets = self.selectedAssets
            viewController.logDelegate = self as? TLPhotosPickerLogDelegate
            
            self.present(viewController, animated: true, completion: nil)
            
        })
        
        let selectFile = UIAlertAction(title: "Dropbox", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            DBChooser.default().open(for: DBChooserLinkTypePreview, from: self, completion: { results in
                
                if (results?.count != 0) && results != nil {
                    for case let result as DBChooserResult in results! {
                        
                        var currentText = self.bodyTV.text
                        if self.bodyTV.text.isEmpty {
                            currentText?.append("\(result.link.absoluteString)")
                            self.bodyTV.text = currentText
                        } else {
                            currentText?.append("\n\(result.link.absoluteString)")
                            self.bodyTV.text = currentText
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
    
    
    @IBAction func sendBTN(_ sender: Any) {
        
        if notifyCheckBox.isSelected == true {
            mail = 1
        } else {
            mail = 0
        }
        
        threadTitle = threadNameTF.text!
        threadBody = bodyTV.text!
        
        if threadTitle.isEmpty && threadBody.isEmpty {
            self.PresentAlert(message: "Please enter thread information!", actionTitle: "okay")
        } else if threadTitle.isEmpty {
            self.PresentAlert(message: "Please enter thread name", actionTitle: "okay")
        } else if threadBody.isEmpty {
            self.PresentAlert(message: "Please enter body for thread", actionTitle: "okay")
        } else {
            updateThread()
        }
        
    }
    
    
    func indexOneDisplay() {
        if fileExts[0] == "png" || fileExts[0] == "jpg" || fileExts[0] == "jpeg" {
            view1.isHidden = false
            let url = URL(string: "https://kit.c-learning.jp/getfile/s3file/\(fileIDs[0])")!
            imageView1.kf.setImage(with: url)
        } else if fileExts[0] == "xx" {
            view1.isHidden = false
            imageView1.image = captureImages[0]
        } else if fileExts[0] == "xy" {
            view1.isHidden = false
            let asset = self.selectedAssets[0]
            if let img = asset.fullResolutionImage {
                imageView1.image = img
            }
        } else {
            fileView1.isHidden = false
            fileLabel1.text = fileName[0]
        }
    }
    
    
    func indexTwoDisplay() {
        if fileExts[1] == "png" || fileExts[1] == "jpg" || fileExts[1] == "jpeg" {
            view2.isHidden = false
            if fileName.count == 1 {
                let url = URL(string: "https://kit.c-learning.jp/getfile/s3file/\(fileIDs[0])")!
                imageView2.kf.setImage(with: url)
            } else {
                let url = URL(string: "https://kit.c-learning.jp/getfile/s3file/\(fileIDs[1])")!
                imageView2.kf.setImage(with: url)
            }
        } else if fileExts[1] == "xx" {
            view2.isHidden = false
            if captureImages.count == 0 {
                imageView2.image = captureImages[0]
            } else {
                imageView2.image = captureImages[1]
            }
        } else if fileExts[1] == "xy" {
            view2.isHidden = false
            if selectedAssets.count == 0 {
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
        } else {
            fileView2.isHidden = false
            if fileName.count == 1 {
                fileLabel2.text = fileName[0]
            } else {
                fileLabel2.text = fileName[1]
            }
        }
    }
    
    
    // MARK: After finish taking photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        hiddenView()
        imageStack.isHidden = false
        
        // Display Previous Image
        for i in 0..<fileIDs.count {
            if i == 0 {
                indexOneDisplay()
            } else if i == 1 {
                indexTwoDisplay()
            }
        }
        
        
        // Display and append new image
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismiss(animated: true, completion: nil)
        imageStack.isHidden = false
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
    
    
    
    // MARK: After dismiss the Photo Picker
    
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
                    if uploadedAlert == false {
                        uploadedAlert = true
                    }
                }
            }
        }
        
        
        hiddenView()
        
        // Display Images
        
        imageStack.isHidden = false
        for i in 0..<fileExts.count {
            if i == 0 {
                indexOneDisplay()
            } else if i == 1 {
                indexTwoDisplay()
            } else {
                // Only xy happen in this case
                view3.isHidden = false
                let asset = self.selectedAssets.last
                if let image = asset?.fullResolutionImage {
                    self.imageView3.image = image
                }
            }
        }
    }
    
    
    
    // MARK: Upload image to the server
    
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
                        self.dismiss(animated: false, completion: nil)
                        self.uploadedAlert = false
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
    
}


// MARK: API Request
extension ThreadUpdateViewController {
    
    func updateThread() {
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
            "mode":"pedit",
            "ttID":"id1",
            "ttName":"Professor Kimhak",
            "fileID1": fileID1,
            "fileID2": fileID2,
            "fileID3": fileID3,
            "c_title": threadTitle,
            "c_text": threadBody,
            "mail_student": "\(mail)",
            "c_no":cn
        ]
        
        print(parameters)
        
        Alamofire.request("https://kit.c-learning.jp/t/ajax/coop/make_a_thread", method: .post, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                let result = JSON(response.result.value!)
                print(result)
                
                self.alert.showAlert("Done", subTitle: "Thread was updated", style: AlertStyle.none ,buttonTitle: "okay") { Void in
                    self.dismiss(animated: true, completion: nil)
                }
                
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
        
    }
    
}


