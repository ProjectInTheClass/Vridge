//
//  RankingHeader.swift
//  Vridge_Pages
//
//  Created by Kang Mingu on 2020/10/09.
//

import UIKit

class RankingHeader: UIView {
    
    // MARK: - Properties
    
    var userRanking = [User]()
    
    lazy var profileImage2View: UIView = {
        let view = UIView()
        view.addSubview(profileImage2)
        profileImage2.center(inView: view)
        view.setDimensions(width: 80, height: 80)
        view.layer.cornerRadius = 80 / 2
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor.white.cgColor
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 10
        return view
    }()
    
    let profileImage2: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(width: 80, height: 80)
        iv.layer.cornerRadius = 80 / 2
        iv.layer.borderWidth = 4
        iv.layer.borderColor = UIColor.white.cgColor
        iv.backgroundColor = .vridgePlaceholderColor
        return iv
    }()
    
    let clover: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "clover")
        return iv
    }()
    
    lazy var profileImage1MidView: UIView = {
        let view = UIView()
        view.addSubview(profileImage1)
        profileImage1.center(inView: view)
        view.setDimensions(width: 105, height: 105)
        view.layer.cornerRadius = 105 / 2
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.vridgeGreen.cgColor
        return view
    }()
    
    lazy var profileImage1View: UIView = {
        let view = UIView()
        view.addSubview(profileImage1MidView)
        view.addSubview(clover)
        clover.anchor(bottom: view.bottomAnchor, right: view.rightAnchor,
                      paddingBottom: -10, paddingRight: 10)
        profileImage1MidView.center(inView: view)
        view.setDimensions(width: 105, height: 105)
        view.layer.cornerRadius = 105 / 2
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 10
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
    
    lazy var profileImage3View: UIView = {
        let view = UIView()
        view.addSubview(profileImage3)
        profileImage3.center(inView: view)
        view.setDimensions(width: 80, height: 80)
        view.layer.cornerRadius = 80 / 2
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor.white.cgColor
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 10
        return view
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
        return iv
    }()
    
    let username2: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFSemiBold(size: 16)
        label.text = " "
        label.textColor = UIColor(named: allTextColor)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let username1: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFSemiBold(size: 16)
        label.text = " "
        label.textColor = UIColor(named: allTextColor)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let username3: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFSemiBold(size: 16)
        label.text = " "
        label.textColor = UIColor(named: allTextColor)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let type2: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFRegular(size: 14)
        return label
    }()
    
    let type1: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFRegular(size: 14)
        return label
    }()
    
    let type3: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFRegular(size: 14)
        return label
    }()
    
    let point2: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFHeavy(size: 16)
        label.text = " "
        label.textColor = UIColor(named: allTextColor)
        return label
    }()
    
    let point1: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFHeavy(size: 16)
        label.text = " "
        label.textColor = UIColor(named: allTextColor)
        return label
    }()
    
    let point3: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFHeavy(size: 16)
        label.text = " "
        label.textColor = UIColor(named: allTextColor)
        return label
    }()
    
    let saladImage2: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let saladImage1: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let saladImage3: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
    // MARK: - Lifecycle
    
    init(user: [User]) {
        super.init(frame: .zero)
        self.userRanking = user
        
        configureUI()
        if userRanking.count >= 3 {
            configure()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    func configure() {
        
        backgroundColor = UIColor(named: "color_all_viewBackground")
        
        
        profileImage1.kf.setImage(with: userRanking[0].profileImageURL)
        profileImage2.kf.setImage(with: userRanking[1].profileImageURL)
        profileImage3.kf.setImage(with: userRanking[2].profileImageURL)
        
        username1.text = userRanking[0].username
        username2.text = userRanking[1].username
        username3.text = userRanking[2].username
        
        point1.text = String(userRanking[0].point)
        point2.text = String(userRanking[1].point)
        point3.text = String(userRanking[2].point)
        
        type1.text = "@\(userRanking[0].type!)"
        type2.text = "@\(userRanking[1].type!)"
        type3.text = "@\(userRanking[2].type!)"
        
        type1.textColor = userRanking[0].vegieType?.typeColor
        type2.textColor = userRanking[1].vegieType?.typeColor
        type3.textColor = userRanking[2].vegieType?.typeColor
        
        saladImage1.image = UIImage(named: "salad")
        saladImage2.image = UIImage(named: "salad")
        saladImage3.image = UIImage(named: "salad")
    }
    
    func configureUI() {
        
        let imageWithPoint2 = UIStackView(arrangedSubviews: [saladImage2, point2])
        imageWithPoint2.spacing = 0
        imageWithPoint2.alignment = .center
        
        let imageWithPoint1 = UIStackView(arrangedSubviews: [saladImage1, point1])
        imageWithPoint1.spacing = 0
        imageWithPoint1.alignment = .center
        
        let imageWithPoint3 = UIStackView(arrangedSubviews: [saladImage3, point3])
        imageWithPoint3.spacing = 0
        imageWithPoint3.alignment = .center
        
        let userStack2 = UIStackView(arrangedSubviews: [profileImage2View, username2,
                                                        type2, imageWithPoint2])
        userStack2.axis = .vertical
        userStack2.setCustomSpacing(14, after: profileImage2View)
        userStack2.setCustomSpacing(3, after: username2)
        userStack2.setCustomSpacing(0, after: type2)
        userStack2.alignment = .center
        
        let userStack1 = UIStackView(arrangedSubviews: [profileImage1View, username1,
                                                        type1, imageWithPoint1])
        userStack1.axis = .vertical
        userStack1.setCustomSpacing(14, after: profileImage1View)
        userStack1.setCustomSpacing(3, after: username1)
        userStack1.setCustomSpacing(0, after: type1)
        userStack1.alignment = .center
        
        let userStack3 = UIStackView(arrangedSubviews: [profileImage3View, username3,
                                                        type3, imageWithPoint3])
        userStack3.axis = .vertical
        userStack3.setCustomSpacing(14, after: profileImage3View)
        userStack3.setCustomSpacing(3, after: username3)
        userStack3.setCustomSpacing(0, after: type3)
        userStack3.alignment = .center
        
        let width = UIScreen.main.bounds.size.width
        
        let userView1 = UIView()
        userView1.backgroundColor = .clear
        userView1.addSubview(userStack1)
        userStack1.centerX(inView: userView1)
        userStack1.anchor(bottom: userView1.bottomAnchor, paddingBottom: 32)
        username1.widthAnchor.constraint(lessThanOrEqualToConstant: width / 3 - 8).isActive = true
        
        addSubview(userView1)
        userView1.centerX(inView: self)
        userView1.setDimensions(width: width / 3 - 8, height: 243)
        
        let userView2 = UIView()
        userView2.backgroundColor = .clear
        userView2.addSubview(userStack2)
        userStack2.centerX(inView: userView2)
        userStack2.anchor(bottom: userView2.bottomAnchor, paddingBottom: 32)
        username2.widthAnchor.constraint(lessThanOrEqualToConstant: width / 3 - 8).isActive = true
        
        addSubview(userView2)
        userView2.anchor(top: topAnchor, right: userView1.leftAnchor, paddingRight: 8, width: width / 3 - 8, height: 243)
        
        let userView3 = UIView()
        userView3.backgroundColor = .clear
        userView3.addSubview(userStack3)
        userStack3.centerX(inView: userView3)
        userStack3.anchor(bottom: userView3.bottomAnchor, paddingBottom: 32)
        username3.widthAnchor.constraint(lessThanOrEqualToConstant: width / 3 - 8).isActive = true
        
        addSubview(userView3)
        userView3.anchor(top: topAnchor, left: userView1.rightAnchor, paddingRight: 8, width: width / 3 - 8, height: 243)
        
//        let stack = UIStackView(arrangedSubviews: [userStack2, userStack1, userStack3])
//        stack.axis = .horizontal
//        stack.spacing = 30
//        stack.alignment = .bottom
//
//        addSubview(stack)
//
//        stack.centerX(inView: self, topAnchor: topAnchor, paddingTop: 30)
    }
    
}
