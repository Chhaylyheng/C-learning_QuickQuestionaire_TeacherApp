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

class ThreadCommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var inputViewContainer: UIView!
    var bottomConstraint: NSLayoutConstraint?
    @IBOutlet weak var inputTextView: UITextView!
    
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
    var commentState = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cnoCR = cNO
        
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
        view.addConstraintsWithFormat("H:|[v0]|", views: inputViewContainer)
        view.addConstraintsWithFormat("V:[v0(83)]", views: inputViewContainer)
        bottomConstraint = NSLayoutConstraint(item: inputViewContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        // Adding multiple cell to your tableview
        let nibName1 = UINib(nibName: "ThreadTableCell", bundle: nil)
        tableview.register(nibName1, forCellReuseIdentifier: "ThreadCell")
        
        let nibName2 = UINib(nibName: "CommentsTableViewCell", bundle: nil)
        tableview.register(nibName2, forCellReuseIdentifier: "commentCell")

        let nibName3 = UINib(nibName: "ReplyTableViewCell", bundle: nil)
        tableview.register(nibName3, forCellReuseIdentifier: "replyCell")
        
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
        }
    }
    
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
        
        if inputTextView.text.isEmpty || inputTextView.textColor == UIColor.lightGray {
            print("This is no data for submit")
        } else {
            let textInput = inputTextView.text
            self.submitCommentReply(inputText: textInput!)
            
        }
    }
    
    @IBAction func replyCommentButton(_ sender: Any) {
        inputTextView.text = "Write a reply ..."
        inputTextView.textColor = UIColor.lightGray
        commentState = 1
        
        if (cParents[(sender as AnyObject).tag] as AnyObject).isEqual(cNO) && (cBranch[(sender as AnyObject).tag] as AnyObject).isEqual("0") {
            cnoCR = cNOs[(sender as AnyObject).tag] as! String
        } else {
            cnoCR = cParents[(sender as AnyObject).tag] as! String
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
        Alamofire.request("https://kit.c-learning.jp/t/ajax/coop/CoopReply", method: .post, parameters: ["m":"input","ct":ctID, "cc":ccID, "cn": cnoCR, "ttName": "Professor Kimhak", "ttID": "id1", "c_text": inputText ]).responseJSON {
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
    
    func removeValue() {
        self.inputTextView.text = "Write a comment ..."
        inputTextView.textColor = UIColor.lightGray
        commentState = 0
        commentAndReplyIndex.removeAll()
        commentsIndex.removeAll()
        replyIndex.removeAll()
        wantedIndexes.removeAll()
        cnoCR = cNO
    }
    
}
