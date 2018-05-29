//
//  PreviewThreeCMViewController.swift
//  C Learning Teacher
//
//  Created by KEEN on 2/14/18.
//  Copyright © 2018 kit. All rights reserved.
//

import UIKit

class PreviewThreeCMViewController: UIViewController {

    @IBOutlet weak var qtitle: UILabel!
    @IBOutlet weak var btn: DLRadioButton!
    @IBOutlet weak var btns: DLRadioButton!
    @IBOutlet weak var btnss: DLRadioButton!
    

}


// APP CYCLE

extension PreviewThreeCMViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        qtitle.text = "[Q] " + qbTitle
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btns.layer.cornerRadius = 5
        btns.layer.borderWidth = 1
        btnss.layer.cornerRadius = 5
        btnss.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// APP UI

extension PreviewThreeCMViewController {
    
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
