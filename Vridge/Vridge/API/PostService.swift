//
//  PostService.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/05.
//

import UIKit

import Firebase

struct PostService {
    
    static let shared = PostService()
    
    func uploadPost(caption: String, photo: [UIImage], completion: @escaping() -> Void) {
        
        Database.database().reference().child("new-folder").updateChildValues(["content": caption])
    }
}
