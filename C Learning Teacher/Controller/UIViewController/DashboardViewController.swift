//
//  DashboardViewController.swift
//  C Learning Teacher
//
//  Created by kit on 2/19/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func QuestionnairePressed(_ sender: Any) {
        let Questionnaries = storyboard?.instantiateViewController(withIdentifier: "Questionnaire") as! Questionnaire
        navigationController?.pushViewController(Questionnaries, animated: true)
    }
    
    @IBAction func BulletinBoardPressed(_ sender: Any) {
        let BulletinBoard = storyboard?.instantiateViewController(withIdentifier: "BBID") as! BulletinBoardViewController
        navigationController?.pushViewController(BulletinBoard, animated: true)
    }
    
    @IBAction func TeachingLearningMaterialPressed(_ sender: Any) {
        let TeachingLearningMaterial = storyboard?.instantiateViewController(withIdentifier: "MaterialList") as! MaterialListTableViewController
        navigationController?.pushViewController(TeachingLearningMaterial, animated: true)
        
    }
    
    
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.white
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = "Java2"
        
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        // For right button
        let backButtons = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        backButtons.setBackgroundImage(UIImage(named: "info"), for: .normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: backButtons)
    }

}
