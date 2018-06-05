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

struct Thread {
    var ctID: String
    var cNO: String
    var ccID: String
    var cTitle: String
    var fID1: String?
    var fID2: String?
    var fID3: String?
    var cText: String?
    var fName1: String?
    var fName2: String?
    var fName3: String?
    var fExt1: String?
    var fExt2: String?
    var fExt3: String?
    var fSize1: String?
    var fSize2: String?
    var fSize3: String?
    
}
