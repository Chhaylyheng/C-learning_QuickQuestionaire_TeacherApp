//
//  Screen.swift
//  Natra
//
//  Created by Choeng Eanghort on 12/28/16.
//  Copyright © 2016 Magical Technology. All rights reserved.
//

import UIKit

struct Screen {
    
    static func goToMain(fromController viewController: UIViewController,storyBoardId : String){
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainController = storyboard.instantiateViewController(withIdentifier: storyBoardId)
        UIApplication.shared.keyWindow?.rootViewController = mainController
    }
    
    static func main()  {
        let DashController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "courselistID") as! SWRevealViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = DashController
        
    }
 
    
    
}
