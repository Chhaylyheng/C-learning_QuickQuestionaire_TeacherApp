//
//  LoginViewController.swift
//  C Learning Teacher
//
//  Created by kit on 2/16/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginbtn: UIButton!
    var image : NSData? = nil
    
    
    // Check if it is the valid email
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }

}

// APP Cycle
extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        MakeLeftViewIconToTextField(textField: email, icon: "user")
        MakeLeftViewIconToTextField(textField: password, icon: "lock")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// UI
extension LoginViewController {
    
    // Put the icon to the left side of the textField
    func MakeLeftViewIconToTextField(textField: UITextField, icon: String) {
        let imageView = UIImageView();
        let image = UIImage(named: icon);
        imageView.image = image;
        imageView.frame = CGRect(x: Int(textField.frame.height / 3), y: Int(textField.frame.height / 3), width: Int(textField.frame.height / 2.5), height: Int(textField.frame.height / 2.5))
        textField.addSubview(imageView)
        
        let leftView = UIView.init(frame: CGRect(x: 10, y: 10, width: textField.frame.height, height: 25))
        textField.leftView = leftView;
        textField.leftViewMode = UITextFieldViewMode.always
        
    }
}


// Button Action
extension LoginViewController {
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        UIComponentHelper.PresentActivityIndicator(view: self.view, option: true)
        //        InternetConnection.second = 0
        //        InternetConnection.countTimer.invalidate()
        if (email.text?.isEmpty)!  &&  (password.text?.isEmpty)! {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            PresentAlertController(title: "Warning", message: "Please properly enter your email", actionTitle: "Got it")
            return
            
        }
        
        if ( email.text?.isEmpty)! {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            PresentAlertController(title: "Warning", message: "Please properly enter your email", actionTitle: "Got it")
            return
        }
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: email.text!)
        if isEmailAddressValid == false
        {
            print("Email address is not valid")
            //displayAlertMessage(messageToDisplay: "Email address is not valid")
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            PresentAlertController(title: "Warning", message: "Email address is not valid", actionTitle: "Go it")
            return
        }
        
        
        if (password.text?.isEmpty)! {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            PresentAlertController(title: "Warning", message: "Please properly enter your password", actionTitle: "Go it")
            return
        }
        if password.text!.count < 8 {
            UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
            PresentAlertController(title: "Warning", message: "Password must be greater than 8 characters", actionTitle: "Go it")
            return
        }
        getLoginAPI(email : email.text!  ,password: password.text!)
        
    }
}

// get API
extension LoginViewController {
    
    func getLoginAPI(email : String , password: String) -> String {
        
        let validationValue : String = ""
        let deviceId  =  UIDevice.current.identifierForVendor!.uuidString
        Alamofire.request("https://kit.c-learning.jp/t/app/login.json", method: .post, parameters: ["login":email ,"pass":password,"os":"iOS","token" : "","did":deviceId], encoding: URLEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                
                print(response.result.value as? NSDictionary as Any)
                let repsoneResult = response.result.value as? NSDictionary
                
                if repsoneResult!["err"] as! Int == -2 {
                  UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                  self.PresentAlertController(title: "Error", message: repsoneResult!["msg"] as! String , actionTitle: "Okay")
                    
                } else {
                    let res = repsoneResult!["res"] as! NSDictionary
                    let haskey = res["hash"] as! String
                    let teacher = res["Teacher"] as! NSDictionary
                    let ttImage = teacher["ttImage"] as! String
                    let ttLastLoginDate = teacher["ttLastLoginDate"] as! String
                    let imageUrl : URL = URL(string: "https://kit.c-learning.jp/upload/profile/t/"+ttImage)!
                    //print(imageUrl,"+++")
                    
                    self.getDataFromUrl(url: imageUrl){
                        (data, response, error)  in
                        guard let data = data, error == nil
                            else {
                                return
                        }
                        self.image = (data as NSData?)!
                        
                        //print(ttLastLoginDate,"+++")
                        if let ttName = teacher["ttName"] {
                            Userprofiles.insertUserProfile(_email: email,_username: ttName as! String,_hashkey : haskey, _profileImage: self.image!, _lastlogin: ttLastLoginDate) { (result) -> () in
                                // do stuff with the result
                                if result {
                                    Screen.goToMain(fromController: self, storyBoardId: "courselistID")
                                }
                            }
                        }
                    }
                
                }
                
                break
                
            case .failure(_):
                 UIComponentHelper.PresentActivityIndicator(view: self.view, option: false)
                self.PresentAlertController(title: "Warning", message: "There is no internet connection", actionTitle: "Okay")
                
                break
                
            }
        }
        
        return validationValue
        
    }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask (with: url) { (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
}


