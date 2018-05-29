//
//  PreviewFiveViewController.swift
//  C Learning Teacher
//
//  Created by KEEN on 2/14/18.
//  Copyright © 2018 kit. All rights reserved.
//

import UIKit

class PreviewFiveViewController: UIViewController {

    @IBOutlet weak var qtitle: UILabel!
    @IBOutlet weak var btnone: DLRadioButton!
    @IBOutlet weak var btntwo: DLRadioButton!
    @IBOutlet weak var btnthree: DLRadioButton!
    @IBOutlet weak var btnfour: DLRadioButton!
    @IBOutlet weak var btnfive: DLRadioButton!
    

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
extension PreviewFiveViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        qtitle.text = "[Q] " + qbTitle
        qtitle.text = "[Q] " + qbTitle
        btnone.layer.cornerRadius = 5
        btnone.layer.borderWidth = 1
        btntwo.layer.cornerRadius = 5
        btntwo.layer.borderWidth = 1
        btnthree.layer.cornerRadius = 5
        btnthree.layer.borderWidth = 1
        btnfour.layer.cornerRadius = 5
        btnfour.layer.borderWidth = 1
        btnfive.layer.cornerRadius = 5
        btnfive.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// APP UI

extension PreviewFiveViewController {
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
