//
//  CustomPhotoPickerViewController.swift
//  C Learning Teacher
//
//  Created by kit on 5/30/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import Foundation
import TLPhotoPicker

class CustomPhotoPickerViewController: TLPhotosPickerViewController {
    override func makeUI() {
        super.makeUI()
        self.customNavItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .stop, target: nil, action: #selector(customAction))
    }
    @objc func customAction() {
        self.dismiss(animated: true, completion: nil)
    }
}
