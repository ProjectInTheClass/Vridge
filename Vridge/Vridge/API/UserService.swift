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
}
