//
//  Sharing.swift
//  CumtomLoginDemo
//
//  Created by Kang Mingu on 2020/09/10.
//  Copyright © 2020 Kang Mingu. All rights reserved.
//

import Foundation

struct Sharing {
    
    static var shared = Sharing()
    
    var contents: String = ""
    var name: String = ""
    var image: String = ""
    var comment: String = ""
    var uid: String = ""
    var userMail: String = ""
}
