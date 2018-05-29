//
//  ThreadViewController.swift
//  C Learning Teacher
//
//  Created by kit on 3/12/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit
import Alamofire
import Popover
import ImageSlideshow

class ThreadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let alert = SweetAlert()
    
    var courseCode : String = ""
    var bbID : String = ""
    var anonymous : String = ""
    
    var usernames : NSArray = []
    var ttNames : NSArray = []
    var stNames : NSArray = []
    var postDates : NSArray = []
    var threadTitles : NSArray = []
    var threadTexts : NSArray = []
    var commentNums : NSArray = []
    var seenNums : NSArray = []
    var cNOs : NSArray = []
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
    var cRoots : NSArray = []
    var comNum = [Int]()
    
    var num = Int()
    
    override func viewDidAppear(_ animated: Bool){
        //getThreadAPI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Register tableviewcell to tableview
        let nibName1 = UINib(nibName: "ThreadTableCell", bundle: nil)
        tableView.register(nibName1, forCellReuseIdentifier: "ThreadCell")
        
        self.getThreadAPI()
        commentReplyListAPI()
        setUpNavBar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.orange
        self.navigationItem.title = "Threads"
        
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernames.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var items = [KingfisherSource]()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ThreadCell", for: indexPath) as! ThreadTableCell
        
        // Long Press Gesture Handle
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLabelTap))
        cell.addGestureRecognizer(gestureRecognizer)
        
        if anonymous == "2" {
            if ttNames[indexPath.row] as? String == nil {
                cell.usernameLabel.text = (stNames[indexPath.row] as! String)
            } else {
                cell.usernameLabel.text = (ttNames[indexPath.row] as! String)
            }
        } else {
            if ttNames[indexPath.row] as? String != nil {
                cell.usernameLabel.text = (ttNames[indexPath.row] as! String)
            } else {
                cell.usernameLabel.text = "Anonymous"
            }
        }
        
        if !(threadTexts[indexPath.row] as! String).isEmpty {
            cell.threadTextTextView.isHidden = false
            cell.threadTextTextView.text = (threadTexts[indexPath.row] as! String)
            cell.threadTextHeight.constant = cell.threadTextTextView.contentSize.height
        }
        cell.postDateLabel.text = (postDates[indexPath.row] as! String)
        cell.threadTitleLabel.text = (threadTitles[indexPath.row] as! String)
        cell.comButton.setTitle("  \(comNum[indexPath.row])", for: .normal)
        cell.comButton.tag = indexPath.row
        cell.comButton.addTarget(self, action: #selector(commentHandler), for: .touchUpInside)
        if fExt1s[indexPath.row] as? String == nil {
            cell.slideshow.isHidden = true
            cell.file1StackView.isHidden = true
        } else {
            if fExt1s[indexPath.row] as? String == "png" || fExt1s[indexPath.row] as? String == "jpg"  || fExt1s[indexPath.row] as? String == "jpeg" {
                cell.file1StackView.isHidden = true
                items.append(KingfisherSource(urlString: "https://kit.c-learning.jp/getfile/s3file/\(fID1s[indexPath.row])")!)
            } else {
                cell.slideshow.isHidden = true
                cell.file1StackView.isHidden = false
                cell.fileTitleButton1.setTitle(fName1s[indexPath.row] as? String, for: .normal)
                cell.fileTitleButton1.accessibilityHint = fID1s[indexPath.row] as? String
                cell.fileTitleButton1.addTarget(self, action: #selector(openFileLink(_:)), for:.touchUpInside)
            }
        }
        
        if fExt2s[indexPath.row] as? String == nil {
            cell.slideshow.isHidden = true
            cell.file2StackView.isHidden = true
        } else {
            if fExt2s[indexPath.row] as? String == "png" || fExt2s[indexPath.row] as? String == "jpg"  || fExt2s[indexPath.row] as? String == "jpeg" {
                cell.file2StackView.isHidden = true
                items.append(KingfisherSource(urlString: "https://kit.c-learning.jp/getfile/s3file/\(fID2s[indexPath.row])")!)
            } else {
                cell.slideshow.isHidden = true
                cell.file2StackView.isHidden = false
                cell.fileTitleButton2.setTitle(fName2s[indexPath.row] as? String, for: .normal)
                cell.fileTitleButton2.accessibilityHint = fID2s[indexPath.row] as? String
                cell.fileTitleButton2.addTarget(self, action: #selector(openFileLink(_:)), for:.touchUpInside)
            }
        }
        
        if fExt3s[indexPath.row] as? String == nil {
            cell.slideshow.isHidden = true
            cell.file3StackView.isHidden = true
        } else {
            if fExt3s[indexPath.row] as? String == "png" || fExt3s[indexPath.row] as? String == "jpeg"  || fExt3s[indexPath.row] as? String == "jpg" {
                cell.file3StackView.isHidden = true
                items.append(KingfisherSource(urlString: "https://kit.c-learning.jp/getfile/s3file/\(fID3s[indexPath.row])")!)
            } else {
                cell.slideshow.isHidden = true
                cell.file3StackView.isHidden = false
                cell.fileTitleButton3.setTitle(fName3s[indexPath.row] as? String, for: .normal)
                cell.fileTitleButton3.accessibilityHint = fID3s[indexPath.row] as? String
                cell.fileTitleButton3.addTarget(self, action: #selector(openFileLink(_:)), for:.touchUpInside)
            }
        }
        
        let recognizers = UITapGestureRecognizer(target: self, action: #selector(ThreadViewController.slideShowTapped))
        cell.slideshow.addGestureRecognizer(recognizers)
        
        if items.count > 0 {
            cell.slideshow.isHidden = false
            cell.slideshow.setImageInputs(items)
        }

        cell.optionMenuButton.tag = indexPath.row
        cell.optionMenuButton.addTarget(self, action: #selector(optionHandler), for: .touchUpInside)
        
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func slideShowTapped(cell: ThreadTableCell) {
        //cell.slideshow.presentFullScreenController(from: self)

    }
    
    @objc func openFileLink(_ sender: AnyObject) {
        let fileID = sender.accessibilityHint as! String
        let url = "https://kit.c-learning.jp/getfile/s3file/\(fileID)"
        UIApplication.shared.open(URL(string: "\(url)")!)
        
    }
    
    
    
}

private extension UIView
{
    func roundedCorners() {
        self.layer.cornerRadius = 5.0
        layer.masksToBounds = true
    }
}



// MARK : Button Handler

extension ThreadViewController {
    @IBAction func CreateThread(_ sender: Any) {
        performSegue(withIdentifier: "toCreateThread", sender: self)
    }
    
    
    @objc func handleLabelTap(sender: UIGestureRecognizer) {
            
        let touchPoint = sender.location(in: self.view)
        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
            print(indexPath[1])
        }
        let position = sender.location(in: self.tableView)
        let index = self.tableView.indexPathForRow(at: position)
        
        //centeredDropDown.show()
        
    }
    
    
    @IBAction func commentHandler(_ sender: UIButton){
        let NextController = storyboard?.instantiateViewController(withIdentifier: "threadComment") as! ThreadCommentViewController
        NextController.ccID = bbID
        NextController.ctID = courseCode
        NextController.anonymous = anonymous
        NextController.ttName = String(describing: ttNames[sender.tag])
        NextController.stName = String(describing: stNames[sender.tag])
        NextController.cNO = self.cNOs[sender.tag] as! String
        NextController.username = String(describing: usernames[sender.tag])
        NextController.postDate = String(describing: postDates[sender.tag])
        NextController.threadTitle = String(describing: threadTitles[sender.tag])
        NextController.threadBody = String(describing: threadTexts[sender.tag])
        NextController.seenNum = String(describing: seenNums[sender.tag])
        NextController.fID1 = String(describing: fID1s[sender.tag])
        NextController.fID2 = String(describing: fID2s[sender.tag])
        NextController.fID3 = String(describing: fID3s[sender.tag])
        NextController.fSize1 = String(describing: fSize1s[sender.tag])
        NextController.fSize2 = String(describing: fSize2s[sender.tag])
        NextController.fSize3 = String(describing: fSize3s[sender.tag])
        NextController.fExt1 = String(describing: fExt1s[sender.tag])
        NextController.fExt2 = String(describing: fExt2s[sender.tag])
        NextController.fExt3 = String(describing: fExt3s[sender.tag])
        NextController.fName1 = String(describing: fName1s[sender.tag])
        NextController.fName2 = String(describing: fName2s[sender.tag])
        NextController.fName3 = String(describing: fName3s[sender.tag])
        
        navigationController?.pushViewController(NextController, animated: true)
        
    }
    
    
    @IBAction func optionHandler(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editInfor = UIAlertAction(title: "Edit", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.num = sender.tag
            self.performSegue(withIdentifier: "toEditThread", sender: self)
        })
        
        let deleteQuest = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { (alert: UIAlertAction!) -> Void in
            let cno = self.cNOs[sender.tag] as! String
            self.deteleAPI(cn: cno)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
       
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = sender.frame
        alertController.addAction(editInfor)
        alertController.addAction(deleteQuest)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}


// MARK: Prepare Before Segue

extension ThreadViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as? UINavigationController
        let identifier = "\(String(describing: segue.identifier ?? "nil") )"
        
        if identifier == "toCreateThread" {
            let nextController = navVC?.viewControllers.first as! ThreadCreateViewController
            nextController.bbID = self.bbID
            
        }
        
        if identifier == "toEditThread" {
            let nextController = navVC?.viewControllers.first as! ThreadUpdateViewController
            nextController.ctID = courseCode
            nextController.bbID = bbID
            nextController.cn = cNOs[num] as! String
            nextController.threadTitle = threadTitles[num] as! String
            nextController.threadBody = threadTexts[num] as! String
        }
    }
}



// MARK: API Request

extension ThreadViewController {
    
    func getThreadAPI() {
        Alamofire.request("https://kit.c-learning.jp/t/ajax/coop/thread", method: .post, parameters: ["ccID":bbID], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                let repsoneResult = response.result.value as? NSDictionary
                
                let data = repsoneResult!["mes"] as! NSArray
                self.ttNames = data.value(forKey: "ttName") as! NSArray
                self.stNames = data.value(forKey: "stName") as! NSArray
                self.cNOs = data.value(forKey: "cNO") as! NSArray
                self.usernames = data.value(forKey: "cName") as! NSArray
                self.postDates = data.value(forKey: "cDate") as! NSArray
                self.threadTitles = data.value(forKey: "cTitle") as! NSArray
                self.threadTexts = data.value(forKey: "cText") as! NSArray
                self.seenNums = data.value(forKey: "cAlreadyNum") as! NSArray
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
                
                break
                
            case .failure(_):
                self.PresentAlertController(title: "Warning", message: "failure", actionTitle: "Okay")
                break
                
            }
        }
    }
    
    
    
    // MARK: For counting the number of comment and reply in each thread
    func commentReplyListAPI() {
        Alamofire.request("https://kit.c-learning.jp/t/ajax/coop/list", method: .post, parameters: ["ccID":bbID], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                let result = response.result.value as? NSDictionary
                let data = result!["data"] as! NSArray
                self.cRoots = data.value(forKey: "cRoot") as! NSArray
                if self.cRoots.count > 0 {
                    self.threadCommentNum()
                }
                break
                
            case .failure(_):
                self.PresentAlertController(title: "FAIL!", message: "failure", actionTitle: "Okay")
                break
            }
        }
    }
    
    
    // MARK: Get number of comment and reply for each thread
    func threadCommentNum() {
        for i in 0..<cNOs.count {
            var num = 0
            for j in 0..<cRoots.count {
                if (cNOs[i] as AnyObject).isEqual(cRoots[j]) {
                    num+=1
                }
            }
            comNum.append(num)
        }
        self.tableView.reloadData()
    }
    
    
    func deteleAPI(cn : String) {
        Alamofire.request("http://kit.c-learning.jp/t/ajax/coop/CoopDelete", method: .post, parameters: ["cc":bbID, "cn":cn], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print(response.result.value as Any)
                }
                self.getThreadAPI()
                break
                
            case .failure(_):
                print(response.result.error as Any)
                break
                
            }
        }
        
    }
    
    
    func updateThread(title: String, body: String, cn: String) {
        
        Alamofire.request("https://kit.c-learning.jp/t/ajax/coop/CoopReply", method: .post, parameters: ["m":"edit","ct":"c398223976","cc":bbID,"cn":cn,"c_title":title,"c_text":body], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil {
                    print(response.result.value as Any)
                }
                self.getThreadAPI()
                break
                
            case .failure(_):
                print(response.result.error as Any)
                break
                
            }
        }
    }
}
