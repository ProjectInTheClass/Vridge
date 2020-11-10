//
//  testHeader.swift
//  MyPageView
//
//  Created by Kang Mingu on 2020/10/26.
//

import UIKit

protocol MyPageTopHeaderViewDelegate: class {
    func seeMyPostButtonTapped()
}

class MyPageTopHeaderView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: MyPageTopHeaderViewDelegate?
    
    var user: User? {
        didSet { print("DEBUG: user set === name is \(user?.username)") }
    }
    
    let typeColorView: UIView = {
        let view = UIView()
        view.backgroundColor = .vridgeGreen // 여기에 채식 타입 별 색상 코드 입력해야 함
        return view
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
//        label.text = "배주현" // 유저 네임 받아와야 함
        label.font = UIFont.SFBold(size: 25)
        label.textColor = .white
        return label
    }()
    
    let typeLabel: UILabel = {
        let label = UILabel()
//        label.text = "@vegan | 채소, 과일" // 유저 채식 타입 받아와야 함
        label.font = UIFont.SFSemiBold(size: 16)
        label.textColor = .white
        return label
    }()
    
    let profileBg: UIView = {
        let view = UIView()
        view.setDimensions(width: 48, height: 48)
        view.layer.cornerRadius = 48 / 2
        view.backgroundColor = .white
        return view
    }()
    
    let profileImage : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .blue
        iv.image = UIImage(named: "imgDefaultProfile")
        iv.layer.cornerRadius = 44 / 2 // 가장자리를 둥글게 원으로 하려면 heightAnchor 값의 절반으로 하면 됨
        iv.clipsToBounds = true // 프로필 이미지가 이미지뷰 백그라운드 안에 들어가게 해주려면
        return iv
    }()
    
    let whiteRect: UIView = {
        let view = UIView()
        view.setDimensions(width: 343, height: 126)
        view.layer.cornerRadius = 18
        view.backgroundColor = UIColor(named: "color_mypage_myPostCountBoxBg")
        
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 18
        return view
    }()
    
    let myPostTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "나의 채식 참여 횟수"
        label.font = UIFont.SFBold(size: 16)
        return label
    }()
    
    let myPostCountLabel: UILabel = {
        let label = UILabel()
        label.text = "23" // 여기에 채식 몇 끼 했는지 입력해야 함
        label.font = UIFont.SFBold(size: 50)
        return label
    }()
    
    let myPostCountUnitLabel: UILabel = {
        let label = UILabel()
        label.text = "끼 째"
        label.font = UIFont.SFBold(size: 28)
        return label
    }()
    
    let seeMyPostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "btnSeeMyposts"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 64 / 2
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowOpacity = 0.20
        button.layer.shadowRadius = 12
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(frame: CGRect, user: User?) {
        self.user = user
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func handleButtonTapped() {
        delegate?.seeMyPostButtonTapped()
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        backgroundColor = UIColor(named: "color_all_viewBackground")
        
        addSubview(typeColorView)
        addSubview(usernameLabel)
        addSubview(typeLabel)
        addSubview(profileBg)
        addSubview(profileImage)
        addSubview(whiteRect)
        addSubview(myPostTitleLabel)
        addSubview(myPostCountLabel)
        addSubview(myPostCountUnitLabel)
        addSubview(seeMyPostButton)
        backgroundColor = .white
        
        typeColorView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 152)
        usernameLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 18, paddingLeft: 16)
        typeLabel.anchor(top: usernameLabel.bottomAnchor, left: leftAnchor, paddingLeft: 18)
        
        profileBg.anchor(top: topAnchor, right: rightAnchor, paddingTop: 11, paddingRight: 16)
        profileImage.anchor(top: topAnchor, right: rightAnchor, paddingTop: 13, paddingRight: 18, width: 44, height: 44)
        
        whiteRect.anchor(top: typeLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,  paddingTop: 27, paddingLeft: 16, paddingRight: 16)
        
        myPostTitleLabel.anchor(top: whiteRect.topAnchor, left: whiteRect.leftAnchor, paddingTop: 18, paddingLeft: 20)
        myPostCountLabel.anchor(top: myPostTitleLabel.bottomAnchor, left: whiteRect.leftAnchor, paddingTop: 4, paddingLeft: 20)
        myPostCountUnitLabel.anchor(top: myPostTitleLabel.bottomAnchor, left: myPostCountLabel.rightAnchor,
                                    paddingTop: 23, paddingLeft: 5)
        seeMyPostButton.anchor(top: whiteRect.topAnchor, right: whiteRect.rightAnchor,
                               paddingTop: 32, paddingRight: 28, width: 64, height: 64)
        
//        usernameLabel.text = user?.username ?? "로그인이 필요해요"
        typeColorView.backgroundColor = user?.vegieType?.typeColor ?? .vridgeGreen
        typeLabel.text = user?.vegieType?.typeDescription ?? "채식타입 | 채식"
        if let profileImageURL = user?.profileImageURL {
            profileImage.kf.setImage(with: profileImageURL)
        }
        myPostCountLabel.text = String(user?.point ?? 0)
        
    }

}
