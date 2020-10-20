//
//  User.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/06.
//

import Foundation

import Firebase

struct User {
    
    let uid: String
    var username: String
    let email: String
    var point: Int
    var profileImageURL: URL?
    var vegieType: VegieTypes?
    var type: String?
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    
    init(uid: String, dictionary: [String: AnyObject]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.point = dictionary["point"] as? Int ?? 0
        
        if let value = dictionary["type"] as? String {
            self.vegieType = VegieTypes(rawValue: value)
            self.type = vegieType?.rawValue
        }
        
        if let imageURL = dictionary["profileImageURL"] as? String {
            guard let url = URL(string: imageURL) else { return }
            profileImageURL = url
        }
        
//        if let type = dictionary["type"] as? String {
//            self.type = type
//        }
        
    
        
    }
}

