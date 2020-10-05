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
    
    func uploadPost(caption: String?, photos: [UIImage?], completion: @escaping() -> Void) {
        
        var urlString: [String] = []
        
        for photo in photos {
            guard let imageData = photo?.jpegData(compressionQuality: 0.3) else { return }
            let filename = NSUUID().uuidString
            let storageRef = STORAGE_POST_IMAGES.child(filename)
            
            storageRef.putData(imageData, metadata: nil) { (meta, err) in
                storageRef.downloadURL { (url, err) in
                    print("DEBUG: good until here")
                    guard let imageURL = url?.absoluteString else { return }
                    urlString.append(imageURL)
                    print("DEBUG: url strings are \(urlString)")
                    
                    
                    // urlString 1~3개를 이용하여 db의 user-posts에 넣고
                    // posts에도 넣기.
                }
            }
        }
        
        
        
        
    }
}
