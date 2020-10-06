//
//  User.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/06.
//

import Foundation

struct User {
    
    let uid: String
    var username: String
    var point: Int!
    var profileImageURL: URL?
    
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        
        if let imageURL = dictionary["profileImageURL"] as? String {
            guard let url = URL(string: imageURL) else { return }
            profileImageURL = url
        }
        
        if let point = dictionary["point"] as? Int {
            self.point = point
        }
        
    }
}

