//
//  PreviewYesNoViewController.swift
//  C Learning Teacher
//
//  Created by KEEN on 2/13/18.
//  Copyright © 2018 kit. All rights reserved.
//

import UIKit

class PreviewYesNoViewController: UIViewController {

    @IBOutlet weak var qtitle: UILabel!
    @IBOutlet weak var btn: DLRadioButton!
    @IBOutlet weak var btns: DLRadioButton!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// APP CYCLE
extension PreviewYesNoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        qtitle.text = "[Q] " + qbTitle
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btns.layer.cornerRadius = 5
        btns.layer.borderWidth = 1
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// APP UI
extension PreviewYesNoViewController {
    
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

// APP
extension PreviewYesNoViewController {
    
    
}
