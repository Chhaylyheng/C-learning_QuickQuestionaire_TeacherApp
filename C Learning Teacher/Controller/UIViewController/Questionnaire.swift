//
//  ViewController.swift
//  C Learning Teacher
//
//  Created by kit on 2/6/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit
import Alamofire


class Questionnaire: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    
    @IBOutlet weak var QuestionCollection: UICollectionView!
    var refreshControl: UIRefreshControl!
    var questionTitle : NSArray = []
    var questionType: NSArray  = []
    var questionQb : NSArray = []
    var questionqpNum : NSArray = []
}

//APP CYCLE

extension Questionnaire {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        QuestionCollection.delegate = self
        QuestionCollection.dataSource = self
        self.getQuestionAPI()
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: Selector(("refresh:")), for: UIControlEvents.allTouchEvents)
        QuestionCollection.addSubview(refreshControl)
        
        
    }
    
}

// APP UI
extension Questionnaire {
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.orange
        self.navigationItem.title = "Questionnaires"
        
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}

//APP Collection Cell

extension Questionnaire {

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return questionType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : QCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "QCell", for: indexPath) as! QCollectionViewCell
        
        if questionType == [] {
            cell.questionBtn.setTitle("No connection", for: .normal)
        } else {
            
            cell.questionBtn.setTitle(questionTitle[indexPath.row] as? String, for: .normal)
            cell.answerNum.setTitle(questionqpNum[indexPath.row] as? String, for: .normal)
            cell.dropDown.addTarget(self, action: #selector(drowDown), for: .touchUpInside)
            cell.dropDown.tag = indexPath.row
            cell.questionBtn.tag = indexPath.row
            cell.preview.tag = indexPath.row
            cell.preview.addTarget(self, action: #selector(previewHandler), for: .touchUpInside)
            cell.questionBtn.addTarget(self, action: #selector(buttonHandler), for: .touchUpInside)
            //cell.deleted.addTarget(self, action: #selector(deletedHandler), for: .touchUpInside)
            
        }
        return cell
    }
    
}

// APP Button Action

extension Questionnaire {
    
    @IBAction func quickBtn(_ sender: UIButton) {
        let vc = CustomAlertViewController()
        self.present(vc, animated: true)
    }
    
    @IBAction func drowDown(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: " Editing", preferredStyle: .actionSheet)
        
        let editInfor = UIAlertAction(title: "Edit Questionnaires Information", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            
        })
        
        let editQuest = UIAlertAction(title: "Edit Questionnaires", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            
        })
        let copyQuest = UIAlertAction(title: "Copy of the Questionnaires", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            
        })
        let downloadQuest = UIAlertAction(title: "Download Answer CSV", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            
        })
        let resetSubmission = UIAlertAction(title: "Reset Submission Status", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            
        })
        let deleteQuest = UIAlertAction(title: "Delete Questionnaires", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            let questionqbID = self.questionQb[sender.tag] as! String
            let checkQuestionqbID = "\(questionqbID)"
            //print(checkQuestionqbID)
            self.deteleQuestionAPI(qb: checkQuestionqbID)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(editInfor)
        alertController.addAction(editQuest)
        alertController.addAction(copyQuest)
        alertController.addAction(downloadQuest)
        alertController.addAction(resetSubmission)
        alertController.addAction(deleteQuest)
        alertController.addAction(cancelAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // Question Title Handler
    @IBAction func buttonHandler(_ sender: UIButton) {
        //print(questionType,"asdf")
        let questionTypes = questionType[sender.tag] as! String
        print(questionType[sender.tag] as! String)
        let checkQuestionqbID = "\(questionTypes)"
        if checkQuestionqbID == "22" || checkQuestionqbID == "24" ||  checkQuestionqbID == "20" {
            let Dtail = storyboard?.instantiateViewController(withIdentifier: "DetailViewV")
            qbID  = questionQb[sender.tag] as! String
            qbTitle = questionTitle[sender.tag] as! String
            navigationController?.pushViewController(Dtail!, animated: true)
            
            
        } else if checkQuestionqbID == "23" || checkQuestionqbID == "25" ||  checkQuestionqbID == "21"  {
            let comment = storyboard?.instantiateViewController(withIdentifier: "CommentV") as! QuestionwithcmdViewController
            print(questionQb[sender.tag] as! String,"++++")
            qbID  = questionQb[sender.tag] as! String
            qbTitle = questionTitle[sender.tag] as! String
            
            navigationController?.pushViewController(comment, animated: true)
            
        } else if checkQuestionqbID == "30" {
            
            let QuestionChoice = storyboard?.instantiateViewController(withIdentifier: "barChartThree") as! BarChartThreeViewController
            qbID  = questionQb[sender.tag] as! String
            qbTitle = questionTitle[sender.tag] as! String
            navigationController?.pushViewController(QuestionChoice, animated: true)
        } else if checkQuestionqbID == "40" {
            
            let QuestionChoice = storyboard?.instantiateViewController(withIdentifier: "barChartFour") as! BarChartFourViewController
            qbID  = questionQb[sender.tag] as! String
            qbTitle = questionTitle[sender.tag] as! String
            navigationController?.pushViewController(QuestionChoice, animated: true)
        } else if checkQuestionqbID == "50" {
            
            let QuestionChoice = storyboard?.instantiateViewController(withIdentifier: "QuestionChoiceV") as! ChooiceQuestionViewController
            qbID  = questionQb[sender.tag] as! String
            qbTitle = questionTitle[sender.tag] as! String
            navigationController?.pushViewController(QuestionChoice, animated: true)
        } else {
            
            
            
        }
        
    }
    @IBAction func SwipPen(_ sender: Any) {
        self.getQuestionAPI()
    }
    
    
//    @IBAction func deletedHandler(_ sender: UIButton) {
//        let questionqbID = questionQb[sender.tag] as! String
//        let checkQuestionqbID = "\(questionqbID)"
//        print(checkQuestionqbID)
//        deteleQuestionAPI(qb: checkQuestionqbID)
//        
//    }
    
    // Preview Button Handler
    @IBAction func previewHandler(_ sender: UIButton) {
        let questionTypes = questionType[sender.tag] as! String
        print(questionType[sender.tag] as! String)
        let checkQuestionqbID = "\(questionTypes)"
        if checkQuestionqbID == "22" {
            let Dtail = storyboard?.instantiateViewController(withIdentifier: "yesNo")
            qbID  = questionQb[sender.tag] as! String
            qbTitle = questionTitle[sender.tag] as! String
            navigationController?.pushViewController(Dtail!, animated: true)
        } else if checkQuestionqbID == "23" {
            let Dtail = storyboard?.instantiateViewController(withIdentifier: "yesNoCM")
            qbID  = questionQb[sender.tag] as! String
            print(qbID,"++++")
            qbTitle = questionTitle[sender.tag] as! String
            navigationController?.pushViewController(Dtail!, animated: true)
        } else if checkQuestionqbID == "24" {
            let Dtail = storyboard?.instantiateViewController(withIdentifier: "agreeDisagree")
            qbID  = questionQb[sender.tag] as! String
            qbTitle = questionTitle[sender.tag] as! String
            navigationController?.pushViewController(Dtail!, animated: true)
        } else if checkQuestionqbID == "25" {
            let Dtail = storyboard?.instantiateViewController(withIdentifier: "agreeDisagreeCM")
            qbID  = questionQb[sender.tag] as! String
            qbTitle = questionTitle[sender.tag] as! String
            navigationController?.pushViewController(Dtail!, animated: true)
        } else if checkQuestionqbID == "20" {
            let Dtail = storyboard?.instantiateViewController(withIdentifier: "twoChoices")
            qbID  = questionQb[sender.tag] as! String
            qbTitle = questionTitle[sender.tag] as! String
            navigationController?.pushViewController(Dtail!, animated: true)
        } else if checkQuestionqbID == "21" {
            let Dtail = storyboard?.instantiateViewController(withIdentifier: "twoChoicesCM")
            qbID  = questionQb[sender.tag] as! String
            qbTitle = questionTitle[sender.tag] as! String
            navigationController?.pushViewController(Dtail!, animated: true)
        } else if checkQuestionqbID == "30" {
            let Dtail = storyboard?.instantiateViewController(withIdentifier: "threeChoices")
            qbID  = questionQb[sender.tag] as! String
            qbTitle = questionTitle[sender.tag] as! String
            navigationController?.pushViewController(Dtail!, animated: true)
        } else if checkQuestionqbID == "31" {
            let Dtail = storyboard?.instantiateViewController(withIdentifier: "threeChoicesCM")
            qbID  = questionQb[sender.tag] as! String
            qbTitle = questionTitle[sender.tag] as! String
            navigationController?.pushViewController(Dtail!, animated: true)
        } else if checkQuestionqbID == "40" {
            let Dtail = storyboard?.instantiateViewController(withIdentifier: "fourChoices")
            qbID  = questionQb[sender.tag] as! String
            qbTitle = questionTitle[sender.tag] as! String
            navigationController?.pushViewController(Dtail!, animated: true)
        } else if checkQuestionqbID == "41" {
            let Dtail = storyboard?.instantiateViewController(withIdentifier: "fourChoicesCM")
            qbID  = questionQb[sender.tag] as! String
            qbTitle = questionTitle[sender.tag] as! String
            navigationController?.pushViewController(Dtail!, animated: true)
        } else if checkQuestionqbID == "50" {
            let Dtail = storyboard?.instantiateViewController(withIdentifier: "fiveChoices")
            qbID  = questionQb[sender.tag] as! String
            qbTitle = questionTitle[sender.tag] as! String
            navigationController?.pushViewController(Dtail!, animated: true)
        } else if checkQuestionqbID == "51" {
            let Dtail = storyboard?.instantiateViewController(withIdentifier: "fiveChoicesCM")
            qbID  = questionQb[sender.tag] as! String
            qbTitle = questionTitle[sender.tag] as! String
            navigationController?.pushViewController(Dtail!, animated: true)
        } else if checkQuestionqbID == "1" {
            let Dtail = storyboard?.instantiateViewController(withIdentifier: "commentOnly")
            qbID  = questionQb[sender.tag] as! String
            qbTitle = questionTitle[sender.tag] as! String
            navigationController?.pushViewController(Dtail!, animated: true)
        } else {
            print("error")
        }
        
    }
    
    
}

// APP API

extension Questionnaire {
    
    func refresh(sender:AnyObject) {
        self.getQuestionAPI()
    }
    
    func reload() {
        self.getQuestionAPI()
    }
    
    func deteleQuestionAPI(qb : String) {
        Alamofire.request("https://kit.c-learning.jp/t/ajax/quest/Delete", method: .post, parameters: ["qb":qb,], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print(response.result.value)
                }
                self.getQuestionAPI()
                break
                
            case .failure(_):
                print(response.result.error)
                break
                
            }
        }
        
    }
    
    
    
    func getQuestionAPI() {
        Alamofire.request("https://kit.c-learning.jp/t/ajax/quest/Question", method: .get, parameters: ["":"",], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if let dictionary = response.result.value as? [String: Any] {
                    
                    for i in dictionary {
                        
                        if let test = i.value as? NSArray {
                            self.questionTitle = test.value(forKey: "qbTitle") as! NSArray
                            self.questionType = (test.value(forKey: "qbQuickMode") as! NSArray)
                            self.questionQb = test.value(forKey: "qbID") as! NSArray
                            self.questionqpNum = test.value(forKey: "qpNum") as! NSArray
                            
                        } else {
                            self.questionType = []
                            self.questionQb = []
                        }
                        
                    }
                }
                self.QuestionCollection.reloadData()
                break
                
            case .failure(_):
                print(response.result.error)
                break
                
            }
        }
        
    }

    
}


