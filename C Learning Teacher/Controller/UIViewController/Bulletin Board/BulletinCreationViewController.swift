//
//  BulletinCreationViewController.swift
//  C Learning Teacher
//
//  Created by kit on 2/28/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftMultiSelect

class BulletinCreationViewController: UIViewController,SwiftMultiSelectDelegate,SwiftMultiSelectDataSource {
   
    @IBOutlet weak var fair: DLRadioButton!
    @IBOutlet weak var failed: DLRadioButton!
    @IBOutlet weak var anonymous: DLRadioButton!
    @IBOutlet weak var register: DLRadioButton!
    @IBOutlet weak var instrucRegis: DLRadioButton!
    @IBOutlet weak var all: DLRadioButton!
    @IBOutlet weak var choice: DLRadioButton!
    @IBOutlet weak var none: DLRadioButton!
    @IBOutlet weak var bulletinName: UITextField!
    
    var ctID = ""
    var ccID = ""
    
    var studentName : NSArray = []
    var studentClass : NSArray = []
    var studentNum : NSArray = []
    var studentIDs : NSArray = []
    
    var bulletin : String = ""
    var submission : String = ""
    var nonymous : String = ""
    var applicable : String = ""
    let alert = SweetAlert()
    
    var items:[SwiftMultiSelectItem] = [SwiftMultiSelectItem]()
    var initialValues:[SwiftMultiSelectItem] = [SwiftMultiSelectItem]()
    var selectedItems:[SwiftMultiSelectItem] = [SwiftMultiSelectItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonStyle()
        setUpNavBar()
        
        Config.doneString = "OK"
        SwiftMultiSelect.dataSource     = self
        SwiftMultiSelect.delegate       = self
        SwiftMultiSelect.dataSourceType = .custom
        
        getAllStudent()
        
    }
    
    func createItems(){
        
        //print("\(studentName.count) ?")
        self.items.removeAll()
        self.initialValues.removeAll()
        for i in 0...(studentName.count - 1){
            items.append(SwiftMultiSelectItem(row: i, title: "\(studentName[i])", description: "\(studentClass[i]) . \(studentNum[i])", studentID: "\(studentIDs[i])"))
        }
        
        //self.initialValues = [self.items.first!,self.items[1],self.items[2]]
        self.selectedItems = items
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submission(_ sender: Any) {
        if (sender as AnyObject).tag == 1 {
            submission = "1"
        } else {
            submission = "0"
        }
    }
    @IBAction func Anonymous(_ sender: Any) {
        if (sender as AnyObject).tag == 1 {
            nonymous = "2"
        } else if (sender as AnyObject).tag == 2 {
            nonymous = "1"
        } else if (sender as AnyObject).tag == 3 {
            nonymous = "0"
        }
    }
    @IBAction func Aplicable(_ sender: Any) {
        if (sender as AnyObject).tag == 1 {
            applicable = "2"
        } else if (sender as AnyObject).tag == 2 {
            
            applicable = "1"
            
            SwiftMultiSelect.initialSelected = initialValues
            SwiftMultiSelect.Show(to: self)
            
        } else if (sender as AnyObject).tag == 3 {
            applicable = "0"
        }
    }
    
    
    func buttonStyle() {
        fair.layer.cornerRadius = 5
        fair.layer.borderWidth = 1
        failed.layer.cornerRadius = 5
        failed.layer.borderWidth = 1
        anonymous.layer.cornerRadius = 5
        anonymous.layer.borderWidth = 1
        register.layer.cornerRadius = 5
        register.layer.borderWidth = 1
        instrucRegis.layer.cornerRadius = 5
        instrucRegis.layer.borderWidth = 1
        all.layer.cornerRadius = 5
        all.layer.borderWidth = 1
        choice.layer.cornerRadius = 5
        choice.layer.borderWidth = 1
        none.layer.cornerRadius = 5
        none.layer.borderWidth = 1
        
    }
    
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.orange
        self.navigationItem.title = "Bulletin Board Creation"
        
        //For back button in navigation bar
//        let backButton = UIBarButtonItem()
//        backButton.title = "Cancel"
//        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func createAction(_ sender: Any) {
        bulletin = bulletinName.text!
        if (bulletinName.text?.isEmpty)! {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            PresentAlertController(title: "Warning", message: "Please enter Bulletin Board Name", actionTitle: "Okay")
        } else if submission.isEmpty {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            PresentAlertController(title: "Warning", message: "Please select Student Article Submission", actionTitle: "Okay")
        } else if nonymous.isEmpty {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            PresentAlertController(title: "Warning", message: "Please select the Anonymous Option", actionTitle: "Okay")
        } else if applicable.isEmpty {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            PresentAlertController(title: "Warning", message: "Please select the Applicable Student Option", actionTitle: "Okay")
        } else {
            self.createBulletin()
        }
    }
    
    
    func createBulletin() {
        createBulletinBoard()
    }
    
    
    func AddStudent() {
        for item in initialValues {
            //print(item.studentID, "Student ID")
            addStudentToBB(studentID: item.studentID)
            
        }
    }
    
    
    //MARK: - SwiftMultiSelectDelegate
    func userDidSearch(searchString: String) {
        if searchString == "" {
            selectedItems = items
        }else{
            selectedItems = items.filter({$0.title.lowercased().contains(searchString.lowercased()) || ($0.description != nil && $0.description!.lowercased().contains(searchString.lowercased())) })
        }
    }
    
    func numberOfItemsInSwiftMultiSelect() -> Int {
        return selectedItems.count
    }
    
    func swiftMultiSelect(didUnselectItem item: SwiftMultiSelectItem) {
        print("row: \(item.title) has been deselected!")
    }
    
    func swiftMultiSelect(didSelectItem item: SwiftMultiSelectItem) {
        print("item: \(item.title) has been selected!")
    }
    
    func didCloseSwiftMultiSelect() {
        
    }
    
    func swiftMultiSelect(itemAtRow row: Int) -> SwiftMultiSelectItem {
        return selectedItems[row]
    }
    
    func swiftMultiSelect(didSelectItems items: [SwiftMultiSelectItem]) {
        
        initialValues   = items
        print("you have been selected: \(items.count) items!")
        
        for item in items {
            print(item.string)
            print(item.studentID)
        }
    }
    
}


// MARK: API

extension BulletinCreationViewController {
    
    //https://kit.c-learning.jp/t/ajax/coop/stuadd
    // Get all the student name in the class
    func getAllStudent() {
        Alamofire.request("https://kit.c-learning.jp/t/ajax/coop/stuadd", method: .post, parameters: ["ctID":"c398223976"], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                let repsoneResult = response.result.value as? NSDictionary
                let data = repsoneResult!["data"] as! NSArray
                self.studentName = data.value(forKey: "stName") as! NSArray
                self.studentClass = data.value(forKey: "stClass") as! NSArray
                self.studentNum = data.value(forKey: "stNO") as! NSArray
                self.studentIDs = data.value(forKey: "stID") as! NSArray
                
                self.createItems()
                
                break;
            case .failure(_):
                let alertController:UIAlertController = UIAlertController(title:nil, message: "There is no internet connection", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction:UIAlertAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler:{ (action:UIAlertAction!) -> Void in
                })
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)

                break;
            }
        }
    }
    
    
    
    // MARK: Create Bulletin Board
    func createBulletinBoard() {
        Alamofire.request("https://kit.c-learning.jp/t/ajax/coop/cateCreate", method: .post, parameters: ["ctID":ctID,"cc_name":bulletin, "cc_stuwrite":submission, "cc_anonymous": nonymous, "cc_sturange": applicable]).responseJSON {
            response in
            if response.result.isSuccess {
                let result = JSON(response.result.value!)
                self.ccID = result["mes"].string!
                if self.applicable.isEqual("1") {
                    self.AddStudent()
                }
                self.alert.showAlert("Done", subTitle: "Create a new Bulletin Board is Done", style: AlertStyle.none ,buttonTitle: "Okay") { Void in
                    
                    self.dismiss(animated: true, completion: nil)
                    
                }
            }
            else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    
    
    // MARK: Add Student into Bulletin Board after create Bulletin Board
    func addStudentToBB(studentID: String) {
        Alamofire.request("http://kit.c-learning.jp/t/ajax/coop/CoopAdd", method: .post, parameters: ["ct": ctID, "cc": ccID, "st": studentID as Any]).responseJSON {
            response in
            if response.result.isSuccess {
                let result = JSON(response.result.value!)
                print(result)
                if result["err"] == 0 && result["res"] == 1 {
                    print("Successful add students into choice")
                } else {
                    print("Students are not successful add to Bulletin Board")
                }
            } else {
                print("Error \(String(describing: response.result.error))")
            }
            
        }
    }
}
