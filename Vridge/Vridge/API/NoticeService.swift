//
//  NoticeService.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/11/10.
//

import UIKit

import Firebase

struct NoticeService {
    
    static let shared = NoticeService()
    
    func fetchNotices(completion: @escaping([Notice]) -> Void) {
        var notices = [Notice]()
        
        REF_NOTICE.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            
            let notice = Notice(dictionary: dictionary)
            notices.append(notice)
            completion(notices)
        }
    }
    
    func fetchCurrentVersion(completion: @escaping(String) -> Void) {
        REF_VERSION.child("currentVersion").observeSingleEvent(of: .value) { snapshot in
            guard let version = snapshot.value as? String else { return }
            completion(version)
        }
    }
}
