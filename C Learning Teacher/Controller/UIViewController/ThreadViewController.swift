//
//  ThreadViewController.swift
//  C Learning Teacher
//
//  Created by kit on 3/12/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit
import Alamofire
import DropDown
import Popover

class ThreadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let alert = SweetAlert()
    
    fileprivate var texts = ["Edit", "Delete", "Report"]
    
    fileprivate var popover: Popover!
    fileprivate var popoverOptions: [PopoverOption] = [
        .type(.up),
        .blackOverlayColor(UIColor(white: 0.0, alpha: 0.6))
    ]
    
    var courseCode : String = ""
    var bbID : String = ""
    // profile image
    var username : NSArray = []
    var postDate : NSArray = []
    var threadTitle : NSArray = []
    var threadCaption : NSArray = []
    // thread image fID1, fID2, fID3
    var pictures : NSArray = []
    var commentNum : NSArray = []
    var seenNum : NSArray = []
    var cNo : NSArray = []
    var num = Int()
    
    let rightBarDropDown = DropDown()
    let centeredDropDown = DropDown()
    let optionsDropDown = DropDown()
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.rightBarDropDown,
            self.centeredDropDown,
            self.optionsDropDown
        ]
    }()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var rightBarItem: UIBarButtonItem!
    
    @IBAction func showBarButtonDropDown(_ sender: Any) {
        rightBarDropDown.show()
    }
    
    
    override func viewDidAppear(_ animated: Bool){
        getThreadAPI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        setupDropDowns()
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
//        self.getThreadAPI()
        setUpNavBar()
        
    }
    
    
    func setupDropDowns() {
        setupRightBarDropDown()
        setupCenteredDropDown()
        optionDropDown()
    }
    
    func setupRightBarDropDown() {
        rightBarDropDown.anchorView = rightBarItem
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        rightBarDropDown.dataSource = [
            " Text Display ",
            " Detailed Information ",
            " Display Title ",
        ]
    }
    
    func optionDropDown() {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "threadCell") as! ThreadTableViewCell
        optionsDropDown.anchorView = rightBarItem
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        optionsDropDown.dataSource = [
            " Text Display ",
            " Detailed Information ",
            " Display Title ",
        ]
    }
    
    func setupCenteredDropDown() {
        // Not setting the anchor view makes the drop down centered on screen
        //        centeredDropDown.anchorView = centeredDropDownButton
        
        // You can also use localizationKeysDataSource instead. Check the docs.
        centeredDropDown.dataSource = [
            "The drop down",
            "Is centered on",
            "the view because",
            "it has no anchor view defined.",
            "Click anywhere to dismiss."
        ]
        
        //        centeredDropDown.selectionAction = { [weak self] (index, item) in
        //            self?.centeredDropDownButton.setTitle(item, for: .normal)
        //        }
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
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return username.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print(num, "#")
        let cell = tableView.dequeueReusableCell(withIdentifier: "threadCell", for: indexPath) as! ThreadTableViewCell
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLabelTap))
        cell.addGestureRecognizer(gestureRecognizer)

        cell.optionItem.tag = indexPath.row
        cell.optionItem.addTarget(self, action: #selector(optionHandler), for: .touchUpInside)
        //cell.optionItem.frame = cell.frame
        
        cell.username.text = (username[indexPath.row] as! String)
        cell.postDate.text = (postDate[indexPath.row] as! String)
        cell.title.text = (threadTitle[indexPath.row] as! String)
        cell.caption.text = (threadCaption[indexPath.row] as! String)
        //cell.commentNum.setTitle((commentNum[indexPath.row] as! String), for: .normal)
        cell.viewNum.setTitle((seenNum[indexPath.row] as! String), for: .normal)
        
        
        cell.commentNum.tag = indexPath.row
        cell.commentNum.addTarget(self, action: #selector(commentHandler), for: .touchUpInside)
        
        /* https://kit.c-learning.jp/getfile/s3file/imageName */
        let picture = pictures[indexPath.row] as! String
        
        if picture.isEmpty {
            //print("couldn't found the image")
            cell.postImage?.image = nil
            cell.postImage.isHidden = true
            //let screenSize: CGRect = UIScreen.main.bounds
            //cell.postImage.frame = CGRect(x: 0, y: 0, width: 50, height: 0)
            //cell.frame = CGRect(x: 0, y: 0, width: 50, height: 0)
            //loadViewIfNeeded()
            
        } else if (!picture.isEqual("")){
            let num = indexPath.row
            if (picture.isEqual(pictures[num])) {
                let urlstring = "https://kit.c-learning.jp/getfile/s3file/\(picture)"
                let ImageURL = NSURL(string: urlstring)
                let request = URLRequest(url: ImageURL! as URL)
                let networkProcessor = NetworkProcessing(request: request)
                networkProcessor.downloadData(completion: {(imageData, httpResponse, error) in
                    DispatchQueue.main.async {
                        if let imageData = imageData {
                            cell.postImage.image = UIImage(data: imageData)
                            cell.postImage.roundedCorners()
                        }
                    }
                })
            }
            
        } else {
            
        }
        
        cell.selectionStyle = .none
        return cell
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
    
    @IBAction func createAction(_ sender: Any) {
        performSegue(withIdentifier: "toCreateThread", sender: self)
        
    }
    
    
    @objc func handleLabelTap(sender: UIGestureRecognizer) {
        let position = sender.location(in: self.tableView)
        guard let index = self.tableView.indexPathForRow(at: position) else {
            print("Error label not in tableView")
            return
        }
        print(index.row, "###")
        centeredDropDown.show()
        
    }
    
    
    @IBAction func commentHandler(_ sender: UIButton){
        let Dtail = storyboard?.instantiateViewController(withIdentifier: "commentThread") as! CommentThreadViewController
        Dtail.userName = self.username[sender.tag] as! String
        Dtail.postDate = self.postDate[sender.tag] as! String
        Dtail.threadTitle = self.threadTitle[sender.tag] as! String
        Dtail.threadBody = self.threadCaption[sender.tag] as! String
        Dtail.postImageName = self.pictures[sender.tag] as! String
        //Dtail.commentNum =
        Dtail.seenNum = self.seenNum[sender.tag] as! String
        
        navigationController?.pushViewController(Dtail, animated: true)
        //popToViewController
    }
    
    
    @IBAction func optionHandler(_ sender: UIButton) {
//        let title = threadTitle[sender.tag] as! String
//        let body = threadCaption[sender.tag] as! String
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editInfor = UIAlertAction(title: "Edit", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.num = sender.tag
            print(self.num, " ? num")
            self.performSegue(withIdentifier: "toEditThread", sender: self)
            
        })
        
        
        let deleteQuest = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { (alert: UIAlertAction!) -> Void in
            
            let cno = self.cNo[sender.tag] as! String
            self.deteleAPI(cn: cno)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
       
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        //        alertController.popoverPresentationController?.sourceView = view
        //        alertController.popoverPresentationController?.sourceRect = sender.frame
        
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
            nextController.cn = cNo[num] as! String
            nextController.threadTitle = threadTitle[num] as! String
            nextController.threadBody = threadCaption[num] as! String
            
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
                
                //print(repsoneResult?.allKeys,"###")
                let data = repsoneResult!["mes"] as! NSArray
                //                print("+++++++++++++++++++++++++++")
                //                print(data)
                self.cNo = data.value(forKey: "cNO") as! NSArray
                self.username = data.value(forKey: "cName") as! NSArray
                self.postDate = data.value(forKey: "cDate") as! NSArray
                self.threadTitle = data.value(forKey: "cTitle") as! NSArray
                self.threadCaption = data.value(forKey: "cText") as! NSArray
                self.commentNum = data.value(forKey: "cNO") as! NSArray
                self.seenNum = data.value(forKey: "cAlreadyNum") as! NSArray
                self.pictures = data.value(forKey: "fID1") as! NSArray
                // now no profile image & thread image
                
                
                print("@@@@@ result @@@@ ")
                //                print(self.username)
                print(self.pictures)
                
                self.tableView.reloadData()
                break
                
            case .failure(_):
                self.PresentAlertController(title: "Warning", message: "failure", actionTitle: "Okay")
                break
                
            }
        }
        
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
}
