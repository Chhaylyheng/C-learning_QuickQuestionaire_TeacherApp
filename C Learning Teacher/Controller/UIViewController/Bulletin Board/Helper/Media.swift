//
//  Media.swift
//  C Learning Teacher
//
//  Created by kit on 5/31/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import Foundation

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "noname.jpg"
        
        guard let data = UIImageJPEGRepresentation(image, 0.5) else { return nil }
        self.data = data
    }
    
}
