//
//  ThreadViewController.swift
//  C Learning Teacher
//
//  Created by kit on 3/12/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit
import Alamofire

class ThreadViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        setUpNavBar()
        
    }
    
    override func viewDidAppear(_ animated: Bool){
        self.getThreadAPI()
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
    
    @IBAction func createAction(_ sender: Any) {
        self.performSegue(withIdentifier: "goto", sender: self)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "threadCell", for: indexPath) as! ThreadTableViewCell
        
        cell.username.text = (username[indexPath.row] as! String)
        cell.postDate.text = (postDate[indexPath.row] as! String)
        cell.title.text = (threadTitle[indexPath.row] as! String)
        cell.caption.text = (threadCaption[indexPath.row] as! String)
        //cell.commentNum.setTitle((commentNum[indexPath.row] as! String), for: .normal)
        cell.viewNum.setTitle((seenNum[indexPath.row] as! String), for: .normal)
        /* https://kit.c-learning.jp/getfile/s3file/imageName */
        let picture = pictures[indexPath.row] as! String
        print(picture,"###@")
        
        if picture.isEmpty {
            //print("couldn't found the image")
            cell.postImage?.image = nil
            cell.defaultTweetImageViewHeightConstraint = cell.imageHeight.constant
            cell.imageHeight.constant = 0
            cell.postImage.isHidden = true
            //let screenSize: CGRect = UIScreen.main.bounds
            //cell.postImage.frame = CGRect(x: 0, y: 0, width: 50, height: 0)
            //cell.frame = CGRect(x: 0, y: 0, width: 50, height: 0)
            //loadViewIfNeeded()
            
        } else {

            let urlstring = "https://kit.c-learning.jp/getfile/s3file/\(picture)"
            let profileImageURL = NSURL(string: urlstring)
            let request = URLRequest(url: profileImageURL as! URL)
            let networkProcessor = NetworkProcessing(request: request)
            networkProcessor.downloadData(completion: { [weak self] (imageData, httpResponse, error) in

                DispatchQueue.main.async {
                    if let imageData = imageData {
                        
                        cell.postImage.image = UIImage(data: imageData)
                        cell.postImage.roundedCorners()
                    }
                }
            })
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    
    
    func getThreadAPI() {
        Alamofire.request("https://kit.c-learning.jp/t/ajax/coop/thread", method: .post, parameters: ["ccID":bbID], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                let repsoneResult = response.result.value as? NSDictionary
                
                //print(repsoneResult?.allKeys,"###")
                let data = repsoneResult!["mes"] as! NSArray
                //                print("+++++++++++++++++++++++++++")
                //                print(data)
                
                self.username = data.value(forKey: "cName") as! NSArray
                self.postDate = data.value(forKey: "cDate") as! NSArray
                self.threadTitle = data.value(forKey: "cTitle") as! NSArray
                self.threadCaption = data.value(forKey: "cText") as! NSArray
                self.commentNum = data.value(forKey: "cNO") as! NSArray
                self.seenNum = data.value(forKey: "cAlreadyNum") as! NSArray
                self.pictures = data.value(forKey: "fID1") as! NSArray
                // now no profile image & thread image
                
                
                print("@@@@@ result @@@@ ")
                print(self.username)
                print(self.pictures)
                
                self.tableView.reloadData()
                break
                
            case .failure(_):
                self.PresentAlertController(title: "Warning", message: "failure", actionTitle: "Okay")
                break
                
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = "\(String(describing: segue.identifier ?? "nil") )"
        if identifier == "goto" {
            let toViewController = segue.destination as! ThreadCreateViewController
            toViewController.bbID = self.bbID
            
        }
    }

}

private extension UIView
{
    func roundedCorners() {
        self.layer.cornerRadius = 5.0
        layer.masksToBounds = true
    }
}
