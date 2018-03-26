//
//  CourseListViewController.swift
//  C Learning Teacher
//
//  Created by kit on 2/19/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit

class CourseListViewController: UIViewController {
    
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
        UserDefaults.standard.set(true, forKey: "loginBefore")

        // Do any additional setup after loading the view.
        setUpNavBar()

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func BtnMenu(_ sender: Any) {
        
        Slidemenu()
    }
    
    @IBAction func addCourse(_ sender: Any) {
        print("This Function isnot working yet")
        
    }
    
    
    //Func for show the Slidemenu
    func Slidemenu() {
        if revealViewController() != nil {
            self.revealViewController().revealToggle(animated: true)
            revealViewController().rearViewRevealWidth = (view.bounds.width * 80 ) / 100
            
        }
    }
    
    @IBAction func classPressed(_ sender: Any) {
        
        let Dashboard = storyboard?.instantiateViewController(withIdentifier: "Dashboard") as! DashboardViewController
        navigationController?.pushViewController(Dashboard , animated: true)
    }
    
    
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.white
        self.navigationItem.title = "My Classes"
        
    }
    

}
