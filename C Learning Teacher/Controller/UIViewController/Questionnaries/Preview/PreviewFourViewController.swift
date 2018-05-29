//
//  PreviewFourViewController.swift
//  C Learning Teacher
//
//  Created by KEEN on 2/14/18.
//  Copyright © 2018 kit. All rights reserved.
//

import UIKit

class PreviewFourViewController: UIViewController {

    @IBOutlet weak var qtitle: UILabel!
    @IBOutlet weak var btnone: DLRadioButton!
    @IBOutlet weak var btntwo: DLRadioButton!
    @IBOutlet weak var btnthree: DLRadioButton!
    @IBOutlet weak var btnfour: DLRadioButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        qtitle.text = "[Q] " + qbTitle
        btnone.layer.cornerRadius = 5
        btnone.layer.borderWidth = 1
        btntwo.layer.cornerRadius = 5
        btntwo.layer.borderWidth = 1
        btnthree.layer.cornerRadius = 5
        btnthree.layer.borderWidth = 1
        btnfour.layer.cornerRadius = 5
        btnfour.layer.borderWidth = 1
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

// APP CYCLE
extension PreviewFourViewController {
    
    
    
}
// APP UI
extension PreviewFourCMViewController {
    
    
}
