//
//  MenuViewController.swift
//  C Learning Teacher
//
//  Created by kit on 2/19/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit
import CoreData

class MenuViewController: UIViewController {
    
    
    @IBOutlet weak var profileImage: RoundButton!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var lastlogin: UILabel!
    var hashKey : String = ""
    var image : NSData? = nil
    
    var userProfile_ids = [UserProfile]()
    let userProfileRequest:NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserProfile()
        roundProfileimage()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserProfile() {
        do {
            userProfile_ids = try manageObjectContext.fetch(userProfileRequest)
            if userProfile_ids == [] {
                //
            } else {
                for i in userProfile_ids {
                    
                    if let userString = i.username {
                        username.text = userString
                        userEmail.text = i.email!
                        hashKey = i.hashkey!
                        lastlogin.text = i.lastlogin!
                        image = i.profileImage! as NSData
                        let imageNew : UIImage = UIImage(data: self.image! as Data ,scale: 1.0)!
                        profileImage.setImage(imageNew, for: .normal)
                        
                    }

                }
                getLoginbyHashKey(hashKey: hashKey)
            }
            
        }  catch {
            print(error)
        }
        
    }
    
    func getLoginbyHashKey(hashKey : String) {
        
    }
    func roundProfileimage() {
      
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        profileImage.imageView?.contentMode = .scaleAspectFill
        profileImage.contentHorizontalAlignment = .fill
        profileImage.contentVerticalAlignment = .fill
    }
    
    @IBAction func mycoursePressed(_ sender: Any) {
        Screen.goToMain(fromController: self, storyBoardId: "courselistID")
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        let logoutAlert = UIAlertController(title: "Logout", message: "Are you sure to logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        
        logoutAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action: UIAlertAction!) in
            UserDefaults.standard.set(false, forKey: "loginBefore")
            Userprofiles.deleteAllData(entity: "UserProfile")
            Screen.goToMain(fromController: self, storyBoardId: "loginIdentify")
            
        }))
        
        logoutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present( logoutAlert, animated: true, completion: nil)
        
        
    }
    

}
