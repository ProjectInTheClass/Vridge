//
//  PostService.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/05.
//

import UIKit

import Firebase
import Lottie

struct PostService {
    
    static let shared = PostService()
    
    //    func uploadPost(caption: String?, photos: [UIImage?], indicator: AnimationView,
    //                    view: PostingViewController, completion: @escaping(Error?, DatabaseReference) -> Void) {
    //
    //        guard let uid = Auth.auth().currentUser?.uid else { return }
    //
    //        indicator.play()
    //        var urlString: [String] = []
    //
    //        guard let imageData1 = photos[0]?.jpegData(compressionQuality: 0.3) else { return }
    //        switch photos.count {
    //        case 1:
    //
    //            let filename = NSUUID().uuidString
    //            let storageRef = STORAGE_POST_IMAGES.child(filename)
    //
    //            storageRef.putData(imageData1, metadata: nil) { (meta, err) in
    //                storageRef.downloadURL { (url, err) in
    //                    guard let imageURL = url?.absoluteString else { return }
    //                    urlString.append(imageURL)
    //
    //                    guard let caption = caption else { return }
    //
    //                    let values = ["caption": caption,
    //                                  "images": urlString,
    //                                  "uid": uid,
    //                                  "timestamp": Int(NSDate().timeIntervalSince1970)] as [String: Any]
    //
    //                    REF_POSTS.childByAutoId().updateChildValues(values) { (err, ref) in
    //                        guard let postID = ref.key else { return }
    //
    //                        pointUp { (error, ref) in
    //                            REF_USER_POSTS.child(uid).updateChildValues([postID: 1], withCompletionBlock: completion)
    //                        }
    //
    //                        print("DEBUG: photo uploaded successfully to Storage/post_images.")
    //
    //                        DispatchQueue.main.async {
    //                            indicator.stop()
    //                            indicator.isHidden = true
    //                        }
    //                        view.dismiss(animated: true) {
    //                            view.delegate?.fetchUserAgain()
    //                        }
    //                    }
    //                }
    //            }
    //
    //        case 2:
    //            guard let imageData2 = photos[1]?.jpegData(compressionQuality: 0.25) else { return }
    //
    //            let filename = NSUUID().uuidString
    //            let storageRef = STORAGE_POST_IMAGES.child(filename)
    //            let filename2 = NSUUID().uuidString
    //            let storageRef2 = STORAGE_POST_IMAGES.child(filename2)
    //
    //            storageRef.putData(imageData1, metadata: nil) { (meta, err) in
    //                storageRef.downloadURL { (url, err) in
    //                    guard let imageURL1 = url?.absoluteString else { return }
    //                    urlString.append(imageURL1)
    //                    storageRef2.putData(imageData2, metadata: nil) { (meta, err) in
    //                        storageRef2.downloadURL { (url, err) in
    //                            guard let imageURL2 = url?.absoluteString else { return }
    //                            urlString.append(imageURL2)
    //
    //                            guard let caption = caption else { return }
    //
    //                            let values = ["caption": caption,
    //                                          "images": urlString,
    //                                          "uid": uid,
    //                                          "timestamp": Int(NSDate().timeIntervalSince1970)] as [String: Any]
    //
    //                            REF_POSTS.childByAutoId().updateChildValues(values) { (err, ref) in
    //                                guard let postID = ref.key else { return }
    //
    //                                pointUp { (error, ref) in
    //                                    REF_USER_POSTS.child(uid).updateChildValues([postID: 1], withCompletionBlock: completion)
    //                                }
    //
    //                                print("DEBUG: photo uploaded successfully to Storage/post_images.")
    //                                DispatchQueue.main.async {
    //                                    indicator.stop()
    //                                    indicator.isHidden = true
    //                                }
    //                                view.dismiss(animated: true, completion: nil)
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //        default:
    //            guard let imageData2 = photos[1]?.jpegData(compressionQuality: 0.25) else { return }
    //            guard let imageData3 = photos[2]?.jpegData(compressionQuality: 0.25) else { return }
    //
    //            let filename = NSUUID().uuidString
    //            let storageRef = STORAGE_POST_IMAGES.child(filename)
    //            let filename2 = NSUUID().uuidString
    //            let storageRef2 = STORAGE_POST_IMAGES.child(filename2)
    //            let filename3 = NSUUID().uuidString
    //            let storageRef3 = STORAGE_POST_IMAGES.child(filename3)
    //
    //            storageRef.putData(imageData1, metadata: nil) { (meta, err) in
    //                storageRef.downloadURL { (url, err) in
    //                    guard let imageURL1 = url?.absoluteString else { return }
    //                    urlString.append(imageURL1)
    //                    storageRef2.putData(imageData2, metadata: nil) { (meta, err) in
    //                        storageRef2.downloadURL { (url, err) in
    //                            guard let imageURL2 = url?.absoluteString else { return }
    //                            urlString.append(imageURL2)
    //                            storageRef3.putData(imageData3, metadata: nil) { (meta, err) in
    //                                storageRef3.downloadURL { (url, err) in
    //                                    guard let imageURL3 = url?.absoluteString else { return }
    //                                    urlString.append(imageURL3)
    //
    //                                    guard let caption = caption else { return }
    //
    //                                    let values = ["caption": caption,
    //                                                  "images": urlString,
    //                                                  "uid": uid,
    //                                                  "timestamp": Int(NSDate().timeIntervalSince1970)] as [String: Any]
    //
    //                                    REF_POSTS.childByAutoId().updateChildValues(values) { (err, ref) in
    //                                        guard let postID = ref.key else { return }
    //
    //                                        pointUp { (error, ref) in
    //                                            REF_USER_POSTS.child(uid).updateChildValues([postID: 1], withCompletionBlock: completion)
    //                                        }
    //
    //                                        print("DEBUG: photo uploaded successfully to Storage/post_images.")
    //                                        DispatchQueue.main.async {
    //                                            indicator.stop()
    //                                            indicator.isHidden = true
    //                                        }
    //                                        view.dismiss(animated: true, completion: nil)
    //                                    }
    //                                }
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    func uploadPost(caption: String?, photos: [UIImage?], indicator: AnimationView,
                    view: PostingViewController, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        indicator.play()
        var urlString = [String]()
        let postID = NSUUID().uuidString
        
        for (index, photo) in photos.enumerated() {
            guard let imageData = photo?.jpegData(compressionQuality: 0.25) else { return }
            let filename = String(index) + postID
            let storageRef = STORAGE_POST_IMAGES.child(filename)
            
            storageRef.putData(imageData, metadata: nil) { (meta, err) in
                storageRef.downloadURL { (url, err) in
                    guard let imageURL = url?.absoluteString else { return }
                    urlString.append(imageURL)
                    
                    if photos.count == urlString.count {
                        guard let caption = caption else { return }
                        
                        let values = ["caption": caption,
                                      "images": urlString.sorted(by: { $0 < $1 }),
                                      "uid": uid,
                                      "timestamp": Int(NSDate().timeIntervalSince1970)] as [String: Any]
                        
                        REF_POSTS.child(postID).updateChildValues(values) { (err, ref) in
                            pointUp { (err, ref) in
                                UserService.shared.fetchUser(uid: uid) { user in
                                    DB_REF.child("\(user.vegieType!.rawValue)-posts").child(postID).updateChildValues(values) { (err, ref) in
                                        REF_USER_POSTS.child(uid).updateChildValues([postID: 1], withCompletionBlock: completion)
                                        
                                        indicator.stop()
                                        view.dismiss(animated: true, completion: nil)
                                    }
                                }
                                
                                
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    func numberOfPosts(completion: @escaping(Int) -> Void) {
        
        REF_POSTS.observeSingleEvent(of: .value) { snapshot in
            completion(Int(snapshot.childrenCount))
        }
    }
    
    
    // 모든 게시글 다 보기
    func fetchPosts(completion: @escaping([Post]) -> Void) {
        var posts = [Post]()
        
        REF_POSTS.queryLimited(toLast: UInt(POST_LOAD_AT_ONCE)).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let postID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                
                let post = Post(user: user, postID: postID, dictionary: dictionary)
                posts.append(post)
                completion(posts)
            }
        }
    }
    
    func refetchPost(post: [Post], from: Int, upto: Int, completion: @escaping([Post]) -> Void) {
        var post = [Post]()
        
        REF_POSTS.queryLimited(toLast: UInt(upto)).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let postID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                
                let posts = Post(user: user, postID: postID, dictionary: dictionary)
                post.append(posts)
                
                if post.count == upto {
                    completion(post)
                }
            }
        }
    }
    
    func fetchMyPosts(completion: @escaping([Post]) -> Void) {
        var posts = [Post]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_POSTS.child(uid).observe(.childAdded) { snapshot in
            let postID = snapshot.key
            
            REF_POSTS.child(postID).observeSingleEvent(of: .value) { snapshot in
                self.fetchPosts(withPostID: postID) { post in
                    posts.append(post)
                    completion(posts)
                }
            }
        }
    }
    
    func fetchPosts(withPostID postID: String, completion: @escaping(Post) -> Void) {
        REF_POSTS.child(postID).observeSingleEvent(of: .value) { snapshot in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let post = Post(user: user, postID: postID, dictionary: dictionary)
                completion(post)
            }
        }
    }
    
    
    func pointUp(completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        UserService.shared.fetchUser(uid: uid) { user in
            let user = user
            
            REF_USER_POINT.child(uid).observeSingleEvent(of: .value) { snapshot in
                guard let currentPoint = snapshot.value as? Int else { return }
                print("DEBUG: snapshot value is \(currentPoint), about to plus one")
                // 가장 먼저 user-point 에서 +1
                REF_USER_POINT.updateChildValues([uid: currentPoint + 1]) { (err, ref) in
                    // 그 다음 users 에서 +1
                    REF_USERS.child(uid).updateChildValues(["point": currentPoint + 1]) { (err, ref) in
                        // 마지막으로 type-point 에서 +1 해주기.
                        DB_REF.child("\(user.vegieType!.rawValue)-point").updateChildValues([uid: currentPoint + 1], withCompletionBlock: completion)
                    }
                }
            }
        }
        
        
    }
    
    func pointDown(completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        UserService.shared.fetchUser(uid: uid) { user in
            let user = user
            
            REF_USER_POINT.child(uid).observeSingleEvent(of: .value) { snapshot in
                guard let currentPoint = snapshot.value as? Int else { return }
                print("DEBUG: snapshot value is \(currentPoint), about to minus one")
                
                // 가장 먼저 user-point 에서 -1
                REF_USER_POINT.updateChildValues([uid: currentPoint - 1]) { (err, ref) in
                    // 그 다음 users 에서 -1
                    REF_USERS.child(uid).updateChildValues(["point": currentPoint - 1]) { (err, ref) in
                        // 마지막으로 type-point 에서 -1 해주기.
                        DB_REF.child("\(user.vegieType!.rawValue)-point").updateChildValues([uid: currentPoint - 1], withCompletionBlock: completion)
                    }
                }
            }
        }
    }
    
    // 내 타입 게시글만 보기
    func fetchPosts(type: String) {
        // type을 enum으로 만들어 놓기.
    }
    
    
    func deletePost(row: Int, viewController: HomeViewController, postId: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            
            REF_POSTS.child(postId).removeValue { (err, ref) in
                REF_USER_POSTS.child(uid).child(postId).removeValue { (err, ref) in
                    
                    for i in 0...2 {
                        STORAGE_POST_IMAGES.child("\(i)" + postId).delete { err in
                        }
                    }
                    
                    UserService.shared.fetchUser(uid: uid) { user in
                        DB_REF.child("\(user.vegieType!.rawValue)-posts").child(postId).removeValue { (err, ref) in
                            pointDown(completion: completion)
                            print("DEBUG: SUCCESSFULLY DELETE POST")
                            viewController.posts.remove(at: row)
                        }
                    }
                }
            }
        }
        
    }
    
    func deletePostFromMyPost(post: Post, completion: @escaping(Error?, DatabaseReference) -> Void) {
        REF_POSTS.child(post.postID).removeValue { (err, ref) in
            REF_USER_POSTS.child(post.user.uid).child(post.postID).removeValue { (err, ref) in
                
                for i in 0...2 {
                    STORAGE_POST_IMAGES.child("\(i)" + post.postID).delete { err in
                    }
                }
                
                DB_REF.child("\(post.user.vegieType!.rawValue)-posts").child(post.postID)
                    .removeValue(completionBlock: completion)
            }
        }
    }
    
    func amendPost(post: Post, completion: @escaping([String: Any]) -> Void) {
        var component = [String: Any]()
        
        UserService.shared.fetchUser(uid: post.user.uid) { user in
            REF_POSTS.child(post.postID).observe(.value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                component["caption"] = dictionary["caption"]
                component["timestamp"] = dictionary["timestamp"]
                component["uid"] = dictionary["uid"]
                component["images"] = dictionary["images"]
                
                completion(component)
            }
        }
    }
    
    func amendUploadPost(viewController: HomeViewController, caption: String, post: Post, completion: @escaping(Error?, DatabaseReference) -> Void) {
        let values = ["caption": caption,
                      "images": post.images,
                      "uid": post.user.uid,
                      "timestamp": post.timestamp.timeIntervalSince1970] as [String: Any]
        UserService.shared.fetchUser(uid: post.user.uid) { user in
            REF_POSTS.child(post.postID).updateChildValues(values) { (err, ref) in
                DB_REF.child("\(user.vegieType!.rawValue)-posts").child(post.postID).updateChildValues(values, withCompletionBlock: completion)
            }
        }
        
        
    }
    
    // 수정할 특정 포스트 가져오기
    func fetchPost(post: Post, completion: @escaping([String: Any]) -> Void) {
        let postID = post.postID
        
        REF_POSTS.child(postID).observe(.value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            completion(dictionary)
        }
    }
    
    func reportPost(post: Post, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_REPORT.child(uid).updateChildValues([post.postID: 1]) { (err, ref) in
            REF_POST_REPORT.child(post.postID).updateChildValues([uid: 1], withCompletionBlock: completion)
        }
    }
    
    func checkIfUserReportedPost(_ post: Post, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_REPORT.child(uid).child(post.postID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
}
