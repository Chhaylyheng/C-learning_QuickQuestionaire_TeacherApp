//
//  ThreadCommentViewController.swift
//  C Learning Teacher
//
//  Created by kit on 4/6/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import ImageSlideshow
import UICheckbox_Swift
import Kingfisher
import TLPhotoPicker

class ThreadCommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var fileView1: UIView!
    @IBOutlet weak var fileView2: UIView!
    @IBOutlet weak var fileView3: UIView!
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var inputViewContainer: UIView!
    @IBOutlet weak var replyNoticeView: UIView!
    @IBOutlet weak var notifyStudentView: UIView!
    
    @IBOutlet weak var fileName1: UILabel!
    @IBOutlet weak var fileName2: UILabel!
    @IBOutlet weak var fileName3: UILabel!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var replyNoticeCheckBox: UICheckbox!
    @IBOutlet weak var notifyStudentCheckBox: UICheckbox!
    @IBOutlet weak var replyNoticeButton: UIButton!
    @IBOutlet weak var notifyStudentButton: UIButton!
    @IBOutlet weak var replyToLabel: UILabel!
    
    var bottomConstraint: NSLayoutConstraint?
    var mainUserName : String = ""
    var userProfile_ids = [UserProfile]()
    let userProfileRequest:NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
    
    var ctID : String = ""
    var ccID : String = ""
    var anonymous : String = ""
    var ttName : String = ""
    var stName : String = ""
    var cNO : String = ""
    var username : String = ""
    var postDate : String = ""
    var threadTitle: String = ""
    var threadBody: String = ""
    var seenNum : String = ""
    var fID1 : String = ""
    var fID2 : String = ""
    var fID3 : String = ""
    var fSize1 : String = ""
    var fSize2 : String = ""
    var fSize3 : String = ""
    var fExt1 : String = ""
    var fExt2 : String = ""
    var fExt3 : String = ""
    var fName1 : String = ""
    var fName2 : String = ""
    var fName3 : String = ""
    var commentNum = 0
    
    var cNOs : NSArray = []
    var cBranch : NSArray = []
    var cRoots : NSArray = []
    var cParents : NSArray = []
    var cSorts : NSArray = []
    var usernames : NSArray = []
    var ttNames : NSArray = []
    var stNames : NSArray = []
    var postDates : NSArray = []
    var threadTexts : NSArray = []
    var fID1s : NSArray = []
    var fID2s : NSArray = []
    var fID3s : NSArray = []
    var fSize1s : NSArray = []
    var fSize2s : NSArray = []
    var fSize3s : NSArray = []
    var fExt1s : NSArray = []
    var fExt2s : NSArray = []
    var fExt3s : NSArray = []
    var fName1s : NSArray = []
    var fName2s : NSArray = []
    var fName3s : NSArray = []
    
    
    var commentAndReplyIndex = [Int]()
    var commentsIndex = [Int]()
    var replyIndex = [Int]()
    var wantedIndexes = [Int]()
    var cnoCR : String = ""
    var tempttName : String = ""
    var tempstName : String = ""
    var commentState = 0
    var emailOption = false
    var uploadedAlert = false
    var replyNoticeEnable = false
    var notifyStudentEnable = false
    
    let url = "https://kit.c-learning.jp/uploadfile"
    var fileIDs = [String]()
    var fileExts = [String]()
    var imageIDS = [String]()
    var imageExts = [String]()
    var fileNames = [String]()
    var captureImages = [UIImage]()
    var mailReply = 0
    var mailStudent = 0
    var selectedAssets = [TLPHAsset]()
    var imagePicker = UIImagePickerController()
    
    @IBAction func deleteFile1(_ sender: Any) {
        fileView1.isHidden = true
        removeFirstElement()
    }
    
    @IBAction func deleteFile2(_ sender: Any) {
        fileView2.isHidden = true
        if fileExts.count == 1 {
            removeFirstElement()
        } else {
            if fileExts[1] == "xx" {
                if captureImages.count == 1 {
                    captureImages.removeFirst()
                    fileNames.removeFirst()
                    fileExts.remove(at: 1)
                    fileIDs.remove(at: 1)
                } else {
                    captureImages.remove(at: 1)
                    fileNames.remove(at: 1)
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
    
    @IBAction func deleteFile3(_ sender: Any) {
        fileView3.isHidden = true
        if fileExts.last == "xx" {
            captureImages.removeLast()
            fileNames.removeLast()
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
    
    
    @IBAction func deleteReplyAction(_ sender: Any) {
        replyView.isHidden = true
        cnoCR = cNO
        tempttName = ttName
        tempstName = stName
        replyNoticeView.isHidden = true
        notifyStudentView.isHidden = true
        emailOption = false
        notifyStudentEnable = false
        replyNoticeEnable = false
        replyNoticeCheckBox.isSelected = false
        notifyStudentCheckBox.isSelected = false
    }
    
    
    
    @IBAction func notifyOptions(_ sender: Any) {
        if emailOption {
            replyNoticeView.isHidden = true
            notifyStudentView.isHidden = true
            emailOption = false
            
        } else {
            if tempttName.isEmpty {
                notifyStudentView.isHidden = false
                replyNoticeView.isHidden = false
                replyNoticeButton.setTitle("Reply Notice (\(tempstName))", for: .normal)
            } else {
                notifyStudentView.isHidden = false
            }
            emailOption = true
        }
    }
    
    @IBAction func replyNoticeAction(_ sender: Any) {
        if replyNoticeEnable {
            replyNoticeCheckBox.isSelected = false
            replyNoticeEnable = false
        } else {
            replyNoticeCheckBox.isSelected = true
            replyNoticeEnable = true
        }
    }
    
    
    @IBAction func notifyStudentAction(_ sender: Any) {
        if notifyStudentEnable {
            notifyStudentCheckBox.isSelected = false
            notifyStudentEnable = false
        } else {
            notifyStudentCheckBox.isSelected = true
            notifyStudentEnable = true
        }
    }
    
    
    
    @IBAction func takePhoto(_ sender: Any) {
        if self.fileNames.count != 3 {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        } else {
            self.PresentAlert(message: "You already captured 3 images. Delete some image if you want to catpure another one.", actionTitle: "okay")
        }
    }
    
    @IBAction func choosePhotos(_ sender: Any) {
        var configure = TLPhotosPickerConfigure()
        if self.fileNames.count == 0 {
            configure.maxSelectedAssets = 3
        } else if self.fileNames.count == 1 {
            configure.maxSelectedAssets = 2
        } else if self.fileNames.count == 2 {
            configure.maxSelectedAssets = 1
        } else {
            self.PresentAlert(message: "You already captured 3 images. Delete some image if you want to catpure another one.", actionTitle: "okay")
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
        
    }
    
    @IBAction func chooseFileFromDropbox(_ sender: Any) {
        DBChooser.default().open(for: DBChooserLinkTypePreview, from: self, completion: { results in
            
            if (results?.count != 0) && results != nil {
                for case let result as DBChooserResult in results! {
                    
                    var currentText = self.inputTextView.text
                    if self.inputTextView.text.isEmpty || self.inputTextView.textColor == UIColor.lightGray {
                        currentText = ""
                        currentText?.append("\(result.link.absoluteString)")
                        self.inputTextView.text = currentText
                    } else {
                        currentText?.append("\n\(result.link.absoluteString)")
                        self.inputTextView.text = currentText
                    }
                }
            } else {
                print("no results")
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        hideViews()
        
        cnoCR = cNO
        tempttName = ttName
        tempstName = stName
        
        tableview.delegate = self
        tableview.dataSource = self
        inputTextView.delegate = self
        
        // Placeholder for the UITextView
        inputTextView.text = "Write a comment ... "
        inputTextView.textColor = UIColor.lightGray
        inputTextView.selectedTextRange = inputTextView.textRange(from: inputTextView.beginningOfDocument, to: inputTextView.beginningOfDocument)
        
        tableview.estimatedRowHeight = tableview.rowHeight
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.separatorStyle = .none
        
        //Get the API and the data from coreData
        self.getCommentAPI()
        getUserName()
        
        
        // Move all the view up when keyboard display
        NotificationCenter.default.addObserver(self, selector: #selector(ThreadCommentViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ThreadCommentViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        // Set the constraint for the comment input field
        //view.addConstraintsWithFormat("H:|[v0]|", views: inputViewContainer)
        //view.addConstraintsWithFormat("V:[v0(83)]", views: inputViewContainer)
        //bottomConstraint = NSLayoutConstraint(item: inputViewContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        //view.addConstraint(bottomConstraint!)
        
        // Adding multiple cell to your tableview
        let nibName1 = UINib(nibName: "ThreadTableCell", bundle: nil)
        tableview.register(nibName1, forCellReuseIdentifier: "ThreadCell")
        
        let nibName2 = UINib(nibName: "CommentsTableViewCell", bundle: nil)
        tableview.register(nibName2, forCellReuseIdentifier: "commentCell")

        let nibName3 = UINib(nibName: "ReplyTableViewCell", bundle: nil)
        tableview.register(nibName3, forCellReuseIdentifier: "replyCell")
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if uploadedAlert {
            self.showAlert(fromController: self)
        }
    }
    
    
    // Remove the first element from the arrays
    func removeFirstElement() {
        if fileExts[0] == "xx" {
            captureImages.removeFirst()
            fileNames.removeFirst()
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
    
    
    // Move the view up when the keyboard show
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height + 5
            }
        }
    }

    // Move the view down when the keyboard hide
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
    // Placeholder Execution
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            if commentState == 0 {
                inputTextView.text = "Write a comment ... "
            } else {
                inputTextView.text = "Write a reply ... "
            }
            inputTextView.textColor = UIColor.lightGray
            
            inputTextView.selectedTextRange = inputTextView.textRange(from: inputTextView.beginningOfDocument, to: inputTextView.beginningOfDocument)
        } else if inputTextView.textColor == UIColor.lightGray && !text.isEmpty {
            inputTextView.textColor = UIColor.black
            inputTextView.text = text
        } else {
            return true
        }
        return false
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if inputTextView.textColor == UIColor.lightGray {
                inputTextView.selectedTextRange = inputTextView.textRange(from: inputTextView.beginningOfDocument, to: inputTextView.beginningOfDocument)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserName() {
        do {
            userProfile_ids = try manageObjectContext.fetch(userProfileRequest)
            for i in userProfile_ids {
                mainUserName = i.username!
            }
        }  catch {
            print(error)
        }

    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if inputTextView.textColor == UIColor.lightGray {
//            inputTextView.text = nil
//            inputTextView.textColor = UIColor.black
//
//        }
//
//    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if inputTextView.text.isEmpty {
            inputTextView.text = "Write a comment ..."
            inputTextView.textColor = UIColor.lightGray
            cnoCR = cNO
            tempttName = ttName
            tempstName = stName
        }
    }
    
    
    
    // Display the comment and reply
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wantedIndexes.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var items = [KingfisherSource]()
        
        if indexPath.row == 0 {
            let cell = tableview.dequeueReusableCell(withIdentifier: "ThreadCell", for: indexPath) as! ThreadTableCell
            
            cell.postDateLabel.text = postDate
            cell.threadTitleLabel.text = threadTitle
            cell.threadTextTextView.text = threadBody
            cell.comButton.setTitle("  \(commentNum)", for: .normal)
            cell.seenButton.setTitle("  \(seenNum)", for: .normal)
            if !threadBody.isEmpty {
                cell.threadTextTextView.isHidden = false
                cell.threadTextTextView.text = threadBody
                cell.threadTextHeight.constant = cell.threadTextTextView.contentSize.height
                
            }
            if anonymous == "2" {
                if stName.isEqual("<null>") {
                    cell.usernameLabel.text = ttName
                } else {
                    cell.usernameLabel.text = stName
                }
                
            } else {
                if ttName.isEqual("<null>") {
                    cell.usernameLabel.text = "Anonymous"
                } else {
                    cell.usernameLabel.text = ttName
                }
            }
            
            if !fExt1.isEqual("<null>") {
                if fExt1.isEqual("png") || fExt1.isEqual("jpeg") || fExt1.isEqual("jpg"){
                    items.append(KingfisherSource(urlString: "https://kit.c-learning.jp/getfile/s3file/\(fID1)")!)
                } else {
                    cell.file1StackView.isHidden = false
                    cell.fileTitleButton1.setTitle(fName1, for: .normal)
                }
            }
            if !fExt2.isEqual("<null>") {
                
                if fExt2.isEqual("png") || fExt2.isEqual("jpeg") || fExt2.isEqual("jpg") {
                    items.append(KingfisherSource(urlString: "https://kit.c-learning.jp/getfile/s3file/\(fID2)")!)
                } else {
                    cell.file2StackView.isHidden = false
                    cell.fileTitleButton2.setTitle(fName2, for: .normal)
                }
            }
            
            if !fExt3.isEqual("<null>") {
                
                if fExt3.isEqual("png") || fExt3.isEqual("jpeg") || fExt3.isEqual("jpg") {
                    items.append(KingfisherSource(urlString: "https://kit.c-learning.jp/getfile/s3file/\(fID3)")!)
                } else {
                    cell.file3StackView.isHidden = false
                    cell.fileTitleButton3.setTitle(fName3, for: .normal)
                }
            }
            
            if items.count > 0 {
                cell.slideshow.isHidden = false
                cell.slideshow.setImageInputs(items)
            }
            
            return cell
            
        } else if cNOs == [] {
            let cell = tableview.dequeueReusableCell(withIdentifier: "ThreadCell", for: indexPath) as! ThreadTableCell
            return  cell
        } else {
            let myIndex = wantedIndexes[indexPath.row - 1]
             if (cParents[myIndex] as AnyObject).isEqual(cNO) && (cBranch[myIndex] as AnyObject).isEqual("0") {
                
                let cell = tableview.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentsTableViewCell
                if anonymous == "2" {
                    cell.usernameLabel.text = usernames[myIndex] as? String
                } else {
                    if mainUserName.isEqual(usernames[myIndex]) {
                        cell.usernameLabel.text = mainUserName
                    } else {
                        cell.usernameLabel.text = "Anonymous"
                    }
                }
                if !(threadTexts[myIndex] as! String).isEmpty {
                    cell.threadTextTextView.text = threadTexts[myIndex] as? String
                    cell.threadTextHeight.constant = cell.threadTextTextView.contentSize.height
                    cell.threadTextTextView.isHidden = false
                }
                
                cell.postDateLabel.text = postDates[myIndex] as? String
                cell.replyButton.tag = myIndex
                cell.replyButton.addTarget(self, action: #selector(replyCommentButton), for: .touchUpInside)
                if fExt1s[myIndex] as? String == nil {
                    cell.slideshow.isHidden = true
                    cell.file1StackView.isHidden = true
                } else {
                    if fExt1s[myIndex] as? String == "png" || fExt1s[myIndex] as? String == "jpg"  || fExt1s[myIndex] as? String == "jpeg" {
                        cell.file1StackView.isHidden = true
                        items.append(KingfisherSource(urlString: "https://kit.c-learning.jp/getfile/s3file/\(fID1s[myIndex])")!)
                    } else {
                        cell.slideshow.isHidden = true
                        cell.file1StackView.isHidden = false
                        cell.fileTitleButton1.setTitle(fName1s[myIndex] as? String, for: .normal)
                        cell.fileTitleButton1.accessibilityHint = fID1s[myIndex] as? String
                        cell.fileTitleButton1.addTarget(self, action: #selector(openFileLink(_:)), for:.touchUpInside)
                    }
                }
                if fExt2s[myIndex] as? String == nil {
                    cell.slideshow.isHidden = true
                    cell.file2StackView.isHidden = true
                } else {
                    if fExt2s[myIndex] as? String == "png" || fExt2s[myIndex] as? String == "jpg"  || fExt2s[myIndex] as? String == "jpeg" {
                        cell.file2StackView.isHidden = true
                        items.append(KingfisherSource(urlString: "https://kit.c-learning.jp/getfile/s3file/\(fID2s[myIndex])")!)
                    } else {
                        cell.slideshow.isHidden = true
                        cell.file2StackView.isHidden = false
                        cell.fileTitleButton2.setTitle(fName2s[myIndex] as? String, for: .normal)
                        cell.fileTitleButton2.accessibilityHint = fID2s[myIndex] as? String
                        cell.fileTitleButton2.addTarget(self, action: #selector(openFileLink(_:)), for:.touchUpInside)
                    }
                }
                
                if fExt3s[myIndex] as? String == nil {
                    cell.slideshow.isHidden = true
                    cell.file3StackView.isHidden = true
                } else {
                    if fExt3s[myIndex] as? String == "png" || fExt3s[myIndex] as? String == "jpg"  || fExt3s[myIndex] as? String == "jpeg" {
                        cell.file3StackView.isHidden = true
                        items.append(KingfisherSource(urlString: "https://kit.c-learning.jp/getfile/s3file/\(fID3s[myIndex])")!)
                    } else {
                        cell.slideshow.isHidden = true
                        cell.file3StackView.isHidden = false
                        cell.fileTitleButton3.setTitle(fName3s[myIndex] as? String, for: .normal)
                        cell.fileTitleButton3.accessibilityHint = fID3s[myIndex] as? String
                        cell.fileTitleButton3.addTarget(self, action: #selector(openFileLink(_:)), for:.touchUpInside)
                    }
                }
                
                if items.count > 0 {
                    cell.slideshow.setImageInputs(items)
                    cell.slideshow.isHidden = false
                }
                
                return cell
                
            } else {
                let cell = tableview.dequeueReusableCell(withIdentifier: "replyCell", for: indexPath) as! ReplyTableViewCell
                if anonymous == "2" {
                    cell.usernameLabel.text = usernames[myIndex] as? String
                } else {
                    if mainUserName.isEqual(usernames[myIndex]) {
                        cell.usernameLabel.text = mainUserName
                    } else {
                        cell.usernameLabel.text = "Anonymous"
                    }
                }
                if !(threadTexts[myIndex] as! String).isEmpty {
                    cell.threadTextTextView.text = threadTexts[myIndex] as? String
                    cell.threadTextHeight.constant = cell.threadTextTextView.contentSize.height
                    cell.threadTextTextView.isHidden = false
                }
                
                cell.postDateLabel.text = (postDates[myIndex] as! String)
                cell.replyButton.tag = myIndex
                cell.replyButton.addTarget(self, action: #selector(replyCommentButton), for: .touchUpInside)
                
                if fExt1s[myIndex] as? String == nil {
                    cell.slideshow.isHidden = true
                    cell.file1StackView.isHidden = true
                } else {
                    if fExt1s[myIndex] as? String == "png" || fExt1s[myIndex] as? String == "jpg"  || fExt1s[myIndex] as? String == "jpeg" {
                        items.append(KingfisherSource(urlString: "https://kit.c-learning.jp/getfile/s3file/\(fID1s[myIndex])")!)
                    } else {
                        cell.slideshow.isHidden = true
                        cell.file1StackView.isHidden = false
                        cell.fileTitleButton1.setTitle(fName1s[myIndex] as? String, for: .normal)
                        cell.fileTitleButton1.accessibilityHint = fID1s[myIndex] as? String
                        cell.fileTitleButton1.addTarget(self, action: #selector(openFileLink(_:)), for:.touchUpInside)
                    }
                }
                if fExt2s[myIndex] as? String == nil {
                    cell.slideshow.isHidden = true
                    cell.file1StackView.isHidden = true
                } else {
                    if fExt2s[myIndex] as? String == "png" || fExt2s[myIndex] as? String == "jpg"  || fExt2s[myIndex] as? String == "jpeg" {
                        cell.file2StackView.isHidden = true
                        items.append(KingfisherSource(urlString: "https://kit.c-learning.jp/getfile/s3file/\(fID2s[myIndex])")!)
                    } else {
                        cell.slideshow.isHidden = true
                        cell.file2StackView.isHidden = false
                        cell.fileTitleButton2.setTitle(fName2s[myIndex] as? String, for: .normal)
                        cell.fileTitleButton2.accessibilityHint = fID2s[myIndex] as? String
                        cell.fileTitleButton2.addTarget(self, action: #selector(openFileLink(_:)), for:.touchUpInside)
                    }
                }
                if fExt3s[myIndex] as? String == nil {
                    cell.slideshow.isHidden = true
                    cell.file1StackView.isHidden = true
                } else {
                    if fExt3s[myIndex] as? String == "png" || fExt3s[myIndex] as? String == "jpg"  || fExt3s[myIndex] as? String == "jpeg" {
                        cell.file3StackView.isHidden = true
                        items.append(KingfisherSource(urlString: "https://kit.c-learning.jp/getfile/s3file/\(fID3s[myIndex])")!)
                    } else {
                        cell.slideshow.isHidden = true
                        cell.file3StackView.isHidden = false
                        cell.fileTitleButton3.setTitle(fName3s[myIndex] as? String, for: .normal)
                        cell.fileTitleButton3.accessibilityHint = fID3s[myIndex] as? String
                        cell.fileTitleButton3.addTarget(self, action: #selector(openFileLink(_:)), for:.touchUpInside)
                    }
                }
                if items.count > 0 {
                    cell.slideshow.isHidden = false
                    cell.slideshow.setImageInputs(items)
                }
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = .white
        
        if indexPath.row == 0 {
            print("This is Heading of the Thread")
        } else {
            let myindex = self.wantedIndexes[indexPath.row - 1]
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let editInfor = UIAlertAction(title: "Edit", style: .default, handler: { (alert: UIAlertAction!) -> Void in
                
            })
            
            let deleteQuest = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { (alert: UIAlertAction!) -> Void in
                let cno = self.cNOs[self.wantedIndexes[indexPath.row - 1] ] as! String
                self.deleteCommentReply(cn: cno)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            if mainUserName.isEqual(usernames[myindex]) {
                alertController.addAction(editInfor)
                alertController.addAction(deleteQuest)
            } else {
                alertController.addAction(deleteQuest)
            }
            
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    // MARK: Send comment & reply
    @IBAction func sendButton(_ sender: Any) {
        
        if replyNoticeCheckBox.isSelected == true {
            mailReply = 1
        }
        
        if notifyStudentCheckBox.isSelected == true {
            mailStudent = 1
        }
        
        if inputTextView.text.isEmpty || inputTextView.textColor == UIColor.lightGray {
            print("This is no data for submit")
        } else {
            let textInput = inputTextView.text
            self.submitCommentReply(inputText: textInput!)
            
        }
    }
    
    
    @IBAction func replyCommentButton(_ sender: UIButton) {
        inputTextView.text = "Write a reply ..."
        inputTextView.textColor = UIColor.lightGray
        commentState = 1
        
        if ttNames[sender.tag] as? String == nil {
            tempttName = ""
            if emailOption {
                replyNoticeView.isHidden = false
            }
            
        } else {
            tempttName = ttNames[sender.tag] as! String
            replyNoticeView.isHidden = true
        }
        
        if stNames[sender.tag] as? String == nil {
            tempstName = ""
        } else {
            tempstName = stNames[sender.tag] as! String
        }
        
        print(tempttName)
        print(tempstName)
        
        replyView.isHidden = false
        if tempttName.isEmpty {
            replyToLabel.text = "Replying to \(tempstName)"
        }
        
        if (cParents[(sender as AnyObject).tag] as AnyObject).isEqual(cNO) && (cBranch[(sender as AnyObject).tag] as AnyObject).isEqual("0") {
            cnoCR = cNOs[(sender as AnyObject).tag] as! String
            if tempstName.isEmpty {
                replyToLabel.text = "Replying to your comment"
            }
        } else {
            cnoCR = cParents[(sender as AnyObject).tag] as! String
            if tempstName.isEmpty {
                replyToLabel.text = "Replying to your reply"
            }
        }
    }
    
    
    @objc func openFileLink(_ sender: AnyObject) {
        let fileID = sender.accessibilityHint as! String
        let url = "https://kit.c-learning.jp/getfile/s3file/\(fileID)"
        UIApplication.shared.open(URL(string: "\(url)")!)
        
    }
    
}




// MARK: Add constraint with format
extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}




// MARK : Arrange comment and reply in wanted order
extension ThreadCommentViewController {
    
    func CommentAndReply() {
        for i in 0...(cRoots.count-1) {
            if cNO.isEqual(cRoots[i]){
                commentAndReplyIndex.append(i)
            }
        }
        
        if commentAndReplyIndex.count > 0 {
            self.CommentORReply()
            self.WantedOrder()
        }
    }
    
    
    func CommentORReply() {
        for i in 0...(commentAndReplyIndex.count-1) {
            if cNO.isEqual(cParents[commentAndReplyIndex[i]]) && (cBranch[commentAndReplyIndex[i]] as AnyObject).isEqual("0") {
                commentsIndex.append(commentAndReplyIndex[i])
            } else {
                replyIndex.append(commentAndReplyIndex[i])
            }
        }
    }
    
    
    func WantedOrder() {
        if commentsIndex.count > 0 {
            for i in 0...(commentsIndex.count-1) {
                wantedIndexes.append(commentsIndex[i])
                if replyIndex.count > 0 {
                    for j in 0...(replyIndex.count-1) {
                        if (cNOs[commentsIndex[i]] as AnyObject).isEqual(cParents[replyIndex[j]]) {
                            wantedIndexes.append(replyIndex[j])
                        }
                    }
                }
            }
            commentNum = wantedIndexes.count
            
        }
    }
}




// MARK: After taking the the photo
extension ThreadCommentViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        hideViews()
        
        // Display Previous Images
        for i in 0..<fileExts.count {
            if i == 0 {
                fileView1.isHidden = false
                if fileExts[0] == "xx" {
                    fileName1.text = fileNames[0]
                } else {
                    let asset = self.selectedAssets[0]
                    fileName1.text = asset.originalFileName
                }
            } else if i == 1 {
                fileView2.isHidden = false
                if fileExts[1] == "xx" {
                    if fileNames.count == 1 {
                        fileName2.text = fileNames[0]
                    } else {
                        fileName2.text = fileNames[1]
                    }
                } else {
                    if selectedAssets.count == 1 {
                        let asset = self.selectedAssets[0]
                        fileName2.text = asset.originalFileName
                    } else {
                        let asset = self.selectedAssets[1]
                        fileName2.text = asset.originalFileName
                    }
                }
            }
        }
        
        
        // Display and append new image
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismiss(animated: true, completion: nil)
        let imageName = "IMG_\(fourDigitNumber).JPG"
        if fileExts.count == 0 {
            fileView1.isHidden = false
            fileName1.text = imageName
            fileExts.append("xx")
            fileNames.append(imageName)
        } else if fileExts.count == 1 {
            fileView2.isHidden = false
            fileName2.text = imageName
            fileExts.append("xx")
            fileNames.append(imageName)
        } else {
            fileView3.isHidden = false
            fileName3.text = imageName
            fileExts.append("xx")
            fileNames.append(imageName)
        }
        
        uploadedAlert = true
        captureImages.append(image)
        uploadImageRequest(image: image)
    }
    
    
    // Generating a random name
    var fourDigitNumber: String {
        var result = ""
        repeat {
            // Create a string with a random number 0...9999
            result = String(format:"%04d", arc4random_uniform(10000) )
        } while Set<Character>(result.characters).count < 4
        return result
    }
    
}




// MARK : After choosing the image from the photos
extension ThreadCommentViewController : TLPhotosPickerViewControllerDelegate {
    
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
                    if uploadedAlert == false && imageExts.count == selectedAssets.count {
                        uploadedAlert = true
                    }
                }
            }
        }
        
        hideViews()
        // Display all the images
        
        for i in 0..<fileExts.count {
            if i == 0 {
                fileView1.isHidden = false
                if fileExts[0] == "xx" {
                    fileName1.text = fileNames[0]
                } else {
                    let asset = self.selectedAssets[0]
                    self.fileName1.text = asset.originalFileName
                }
            } else if i == 1 {
                fileView2.isHidden = false
                if fileExts[1] == "xx" {
                    if captureImages.count == 1 {
                        fileName2.text = fileNames[0]
                    } else {
                        fileName2.text = fileNames[1]
                    }
                } else {
                    if selectedAssets.count == 1 {
                        let asset = self.selectedAssets[0]
                        self.fileName2.text = asset.originalFileName
                    } else {
                        let asset = self.selectedAssets[1]
                        self.fileName2.text = asset.originalFileName
                    }
                }
            } else {
                fileView3.isHidden = false
                if fileExts[2] == "xx" {
                    if captureImages.count == 1 {
                        fileName3.text = fileNames[0]
                    } else if captureImages.count == 2 {
                        fileName3.text = fileNames[1]
                    } else {
                        fileName3.text = fileNames[2]
                    }
                } else {
                    if selectedAssets.count == 1 {
                        let asset = self.selectedAssets[0]
                        self.fileName3.text = asset.originalFileName
                    } else if selectedAssets.count == 2 {
                        let asset = self.selectedAssets[1]
                        self.fileName3.text = asset.originalFileName
                    } else {
                        let asset = self.selectedAssets[2]
                        self.fileName3.text = asset.originalFileName
                    }
                }
            }
        }
    }
}




// MARK : Upload the image to the server
extension ThreadCommentViewController {
    
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
}




// MARK : Request API
extension ThreadCommentViewController {
    
    // MARK: Get all comment
    func getCommentAPI() {
        
        Alamofire.request("https://kit.c-learning.jp/t/ajax/coop/list", method: .post, parameters: ["ccID":ccID], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                let result = response.result.value as? NSDictionary
                let data = result!["data"] as! NSArray
                self.cNOs = data.value(forKey: "cNO") as! NSArray
                self.cBranch = data.value(forKey: "cBranch") as! NSArray
                self.cRoots = data.value(forKey: "cRoot") as! NSArray
                self.cParents = data.value(forKey: "cParent") as! NSArray
                self.cSorts = data.value(forKey: "cSort") as! NSArray
                self.usernames = data.value(forKey: "cName") as! NSArray
                self.ttNames = data.value(forKey: "ttName") as! NSArray
                self.stNames = data.value(forKey: "stName") as! NSArray
                self.postDates = data.value(forKey: "cDate") as! NSArray
                self.threadTexts = data.value(forKey: "cText") as! NSArray
                self.fID1s = data.value(forKey: "fID1") as! NSArray
                self.fID2s = data.value(forKey: "fID2") as! NSArray
                self.fID3s = data.value(forKey: "fID3") as! NSArray
                self.fSize1s = data.value(forKey: "fSize1") as! NSArray
                self.fSize2s = data.value(forKey: "fSize2") as! NSArray
                self.fSize3s = data.value(forKey: "fSize3") as! NSArray
                self.fExt1s = data.value(forKey: "fExt1") as! NSArray
                self.fExt2s = data.value(forKey: "fExt2") as! NSArray
                self.fExt3s = data.value(forKey: "fExt3") as! NSArray
                self.fName1s = data.value(forKey: "fName1") as! NSArray
                self.fName2s = data.value(forKey: "fName2") as! NSArray
                self.fName3s = data.value(forKey: "fName3") as! NSArray
                
                if self.cNOs.count > 0 {
                    self.CommentAndReply()
                }
                
                self.tableview.reloadData()
                break
                
            case .failure(_):
                self.PresentAlertController(title: "Warning", message: "failure", actionTitle: "Okay")
                break
            }
        }
    }
    
    
    
    
    //MARK: Submit comment or reply
    
    func submitCommentReply(inputText : String) {
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
            "mode":"input",
            "ct":ctID,
            "sID":ccID,
            "c_no": cnoCR,
            "ttName": "Professor Kimhak",
            "ttID": "id1",
            "c_text": inputText,
            "fileID1": fileID1,
            "fileID2": fileID2,
            "fileID3": fileID3,
            "mail_student": "\(mailStudent)",
            "mail_reply": "\(mailStudent)"
        ]
        print(parameters)
        
        Alamofire.request("https://kit.c-learning.jp/t/ajax/coop/make_a_thread", method: .post, parameters: parameters).responseJSON {
            response in
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print(response.result.value)
                    self.removeValue()
                    self.getCommentAPI()
                }
                break
                
            case .failure(_):
                print(response.result.error as Any)
                break
                
            }
        }
    }
    
    
    
    //MARK: Delete Comment or Reply
    func deleteCommentReply(cn: String) {
        Alamofire.request("http://kit.c-learning.jp/t/ajax/coop/CoopDelete", method: .post, parameters: ["cc":ccID, "cn": cn]).responseJSON {
            response in
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    self.removeValue()
                    self.getCommentAPI()
                }
                break
                
            case .failure(_):
                print(response.result.error as Any)
                break
                
            }
        }
    }
    
}



//MARK: Some help functions
extension ThreadCommentViewController {
    
    // Hide Views
    func hideViews() {
        fileView1.isHidden = true
        fileView2.isHidden = true
        fileView3.isHidden = true
        replyNoticeView.isHidden = true
        notifyStudentView.isHidden = true
        replyView.isHidden = true
    }
    
    
    func removeValue() {
        self.inputTextView.text = "Write a comment ..."
        inputTextView.textColor = UIColor.lightGray
        inputTextView.selectedTextRange = inputTextView.textRange(from: inputTextView.beginningOfDocument, to: inputTextView.beginningOfDocument)
        
        commentState = 0
        commentAndReplyIndex.removeAll()
        commentsIndex.removeAll()
        replyIndex.removeAll()
        wantedIndexes.removeAll()
        cnoCR = cNO
        tempttName = ttName
        tempstName = stName
        
        hideViews()
        replyNoticeCheckBox.isSelected = false
        notifyStudentCheckBox.isSelected = false
        
        fileIDs.removeAll()
        fileExts.removeAll()
        imageIDS.removeAll()
        imageExts.removeAll()
        fileNames.removeAll()
        captureImages.removeAll()
        selectedAssets.removeAll()
        
        mailReply = 0
        mailStudent = 0
    }
    
    
}
