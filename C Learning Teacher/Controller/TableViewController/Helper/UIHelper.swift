//
//  UIHelper.swift
//  C Learning Teacher
//
//  Created by KEEN on 2/11/18.
//  Copyright © 2018 kit. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
    
    func getTopViewController() -> UIViewController
    {
        
        var topViewController = UIApplication.shared.delegate!.window!!.rootViewController!
        while (topViewController.presentedViewController != nil) {
            topViewController = topViewController.presentedViewController!
        }
        return topViewController
    }
}





