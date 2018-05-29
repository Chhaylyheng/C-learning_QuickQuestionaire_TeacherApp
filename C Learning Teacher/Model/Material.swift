//
//  Material.swift
//  C Learning Teacher
//
//  Created by kit on 5/26/2561 BE.
//  Copyright © 2561 BE kit. All rights reserved.
//

import Foundation

struct MaterialList: Decodable {
    var mes: [Material]
}

struct Material: Decodable {
    
    var mcID: String
    var mcName: String
    var mcMail: String
    var mcSort: String
    var mcDate: String
    var mcNum : String
    var mcPubNum: String
    var mcTotalSize: String?
    var mcLastDate: String?
    
}


