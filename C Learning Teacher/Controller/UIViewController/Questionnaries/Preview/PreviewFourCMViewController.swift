//
//  PreviewFourCMViewController.swift
//  C Learning Teacher
//
//  Created by KEEN on 2/14/18.
//  Copyright © 2018 kit. All rights reserved.
//

import UIKit

class PreviewFourCMViewController: UIViewController {

    @IBOutlet weak var qtitle: UILabel!
    @IBOutlet weak var btnOne: DLRadioButton!
    @IBOutlet weak var btnTwo: DLRadioButton!
    @IBOutlet weak var btnThree: DLRadioButton!
    @IBOutlet weak var btnFour: DLRadioButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        qtitle.text = "[Q] " + qbTitle
        btnOne.layer.cornerRadius = 5
        btnOne.layer.borderWidth = 1
        btnTwo.layer.cornerRadius = 5
        btnTwo.layer.borderWidth = 1
        btnThree.layer.cornerRadius = 5
        btnThree.layer.borderWidth = 1
        btnFour.layer.cornerRadius = 5
        btnFour.layer.borderWidth = 1
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpNavBar(){
        //For title in navigation bar
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.orange
        self.navigationItem.title = "Preview"
        
        //For back button in navigation bar
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }

}
