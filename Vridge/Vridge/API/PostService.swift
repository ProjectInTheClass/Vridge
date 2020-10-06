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
    
    func uploadPost(caption: String?, photos: [UIImage?], indicator: UIActivityIndicatorView,
                    view: UIViewController, completion: @escaping(Error?, DatabaseReference) -> Void) {
        
        indicator.startAnimating()
        var urlString: [String] = []
        
        let uid = "thisIsUID" // 이 곳에 Auth.auth().currentUser?.uid
        
        for photo in photos {
            guard let imageData = photo?.jpegData(compressionQuality: 0.2) else { return }
            let filename = NSUUID().uuidString
            let storageRef = STORAGE_POST_IMAGES.child(filename)
            
            storageRef.putData(imageData, metadata: nil) { (meta, err) in
                storageRef.downloadURL { (url, err) in
                    guard let imageURL = url?.absoluteString else { return }
                    urlString.append(imageURL)
                    
                    // 사진을 모두 storage에 저장한 후,
                    // 유저가 올린 사진의 갯수가 모두 추가 되었다면 db에 추가.
                    
                    if photos.count == urlString.count {
                        guard let caption = caption else { return }
                        
                        let values = ["caption": caption,
                                      "images": urlString,
                                      "uid": "this is your uid.",
                                      "timestamp": "some number since 1970"] as [String: Any]
                        
                        REF_POSTS.childByAutoId().updateChildValues(values) { (err, ref) in
                            guard let postID = ref.key else { return }
                            REF_USER_POSTS.child(uid).updateChildValues([postID: 1], withCompletionBlock: completion)
                            print("DEBUG: photo uploaded successfully to Storage/post_images.")
                            DispatchQueue.main.async {
                                indicator.stopAnimating()
                            }
                            view.dismiss(animated: true, completion: nil)
                        }
                        
                    }
                }
            }
        }
    }
    
    // 모든 게시글 다 보기
    func fetchPosts() {
        REF_POSTS.observe(.childAdded) { snapshot in
            guard let dic = snapshot.value as? [String: Any] else { return }
            guard let images = dic["image"] as? [String] else { return }
            print("DEBUG: values are '\(images)'")
        }
    }
    
    // 내 타입 게시글만 보기
    func fetchPosts(type: String) {
        // type을 enum으로 만들어 놓기.
    }
    
}
