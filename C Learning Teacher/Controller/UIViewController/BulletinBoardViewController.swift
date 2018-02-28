//
//  BulletinBoardViewController.swift
//  C Learning Teacher
//
//  Created by kit on 2/27/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit
import Alamofire

class BulletinBoardViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource  {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var ccRanges : NSArray = []
    var ccDates : NSArray = []
    var ccSizes : NSArray = []
    var ccNames : NSArray = []
    var ccStudentWrites : NSArray  = []
    var ccAnonymouss : NSArray = []
    var ccCharNums : NSArray = []
    var ccItemNums : NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        setUpNavBar()
        self.getQuestionAPI()
        
        
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
    
    @IBAction func createPressed(_ sender: Any) {
//        let BulletinCreation = storyboard?.instantiateViewController(withIdentifier: "BulletinCreation") as! BulletinBoardViewController
//        navigationController?.pushViewController(BulletinCreation, animated: true)
        let BulletinCreation = storyboard?.instantiateViewController(withIdentifier: "BulletinCreation")
        navigationController?.pushViewController(BulletinCreation!, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return ccNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : BulletinboardCellTableViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "bulletinboard", for: indexPath) as! BulletinboardCellTableViewCell
        
        //print("+++++++++++++++++++++++++++")
        
        if ccRanges[indexPath.row] as? String == "2" {
            cell.ccRange.setTitle("All" , for: .normal)
        } else if ccRanges[indexPath.row]  as? String  == "1" {
            cell.ccRange.setTitle("Choice" , for: .normal)
        } else {
            cell.ccRange.setTitle("None" , for: .normal)
        }
        cell.ccRange.tag = indexPath.row
        
        cell.ccDate.setTitle(ccDates[indexPath.row] as? String, for: .normal)
        if ccSizes[indexPath.row] as? String == nil {
            cell.ccTotalSize.text = "0 B"
        } else {
            cell.ccTotalSize.text = (ccSizes[indexPath.row] as! String) + " KB"
        }
        
        cell.ccName.setTitle(ccNames[indexPath.row] as? String, for: .normal)
        cell.ccName.tag = indexPath.row
        
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
        cell.ccItemNum.text = ccItemNums[indexPath.row] as! String

       
        return cell
    }
    
    
    func getQuestionAPI() {
        Alamofire.request("http://kit.c-learning.jp/t/ajax/coop/BBL", method: .post, parameters: ["ctID":"c398223976", "caID":"id1"], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                let repsoneResult = response.result.value as? NSDictionary
                //                print("+++++++++++++++++++++++++++")
                //                print(repsoneResult as Any)
                
                let data = repsoneResult!["data"] as! NSArray
//                print("+++++++++++++++++++++++++++")
//                print(data)
                self.ccRanges = data.value(forKey: "ccStuRange") as! NSArray
                self.ccDates = data.value(forKey: "ccDate") as! NSArray
                self.ccSizes = data.value(forKey: "ccTotalSize") as! NSArray
                self.ccNames = data.value(forKey: "ccName") as! NSArray
                self.ccStudentWrites = data.value(forKey: "ccStuWrite") as! NSArray
                self.ccAnonymouss = data.value(forKey: "ccAnonymous") as! NSArray
                self.ccCharNums = data.value(forKey: "ccCharNum") as! NSArray
                self.ccItemNums = data.value(forKey: "ccItemNum") as! NSArray
                //print(self.ccNames)
                //print(self.ccCharNums)
                
                
                self.collectionView.reloadData()
                break
                
            case .failure(_):
                self.PresentAlertController(title: "Warning", message: "failure", actionTitle: "Okay")
                break
                
            }
        }
        
    }
    

}
