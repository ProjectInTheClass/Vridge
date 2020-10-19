//
//  Post.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/06.
//

import Foundation

struct Post {
    
    let postID: String
    let user: User
    var caption: String
    var images: [String]
    var likes: Int
    var timestamp: Date!
    var didLike = false
    
    init(user: User, postID: String, dictionary: [String: Any]) {
        
        self.user = user
        self.postID = postID
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.images = dictionary["images"] as? [String] ?? [""]
        self.likes = dictionary["likes"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}
