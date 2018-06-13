//
//  BulletinBoardViewController.swift
//  C Learning Teacher
//
//  Created by kit on 2/27/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit
import Alamofire

class BulletinBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //UICollectionViewDelegate,UICollectionViewDataSource
    
    @IBOutlet weak var tableView: UITableView!
    
    //@IBOutlet weak var collectionView: UICollectionView!
    var ccID : NSArray = []
    var ccRanges : NSArray = []
    var ccDates : NSArray = []
    var ccSizes : NSArray = []
    var ccNames : NSArray = []
    var ccStudentWrites : NSArray  = []
    var ccAnonymouss : NSArray = []
    var ccCharNums : NSArray = []
    var ccItemNums : NSArray = []
    var ccStuNums : NSArray = []
    var ctID = "c398223976"
    var bulletin : String = ""
    var stuWrite : String = ""
    var nonymous : String = ""
    var stuRange : String = ""
    var num = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView.dataSource = self
        //collectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        setUpNavBar()
        self.getBBAPI()
        
    }
    override func viewDidAppear(_ animated: Bool){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.orange
        self.navigationItem.title = "Bulletin Board"
        
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ccNames.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BBcell", for: indexPath) as! BBListTableViewCell
        
        if ccRanges[indexPath.row] as? String == "2" {
            cell.ccRange.setTitle("All" , for: .normal)
        } else if ccRanges[indexPath.row]  as? String  == "1" {
            cell.ccRange.setTitle("Choice(\(ccStuNums[indexPath.row]))" , for: .normal)
        } else {
            cell.ccRange.setTitle("None" , for: .normal)
        }
        cell.ccRange.tag = indexPath.row
        
        cell.ccDate.text = (ccDates[indexPath.row] as! String)
        if ccSizes[indexPath.row] as? String == nil {
            cell.ccTotalSize.text = "0 B"
        } else {
            cell.ccTotalSize.text = (ccSizes[indexPath.row] as! String) + " KB"
        }
        
        //cell.ccName.setTitle(ccNames[indexPath.row] as? String, for: .normal)
        cell.ccName.text = ccNames[indexPath.row] as? String
        
        if ccStudentWrites[indexPath.row] as? String == "1" {
            cell.ccStudentWrite.image = UIImage(named: "circle")
        } else {
            cell.ccStudentWrite.image = UIImage(named: "cancel")
        }
        
        if ccAnonymouss[indexPath.row] as? String == "0" {
            cell.ccAnonymous.text = "Anonymouse"
        } else if ccAnonymouss[indexPath.row] as? String == "1" {
            cell.ccAnonymous.text = "Registered Instructor"
        } else {
            cell.ccAnonymous.text = "Registered"
        }
        
        if ccCharNums[indexPath.row] as? String == nil {
            cell.ccCharNum.text = "0 word"
        } else {
            cell.ccCharNum.text = (ccCharNums[indexPath.row] as! String) + " words"
        }
        cell.ccItemNum.text = (ccItemNums[indexPath.row] as! String)
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = .white
        
        let Dtail = storyboard?.instantiateViewController(withIdentifier: "threadList") as! ThreadViewController
        Dtail.bbID = ccID[indexPath.row] as! String
        Dtail.courseCode = ctID
        Dtail.anonymous = ccAnonymouss[indexPath.row] as! String
        navigationController?.pushViewController(Dtail, animated: true)
        
        
    }
    
    // MARK: - UITableViewDelegate Protocol
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            let Alert = UIAlertController(title: "Warning", message: "Deleting the Bulletin Board deletes all related information such as articles and files under it. Is it OK?", preferredStyle: UIAlertControllerStyle.alert)
            
            
            Alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
                
                self.deleteBBAPI(id: self.ccID[indexPath.row] as! String)
                completionHandler(true)
                
            }))
            
            Alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present( Alert, animated: true, completion: nil)
            
            
        }
        
        //let editAction = UIContextualAction(style: .normal, title: "Edit")
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            
            self.num = indexPath.row
            completionHandler(true)
            self.performSegue(withIdentifier: "gotoEdit", sender: self)
            
        }
        
        
        // Customize the action buttons
        deleteAction.backgroundColor = UIColor(red: 231.0/255.0, green: 76.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        deleteAction.image = UIImage(named: "rubbish-bin")
        
        editAction.backgroundColor = UIColor(red: 254.0/255.0, green: 149.0/255.0, blue: 38.0/255.0, alpha: 1.0)
        editAction.image = UIImage(named: "edit")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        
        return swipeConfiguration
    }
    
    
    
    func getBBAPI() {
        Alamofire.request("http://kit.c-learning.jp/t/ajax/coop/BBL", method: .post, parameters: ["ctID":"c398223976", "caID":"id1"], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                let repsoneResult = response.result.value as? NSDictionary
                let data = repsoneResult!["data"] as! NSArray
                self.ccID = data.value(forKey: "ccID") as! NSArray
                self.ccRanges = data.value(forKey: "ccStuRange") as! NSArray
                self.ccDates = data.value(forKey: "ccDate") as! NSArray
                self.ccSizes = data.value(forKey: "ccTotalSize") as! NSArray
                self.ccNames = data.value(forKey: "ccName") as! NSArray
                self.ccStudentWrites = data.value(forKey: "ccStuWrite") as! NSArray
                self.ccAnonymouss = data.value(forKey: "ccAnonymous") as! NSArray
                self.ccCharNums = data.value(forKey: "ccCharNum") as! NSArray
                self.ccItemNums = data.value(forKey: "ccItemNum") as! NSArray
                self.ccStuNums = data.value(forKey: "ccStuNum") as! NSArray
                
                self.tableView.reloadData()
                break
                
            case .failure(_):
                let alertController:UIAlertController = UIAlertController(title:nil, message: "There is no internet connection", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction:UIAlertAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:{ (action:UIAlertAction!) -> Void in
                })
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                break
                
            }
        }
        
    }
    
    func deleteBBAPI(id : String) {
        Alamofire.request("https://kit.c-learning.jp/t/ajax/coop/catedelete", method: .post, parameters: ["ccID":id, "ttID":"id1"], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print(response.result.value as Any)
                }
                //self.getBBAPI()
                break
                
            case .failure(_):
                print(response.result.error as Any as Any)
                break
                
            }
        }
        
    }
    
    
    // Mark: button handle
    @IBAction func buttonHandler(_ sender: UIButton) {
        
        let Dtail = storyboard?.instantiateViewController(withIdentifier: "threadList") as! ThreadViewController
        Dtail.bbID = ccID[sender.tag] as! String
        Dtail.courseCode = ctID
        Dtail.anonymous = ccAnonymouss[sender.tag] as! String
        navigationController?.pushViewController(Dtail, animated: true)
        
    }
    
    @IBAction func CreateBB(_ sender: Any) {
        performSegue(withIdentifier: "toCreateBB", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navVC = segue.destination as? UINavigationController
        let identifier = "\(String(describing: segue.identifier ?? "nil") )"

        if identifier == "toCreateBB" {
            let nextController = navVC?.viewControllers.first as! BulletinCreationViewController
            nextController.ctID = self.ctID
            
        }

        if identifier == "gotoEdit" {
            let nextController = navVC?.viewControllers.first as! BBUpdateViewController
            nextController.ccID = self.ccID[num] as! String
            nextController.bulletin = self.ccNames[num] as! String
            nextController.stuWrite = self.ccStudentWrites[num] as! String
            nextController.nonymous = self.ccAnonymouss[num] as! String
            nextController.stuRange = self.ccRanges[num] as! String

        }
    }
}
