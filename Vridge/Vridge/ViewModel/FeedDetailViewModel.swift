//
//  FeedDetailViewModel.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/11/06.
//

import UIKit

import Kingfisher

struct FeedDetailViewModel {
    
    var post: Post
    
    init(post: Post) {
        self.post = post
    }
    
    var type: String {
        return "@\(post.user.vegieType?.rawValue ?? "@")" 
    }
    
    var typeColor: UIColor {
        return post.user.vegieType?.typeColor ?? .black
    }
    
    var username: String {
        return post.user.username
    }
    
    var timestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: post.timestamp)
    }
    
    var caption: String {
        return post.caption
    }
    
    var profileImage: URL {
        return post.user.profileImageURL!
    }
}
