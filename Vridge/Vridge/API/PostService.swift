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
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        indicator.startAnimating()
        var urlString: [String] = []
        
//        switch photos.count {
//        case 1:
//        case 2:
//        case 3:
//        default:
//            print(fatalError())
//        }
        
        for photo in photos {
            guard let imageData = photo?.jpegData(compressionQuality: 0.25) else { return }
            let filename = NSUUID().uuidString
            let storageRef = STORAGE_POST_IMAGES.child(filename)
            print("DEBUG: uploading images = \(photo)")
            
            storageRef.putData(imageData, metadata: nil) { (meta, err) in
                storageRef.downloadURL { (url, err) in
                    guard let imageURL = url?.absoluteString else { return }
                    urlString.append(imageURL)
                    print("DEBUG: uploading image URLs = \(urlString)")
                    
                    
                    
                    
                    // 사진을 Storage에 저장한 후, url을 다운로드 하는 과정에서 순서가 뒤바뀜.
                    
                    
                    // 해결책 --
                    // 위에 있는 switch문으로 한 번 바꿔서 실행을 해보자! 개노가다
                    
                    
                    
                    if photos.count == urlString.count {
                        guard let caption = caption else { return }
                        
                        let values = ["caption": caption,
                                      "images": urlString,
                                      "uid": uid,
                                      "timestamp": Int(NSDate().timeIntervalSince1970)] as [String: Any]
                        
                        REF_POSTS.childByAutoId().updateChildValues(values) { (err, ref) in
                            guard let postID = ref.key else { return }
                            
                            pointUp { (error, ref) in
                                REF_USER_POSTS.child(uid).updateChildValues([postID: 1], withCompletionBlock: completion)
                            }
                            
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
    func fetchPosts(completion: @escaping([Post]) -> Void) {
        var post = [Post]()
        
        REF_POSTS.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let postID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                
                let posts = Post(user: user, postID: postID, dictionary: dictionary)
                post.append(posts)
                completion(post)
            }
        }
    }
    
    
    func pointUp(completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_POINT.child(uid).observeSingleEvent(of: .value) { snapshot in
            let currentPoint = snapshot.value as! Int
            print("DEBUG: snapshot value is \(currentPoint), about to plus one")
            
            REF_USER_POINT.updateChildValues([uid: currentPoint + 1]) { (err, ref) in
                REF_USERS.child(uid).updateChildValues(["point": currentPoint + 1], withCompletionBlock: completion)
            }
        }
    }
    
    func pointDown(completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_POINT.child(uid).observeSingleEvent(of: .value) { snapshot in
            let currentPoint = snapshot.value as! Int
            print("DEBUG: snapshot value is \(currentPoint), about to minus one")
            
            REF_USER_POINT.updateChildValues([uid: currentPoint - 1]) { (err, ref) in
                REF_USERS.child(uid).updateChildValues(["point": currentPoint - 1], withCompletionBlock: completion)
            }
        }
    }
    
    // 내 타입 게시글만 보기
    func fetchPosts(type: String) {
        // type을 enum으로 만들어 놓기.
    }
    
    
    func deletePost(row: Int, viewController: HomeViewController, postId: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_POSTS.child(postId).removeValue { (err, ref) in
            REF_USER_POSTS.child(uid).child(postId).removeValue { (err, ref) in
                pointDown(completion: completion)
                print("DEBUG: SUCCESSFULLY DELETE POST")
                viewController.posts.remove(at: row)
            }
        }
    }
    
    func amendPost(row: Int, viewController: HomeViewController, post: Post, completion: @escaping([String: Any]) -> Void) {
        var component = [String: Any]()
        
        REF_POSTS.child(post.postID).observe(.value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            component["caption"] = dictionary["caption"]
            component["timestamp"] = dictionary["timestamp"]
            component["uid"] = dictionary["uid"]
            component["images"] = dictionary["images"]

            completion(component)
        }
    }
    
    func amendUploadPost(viewController: HomeViewController, caption: String, post: Post, completion: @escaping(Error?, DatabaseReference) -> Void) {
        let values = ["caption": caption,
                      "images": post.images,
                      "uid": post.user.uid,
                      "timestamp": post.timestamp.timeIntervalSince1970] as [String: Any]
        
        REF_POSTS.child(post.postID).updateChildValues(values, withCompletionBlock: completion)
    }
    
    // 수정할 특정 포스트 가져오기
    func fetchPost(post: Post, completion: @escaping([String: Any]) -> Void) {
        let postID = post.postID
        
        REF_POSTS.child(postID).observe(.value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            completion(dictionary)
        }
    }
    
}
