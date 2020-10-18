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
    
    func fetchRanking(completion: @escaping(([User]) -> Void)) {
        var users = [User]()

        REF_USER_POINT.observe(.childAdded) { snapshot in
            let uid = snapshot.key

            self.fetchUser(uid: uid) { user in
                users.append(user)
                completion(users)
            }
        }
    }
    
    func fetchTotalUser(completion: @escaping(Int) -> Void) {
        REF_USER_POINT.observeSingleEvent(of: .value) { snapshot in
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
}
