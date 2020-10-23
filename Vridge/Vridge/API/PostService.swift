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
                    view: PostingViewController, completion: @escaping(Error?, DatabaseReference) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        indicator.startAnimating()
        var urlString: [String] = []
        
        guard let imageData1 = photos[0]?.jpegData(compressionQuality: 0.3) else { return }
        switch photos.count {
        case 1:
            
            let filename = NSUUID().uuidString
            let storageRef = STORAGE_POST_IMAGES.child(filename)
            
            storageRef.putData(imageData1, metadata: nil) { (meta, err) in
                storageRef.downloadURL { (url, err) in
                    guard let imageURL = url?.absoluteString else { return }
                    urlString.append(imageURL)
                    
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
                        view.dismiss(animated: true) {
                            view.delegate?.updateUser()
                        }
                    }
                }
            }
            
        case 2:
            guard let imageData2 = photos[1]?.jpegData(compressionQuality: 0.25) else { return }
            
            let filename = NSUUID().uuidString
            let storageRef = STORAGE_POST_IMAGES.child(filename)
            let filename2 = NSUUID().uuidString
            let storageRef2 = STORAGE_POST_IMAGES.child(filename2)
            
            storageRef.putData(imageData1, metadata: nil) { (meta, err) in
                storageRef.downloadURL { (url, err) in
                    guard let imageURL1 = url?.absoluteString else { return }
                    urlString.append(imageURL1)
                    storageRef2.putData(imageData2, metadata: nil) { (meta, err) in
                        storageRef2.downloadURL { (url, err) in
                            guard let imageURL2 = url?.absoluteString else { return }
                            urlString.append(imageURL2)
                            
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
        default:
            guard let imageData2 = photos[1]?.jpegData(compressionQuality: 0.25) else { return }
            guard let imageData3 = photos[2]?.jpegData(compressionQuality: 0.25) else { return }
            
            let filename = NSUUID().uuidString
            let storageRef = STORAGE_POST_IMAGES.child(filename)
            let filename2 = NSUUID().uuidString
            let storageRef2 = STORAGE_POST_IMAGES.child(filename2)
            let filename3 = NSUUID().uuidString
            let storageRef3 = STORAGE_POST_IMAGES.child(filename3)
            
            storageRef.putData(imageData1, metadata: nil) { (meta, err) in
                storageRef.downloadURL { (url, err) in
                    guard let imageURL1 = url?.absoluteString else { return }
                    urlString.append(imageURL1)
                    storageRef2.putData(imageData2, metadata: nil) { (meta, err) in
                        storageRef2.downloadURL { (url, err) in
                            guard let imageURL2 = url?.absoluteString else { return }
                            urlString.append(imageURL2)
                            storageRef3.putData(imageData3, metadata: nil) { (meta, err) in
                                storageRef3.downloadURL { (url, err) in
                                    guard let imageURL3 = url?.absoluteString else { return }
                                    urlString.append(imageURL3)
                                    
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
            }
            
            
        }
        
        /*
                for photo in photos {
                    guard let imageData = photo?.jpegData(compressionQuality: 0.25) else { return }
                    let filename = NSUUID().uuidString
                    let storageRef = STORAGE_POST_IMAGES.child(filename)
        
                    storageRef.putData(imageData, metadata: nil) { (meta, err) in
                        storageRef.downloadURL { (url, err) in
         
                            // GUESS: downloadURL에서 사진 용량이 달라서 다운로드 시간이 다르게 되어
                            // 사진 순서 역전 현상이 나타나는 듯함. 시바아아아아아알!!!!!!!!
                            guard let imageURL = url?.absoluteString else { return }
                            urlString.append(imageURL)

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
        
                                    DispatchQueue.main.async {
                                        indicator.stopAnimating()
                                    }
                                    view.dismiss(animated: true, completion: nil)
                                }
        
                            }
                        }
                    }
                }
        */
         
    }
    
    func numberOfPosts(completion: @escaping(Int) -> Void) {
        
        REF_POSTS.observeSingleEvent(of: .value) { snapshot in
            completion(Int(snapshot.childrenCount))
        }
    }
    
    
    // 모든 게시글 다 보기
    func fetchPosts(completion: @escaping([Post]) -> Void) {
        var post = [Post]()
        
        REF_POSTS.queryLimited(toLast: UInt(POST_LOAD_AT_ONCE)).observe(.childAdded) { snapshot in
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
    
    
    func pointUp(completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_POINT.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let currentPoint = snapshot.value as? Int else { return }
            print("DEBUG: snapshot value is \(currentPoint), about to plus one")
            
            REF_USER_POINT.updateChildValues([uid: currentPoint + 1]) { (err, ref) in
                REF_USERS.child(uid).updateChildValues(["point": currentPoint + 1], withCompletionBlock: completion)
            }
        }
    }
    
    func pointDown(completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_POINT.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let currentPoint = snapshot.value as? Int else { return }
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
                // 여기에서 Storage에 저장되어있는 이미지도 삭제해주어야 함.
                // STORAGE_POST_IMAGES
                // 근데 파일 네임 어떻게 찾음?
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
