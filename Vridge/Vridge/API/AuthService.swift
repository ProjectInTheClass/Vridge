//
//  AuthService.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/06.
//

import Foundation

import Firebase
import AuthenticationServices
import Lottie

struct AuthService {
    
    static let shared = AuthService()
    
    // Apple 새 유저 로그인
    func signInNewUser(viewController: UIViewController, indicator: AnimationView,
                       credential: AuthCredential, email: String, bulletin: Bool? = false) {
        indicator.isHidden = false
        indicator.play()
        Auth.auth().signIn(with: credential) { (result, error) in
            guard let uid = result?.user.uid else { return }
            
            let values = ["uid": uid,
                          "email": email,
                          "point": 0] as [String: Any]
            
            REF_USERS.child(uid).updateChildValues(values) { (err, ref) in
                REF_USER_POINT.updateChildValues([uid: 0]) { (err, ref) in
                    print("DEBUG: New user's email is \(email)")
                    
                    let selectTypeController = SelectTypeViewController()
                    
                    if bulletin == false {
                        viewController.title = ""
                        viewController.navigationController?.pushViewController(selectTypeController, animated: true)
                        print("DEBUG: New user logged in.")
                        indicator.stop()
                        indicator.isHidden = true
                        
                    } else {
                        
                        let navigation = UINavigationController(rootViewController: selectTypeController)
                        navigation.modalPresentationStyle = .fullScreen
                        viewController.present(navigation, animated: true, completion: nil)
                        indicator.stop()
                        indicator.isHidden = true
                    }
                    
                }
            }
        }
    }
    
    // Apple 유저 로그인
    func loginExistUser(viewController: UIViewController, animationView: AnimationView, credential: AuthCredential,
                        bulletin: Bool? = false, completion: @escaping(User) -> Void) {
        animationView.isHidden = false
        animationView.play()
        Auth.auth().signIn(with: credential) { (result, error) in
            guard let uid = result?.user.uid else { return }
            guard let email = result?.user.email else { return }
//            guard let username = result?.user.displayName
            REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
                
                guard (snapshot.value as? [String: AnyObject]) != nil else {
                    
                    // 탈퇴했던 유저 재가입 (하지만 우리 앱에 탈퇴 기능 빼버림...)
                    rejoinLeftUser(credential: credential, uid: uid, email: email, bulletin: bulletin) { (err, ref) in
                        
                        let selectTypeController = SelectTypeViewController()
                        
                        if bulletin == false {
                            
                            viewController.navigationController?.pushViewController(selectTypeController, animated: true)
                            print("DEBUG: New user logged in.")
//                            indicator.stopAnimating()
                            
                        } else {
                            
                            let navigation = UINavigationController(rootViewController: selectTypeController)
                            navigation.modalPresentationStyle = .fullScreen
                            viewController.present(navigation, animated: true, completion: nil)
//                            indicator.stopAnimating()
                        }
                        print("DEBUG: left user rejoined...")
                    }
                    return
                }
                print("DEBUG: Existed user logged in.")
                
                
//                let selectTypeController = SelectTypeViewController()
//                viewController.navigationController?.pushViewController(selectTypeController, animated: true)
//                print("DEBUG: Existed user logged in.")
                
                guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
                guard let tab = window.rootViewController as? MainTabBarController else { return }
                
                tab.fetchUser()
                NotificationCenter.default.post(name: Notification.Name("refetchUser"), object: nil)
                
                animationView.stop()
                animationView.isHidden = true
                
                viewController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // Apple 탈퇴했던 유저 재가입 (하지만 우리 앱에 탈퇴 기능 빼버림...)
    func rejoinLeftUser(credential: AuthCredential, uid: String, email: String, bulletin: Bool? = false,
                        completion: @escaping(Error?, DatabaseReference) -> Void) {
        // Deleted account and rejoining
        
        Auth.auth().signIn(with: credential) { (result, error) in
            REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
                let values = ["uid": uid,
                              "email": email,
                              "point": 0] as [String: Any]
                REF_USERS.child(uid).updateChildValues(values) { (err, ref) in
                    REF_USER_POINT.updateChildValues([uid: 0], withCompletionBlock: completion)
                    print("DEBUG: This user has deleted id, and successfully rejoined with point 0")
                }
            }
        }
    }
    
    // 유저네임 등록 EASY man. 테스트 필요 API
    func submitUsername(username: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USERNAMES.updateChildValues([":" + username: 1]) { (err, ref) in
            REF_USERS.child(uid).updateChildValues(["username": username], withCompletionBlock: completion)
        }
    }
    
    // 유저 프로필사진, 채식타입 등록 테스트 필요 API
    func submitNewUserProfile(indicator: UIActivityIndicatorView, type: String, photo: UIImage, username: String,
                           completion: @escaping(Error?, DatabaseReference) -> Void) {
        indicator.startAnimating()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard let imageData = photo.jpegData(compressionQuality: 0.3) else { return }
        let storageRef = STORAGE_USER_PROFILE_IMAGES.child(uid)
        
        storageRef.putData(imageData, metadata: nil) { (meta, err) in
            storageRef.downloadURL { (url, err) in
                guard let imageURL = url?.absoluteString else { return }
                
                REF_USERS.child(uid).updateChildValues(["profileImageURL": imageURL,
                                                        "type": type,
                                                        "username": username]) { (err, ref) in
                    DB_REF.child("\(type)-point").updateChildValues([uid: 0]) { (err, ref) in
                        REF_USERNAMES.updateChildValues([":" + username: 1], withCompletionBlock: completion)
                    }
                    indicator.stopAnimating()
                    
                    guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
                    guard let tab = window.rootViewController as? MainTabBarController else { return }
                    
                    tab.fetchUser()
                }
            }
        }
    }
    
    // 유저네임 중복확인. 테스트 필요 API
    func checkUserNameExistency(user: User? = nil, username: String, completion: @escaping(Bool) -> Void) {
        
        if let user = user {
            let currentUsername = user.username
            var safeUsername = username
            
            if username.contains(".") {
                safeUsername = username.replacingOccurrences(of: ".", with: "")
            } else if username.contains("#") {
                safeUsername = username.replacingOccurrences(of: "#", with: "")
            } else if username.contains("$") {
                safeUsername = username.replacingOccurrences(of: "$", with: "")
            } else if username.contains("[") {
                safeUsername = username.replacingOccurrences(of: "[", with: "")
            } else if username.contains("]") {
                safeUsername = username.replacingOccurrences(of: "]", with: "")
            } else if username.contains(" ") {
                safeUsername = username.replacingOccurrences(of: " ", with: "")
            } else if username == "" {
                completion(false)
            } else {
                
                REF_USERNAMES.child(":" + safeUsername).observeSingleEvent(of: .value) { snapshot in
                    
                    if snapshot.exists() {
                        if safeUsername == currentUsername {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    } else {
                        completion(true)
                    }
                }
            }
        } else {
            var safeUsername = username
            
            if username.contains(".") {
                safeUsername = username.replacingOccurrences(of: ".", with: "")
            } else if username.contains("#") {
                safeUsername = username.replacingOccurrences(of: "#", with: "")
            } else if username.contains("$") {
                safeUsername = username.replacingOccurrences(of: "$", with: "")
            } else if username.contains("[") {
                safeUsername = username.replacingOccurrences(of: "[", with: "")
            } else if username.contains("]") {
                safeUsername = username.replacingOccurrences(of: "]", with: "")
            } else if username.contains(" ") {
                safeUsername = username.replacingOccurrences(of: " ", with: "")
            } else if username == "" {
                completion(false)
            } else {
                
                REF_USERNAMES.child(":" + safeUsername).observeSingleEvent(of: .value) { snapshot in
                    
                    if snapshot.exists() {
                        completion(false)
                    } else {
                        completion(true)
                    }
                }
            }
        }
        
        
    }
    
    // 프로필 사진 올리기 테스트 필요 API
    func uploadProfilePhoto(profilePhoto: UIImage, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let imageData = profilePhoto.jpegData(compressionQuality: 0.3) else { return }
        
        let filename = uid + "profilePhoto"
        let storageRef = STORAGE_USER_PROFILE_IMAGES.child(filename)
        
        storageRef.putData(imageData, metadata: nil) { (meta, err) in
            storageRef.downloadURL { (url, err) in
                guard let imageURL = url?.absoluteString else { return }
                
                REF_USERS.child(uid).updateChildValues(["profileImageURL": imageURL], withCompletionBlock: completion)
            }
        }
    }
    
//     채식타입 정하기 //
    func userDidSetType(type: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USERS.child(uid).updateChildValues(["type": type]) { (err, ref) in
            DB_REF.child("\(type)-point").updateChildValues([uid: 0], withCompletionBlock: completion)
        }
    }
    
    func userDeleteAccount() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_POSTS.child(uid).observe(.value) { snapshot in
            guard let dic = snapshot.value as? [String: Any] else { return }
            
            for key in dic.keys {
                REF_POSTS.child(key).removeValue { (err, ref) in
                    REF_USER_POSTS.child(uid).removeValue()
                }
            }
            // log out method 넣어주기.
        }
//        REF_USER_POSTS.child(uid).removeValue()
    }
    
    func logOut(viewController: UIViewController) {
        do {
            try Auth.auth().signOut()
            viewController.dismiss(animated: true) {
                let nav = UINavigationController(rootViewController: IntroViewController())
                nav.modalPresentationStyle = .fullScreen
                viewController.present(nav, animated: true) {
                    guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
                    guard let tab = window.rootViewController as? MainTabBarController else { return }
                    
                    tab.user = nil
                }
            }
        } catch (let err) {
            print("DEBUG: FAILED LOG OUT with error \(err.localizedDescription)")
        }
    }
    
    func checkIfUserHasUsername(completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USERS.child(uid).child("username").observeSingleEvent(of: .value) { snapshot in
            if snapshot.exists() {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    
    // email login APIs
    
    func joinNewUser(email: String, password: String, errorLabel: UILabel, emailUnderline: UIView, animation: AnimationView, completion: @escaping(Error?, DatabaseReference) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                animation.stop()
                animation.isHidden = true
                
                print("DEBUG: error is \(error.localizedDescription)")
                if error.localizedDescription.contains("another account.") {
                    print("DEBUG: error msg = \(error.localizedDescription)")
                    errorLabel.isHidden = false
                    emailUnderline.isHidden = false
                    emailUnderline.backgroundColor = .red
                } else {
                    errorLabel.text = "메일 주소를 다시 한번 확인해 주세요."
                    errorLabel.isHidden = false
                    emailUnderline.isHidden = false
                    emailUnderline.backgroundColor = .red
                }
            } else {
                guard let uid = result?.user.uid else { return }
                
                let values = ["uid": uid,
                              "email": email,
                              "point": 0] as [String: Any]
                
                REF_USERS.child(uid).updateChildValues(values) { (error, ref) in
                    REF_USER_POINT.updateChildValues([uid: 0], withCompletionBlock: completion)
                }
            }
        }
    }
    
    func loginWithEmail(email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
}
