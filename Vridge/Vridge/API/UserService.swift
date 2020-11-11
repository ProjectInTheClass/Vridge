//
//  UserService.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/06.
//

import Foundation

import Firebase


struct UserService {
    
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dictionary: dictionary)

            completion(user)
        }
    }
    
    func fetchRanking(completion: @escaping([User]) -> Void) {
        var users = [User]()

        REF_USER_POINT.observe(.childAdded) { snapshot in
            let uid = snapshot.key

            self.fetchUser(uid: uid) { user in
                users.append(user)
                
                if users.count >= 100 {
                    completion(users[0...99].sorted(by: { $0.point > $1.point }))
                } else {
                    completion(users.sorted(by: { $0.point > $1.point }))
                }
            }
        }
    }
    
//    func fetchRanking(completion: @escaping([User]) -> Void) {
//        var users = [User]()
//
//        REF_USER_POINT.observe(.childAdded) { snapshot in
//            let uid = snapshot.key
//
//            self.fetchUser(uid: uid) { user in
//                users.append(user)
//                completion(users)
//            }
//        }
//    }
    
    func fetchMyTypeRanking(myType: VegieType, completion: @escaping([User]) -> Void) {
        var users = [User]()
        
        DB_REF.child("\(myType.rawValue)-point").observe(.childAdded) { snapshot in
            let uid = snapshot.key
            
            self.fetchUser(uid: uid) { user in
                users.append(user)
                
                if users.count >= 50 {
                    completion(users[0...49].sorted(by: { $0.point > $1.point }))
                } else {
                    completion(users.sorted(by: { $0.point > $1.point }))
                }
                
            }
        }
    }
    
    func fetchTotalUser(completion: @escaping(Int) -> Void) {
        REF_USER_POINT.observeSingleEvent(of: .value) { snapshot in
            completion(Int(snapshot.childrenCount))
        }
    }
    
    func fetchTotalMyTypeUser(myType: VegieType, completion: @escaping(Int) -> Void) {
        DB_REF.child("\(myType.rawValue)-point").observeSingleEvent(of: .value) { snapshot in
            completion(Int(snapshot.childrenCount))
        }
    }
    
    func fetchUserPoint(completion: @escaping(Int) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_POINT.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let point = snapshot.value as? Int else { return }
            completion(point)
        }
    }
    
    func fetchUserType(completion: @escaping(String) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dic = snapshot.value as? [String: Any] else { return }
            guard let type = dic["type"] as? String else { return }
            
            completion(type)
        }
    }
    
    
    // user change their type 테스트 필요 API
    func changeType(user: User, to type: VegieType, completion: @escaping(Error?, DatabaseReference) -> Void) {
        DB_REF.child("\(user.vegieType!.rawValue)-point").child(user.uid).removeValue { (err, ref) in
            REF_USERS.child(user.uid).updateChildValues(["type": type]) { (err, ref) in
                DB_REF.child("\(type.rawValue)-point").updateChildValues([user.uid: user.point], withCompletionBlock: completion)
            }
        }
    }
    
    func editProfile(user: User, vegieType: String, profileImage: UIImage, username: String,
                     completion: @escaping(Error?, DatabaseReference) -> Void) {
        DB_REF.child("\(user.vegieType!.rawValue)-point").child(user.uid).removeValue { (err, ref) in
            DB_REF.child("\(vegieType)-point").updateChildValues([user.uid: user.point]) { (err, ref) in
                guard let imageData = profileImage.jpegData(compressionQuality: 0.3) else { return }
                let storageRef = STORAGE_USER_PROFILE_IMAGES.child(user.uid)
                
                storageRef.putData(imageData, metadata: nil) { (meta, err) in
                    storageRef.downloadURL { (url, err) in
                        guard let imageURL = url?.absoluteString else { return }
                        
                        let values = ["profileImageURL": imageURL,
                                      "username": username,
                                      "type": vegieType]
                        
                        REF_USERS.child(user.uid).updateChildValues(values, withCompletionBlock: completion)
                    }
                }
            }
            
        }
        
    }
    
}
