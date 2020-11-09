//
//  Notice.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/11/10.
//

import Foundation

struct Notice {
    
    let title: String
    let content: String
    var timestamp: Date!
    
    init(dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.content = dictionary["content"] as? String ?? ""
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}
