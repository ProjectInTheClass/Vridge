//
//  AuthService.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/06.
//

import Foundation

import Firebase
import AuthenticationServices

struct AuthService {
    
    static let shared = AuthService()
    
    func signInNewUser(viewController: UIViewController, credential: AuthCredential,
                       email: String, username: String) {
        Auth.auth().signIn(with: credential) { (result, error) in
            guard let uid = result?.user.uid else { return }
            
            let values = ["uid": uid,
                          "email": email,
                          "point": 0,
                          "username": username] as [String: Any]
            
            REF_USERS.child(uid).updateChildValues(values) { (err, ref) in
                print("DEBUG: New user's email is \(email)")
                print("DEBUG: New user logged in.")
                
                let selectTypeController = SelectTypeViewController()
                viewController.navigationController?.pushViewController(selectTypeController, animated: true)
                
            }
        }
    }
    
    func loginExistUser(viewController: UIViewController, credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (result, error) in
            guard let uid = result?.user.uid else { return }
            guard let email = result?.user.email else { return }
            REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    rejoinLeftUser(credential: credential, uid: uid, email: email)
                    return
                }
                guard let point = dictionary["point"] as? Int else { return }
                // 여기에 profileURL, 그리고 vegetarian type 추가 해야함.
                // guard let profileURL = dictionary["profileURL"] else { return }
                // guard let type = dictionary["type"] else { return }
                let values = ["uid": uid,
                              "email": email,
                              "point": point] as [String: Any]
                
                REF_USERS.child(uid).updateChildValues(values) { (err, ref) in
                    print("DEBUG: Existed user logged in.")
                    
                    REF_USER_POINT.updateChildValues([uid: 0]) { (err, ref) in
                        print("DEBUG: point updated")
                    }
                    
                    viewController.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func rejoinLeftUser(credential: AuthCredential, uid: String, email: String) {
        // Deleted account and rejoining
        
        Auth.auth().signIn(with: credential) { (result, error) in
            REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
                let values = ["uid": uid,
                              "email": email,
                              "point": 0] as [String: Any]
                REF_USERS.child(uid).updateChildValues(values) { (err, ref) in
                    print("DEBUG: This user has deleted id, and successfully rejoined")
                }
            }
        }
    }
    
    // 유저네임 등록 EASY man.
    func submitUsername(username: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USERNAMES.updateChildValues([username: 1]) { (err, ref) in
            REF_USERS.child(uid).updateChildValues(["username": username], withCompletionBlock: completion)
        }
    }
    
    // 유저 프로필사진, 채식타입 등록
    func submitUserProfile(type: VegieTypes, photo: UIImage,
                           completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let imageData = photo.jpegData(compressionQuality: 0.3) else { return }
        let storageRef = STORAGE_USER_PROFILE_IMAGES.child(uid)
        storageRef.putData(imageData, metadata: nil) { (meta, err) in
            storageRef.downloadURL { (url, err) in
                guard let imageURL = url?.absoluteString else { return }
                
                REF_USERS.child(uid).updateChildValues(["profileImageURL": imageURL,
                                                        "type": type.rawValue],
                                                       withCompletionBlock: completion)
            }
        }
    }
    
    // 유저네임 중복확인.
    func checkUserNameExistency(username: String, completion: @escaping(Bool) -> Void) {
        REF_USERNAMES.child(username).observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                print("DEBUG: user exist, you can't use this id")
                completion(false)
            } else {
                print("DEBUG: user not exist, you can use this id")
                completion(true)
            }
        }
    }
}
