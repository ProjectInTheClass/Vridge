//
//  BulletinBoard.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/11/11.
//

import UIKit

import BLTNBoard

struct BulletinBoard {
    
    lazy var boardManager: BLTNItemManager = {
        
        let item = BLTNPageItem(title: "브릿지 가입하기")
        item.image = UIImage(systemName: "person.fill")
        item.actionButtonTitle = "this is login button"
        item.alternativeButtonTitle = "later"
        item.descriptionText = "가입하세요\n가입"
        
        item.appearance.actionButtonColor = .black
        
        item.presentationHandler = { _ in
            print("DEBUG: present")
        }
        
        item.actionHandler = { _ in
            print("DEBUG: login tapped")
        }
        
        item.alternativeHandler = { _ in
            print("DEBUG: later button tapped")
        }
        
        return BLTNItemManager(rootItem: item)
    }()
    
    mutating func showBulletinBoard(viewController: UIViewController) {
        boardManager.showBulletin(above: viewController)
    }
}
