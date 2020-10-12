//
//  RankingViewModel.swift
//  Vridge_Pages
//
//  Created by Kang Mingu on 2020/10/09.
//

import UIKit

enum RankingFilterOptions: Int, CaseIterable {
    case all
    case myType
    
    var description: String {
        switch self {
        case .all: return "전체"
        case .myType: return "내 타입"
        }
    }
}

struct RankingViewModel {
    
    let profileImage2: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(width: 80, height: 80)
        iv.layer.cornerRadius = 80 / 2
        iv.layer.borderWidth = 4
        iv.layer.borderColor = UIColor.white.cgColor
        iv.backgroundColor = .vridgePlaceholderColor
        
        iv.layer.shadowColor = UIColor.black.cgColor
        iv.layer.shadowOffset = CGSize(width: 0, height: 0)
        iv.layer.shadowOpacity = 0.2
        iv.layer.shadowRadius = 10
        iv.layer.masksToBounds = false
        return iv
    }()
    
    let clover: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "clover")
        return iv
    }()
    
    lazy var profileImage1View: UIView = {
        let view = UIView()
        view.addSubview(profileImage1)
        view.addSubview(clover)
        clover.anchor(bottom: view.bottomAnchor, right: view.rightAnchor,
                      paddingBottom: -10, paddingRight: 10)
        profileImage1.center(inView: view)
        view.setDimensions(width: 105, height: 105)
        view.layer.cornerRadius = 105 / 2
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.vridgeGreen.cgColor
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 10
        view.layer.masksToBounds = false
        return view
    }()
    
    let profileImage1: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(width: 101, height: 101)
        iv.layer.cornerRadius = 101 / 2
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        iv.backgroundColor = .vridgePlaceholderColor
        return iv
    }()
    
    let profileImage3: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(width: 80, height: 80)
        iv.layer.cornerRadius = 80 / 2
        iv.layer.borderWidth = 4
        iv.layer.borderColor = UIColor.white.cgColor
        iv.backgroundColor = .vridgePlaceholderColor
        
        iv.layer.shadowColor = UIColor.black.cgColor
        iv.layer.shadowOffset = CGSize(width: 0, height: 0)
        iv.layer.shadowOpacity = 0.2
        iv.layer.shadowRadius = 10
        iv.layer.masksToBounds = false
        return iv
    }()
    
    let username2: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFSemiBold(size: 16)
        label.text = "pinguo"
        return label
    }()
    
    let username1: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFSemiBold(size: 16)
        label.text = "시드니"
        return label
    }()
    
    let username3: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFSemiBold(size: 16)
        label.text = "열쇠고리"
        return label
    }()
    
    let type2: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFRegular(size: 14)
        label.textColor = .vridgeGray
        label.text = "@flexitarian"
        return label
    }()
    
    let type1: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFRegular(size: 14)
        label.textColor = .vridgeGray
        label.text = "@pollo"
        return label
    }()
    
    let type3: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFRegular(size: 14)
        label.textColor = .vridgeGray
        label.text = "@lacto-ovo"
        return label
    }()
    
    let point2: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFHeavy(size: 16)
        label.text = "62"
        label.textColor = .vridgeBlack
        return label
    }()
    
    let point1: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFHeavy(size: 16)
        label.text = "209"
        label.textColor = .vridgeBlack
        return label
    }()
    
    let point3: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFHeavy(size: 16)
        label.text = "102"
        label.textColor = .vridgeBlack
        return label
    }()
    
    let pointImage2: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "salad")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let pointImage1: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "salad")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let pointImage3: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "salad")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
}
