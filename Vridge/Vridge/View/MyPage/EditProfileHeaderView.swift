//
//  EditProfileHeaderView.swift
//  MyPageView
//
//  Created by 김루희 on 2020/11/01.
//

import UIKit

protocol EditProfileHeaderViewDelegate: class {
    func editProfileImgButtonDidTap()
}

class EditProfileHeaderView: UIView {

    // MARK: - Properties
    weak var delegate: EditProfileHeaderViewDelegate?
    
    
    let profileBackground : UIView = {
        let view = UIView()
        view.setDimensions(width: 101, height: 101)
        view.layer.cornerRadius = 101 / 2
        view.backgroundColor = .white
        
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.16
        view.layer.shadowRadius = 6
        return view
    }()
    
    lazy var profileImage : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "imgDefaultProfile")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 93, height: 93)
        iv.layer.cornerRadius = 93 / 2
        let tap = UITapGestureRecognizer(target: self, action: #selector(editProfileImgButtonDidTap))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    lazy var editProfileImageButton : UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(named: "btnEditImg"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(editProfileImgButtonDidTap), for: .touchUpInside)
        button.layer.cornerRadius = 32 / 2
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.16
        button.layer.shadowRadius = 6
        return button
    }()
    
    let nickNameTextView = NicknameTextView()
    
    let nickNameLineView : UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named: "color_editprofile_line")
        return view
    }()
    
    let aboutNickNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.SFMedium(size: 11)
        label.textColor = UIColor(named: "color_editprofile_condition_text")
        label.text = "최대 6글자의 한글, 영어, 숫자, 특수문자 가능"
        return label
    }()
    
    let checkLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.SFMedium(size: 11)
        label.textColor = UIColor.rgb(red: 255, green: 69, blue: 58)
        label.text = "중복된 닉네임이에요. 다른 닉네임을 사용해주세요"
        label.alpha = 0
        return label
    }()
    
//    let checkLabel2 : UILabel = {
//        let label = UILabel()
//        label.font = UIFont.SFMedium(size: 11)
//        label.textColor = .vridgeGreen
//        label.text = "사용 가능한 닉네임이에요"
//        label.alpha = 1
//        return label
//    }()
// 사용 가능한 닉네임일 때 생김..
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "color_all_line")
        return view
    }()
    
    let categoryLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.SFSemiBold(size: 14)
        label.textColor = UIColor(named: "color_all_text")
        label.text = "나의 채식 타입 설정"
        return label
    }()
    

    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func editProfileImgButtonDidTap() {
        delegate?.editProfileImgButtonDidTap()
        print("안녕")
    }
    
    // MARK: - Helpers

    func configureUI() {
        
        backgroundColor = UIColor(named: "color_all_viewBackground")
        
        nickNameTextView.delegate = self
        
        addSubview(profileBackground)
        addSubview(profileImage)
        addSubview(editProfileImageButton)
        addSubview(nickNameTextView)
        addSubview(nickNameLineView)
        addSubview(aboutNickNameLabel)
        addSubview(checkLabel)
        addSubview(lineView)
        addSubview(categoryLabel)
        addSubview(nickNameTextView)
    
        profileBackground.anchor(top: topAnchor, paddingTop: 30)
        profileBackground.centerX(inView: self)

        profileImage.anchor(top: profileBackground.topAnchor, paddingTop: 4)
        profileImage.centerX(inView: self)
            
        editProfileImageButton.anchor(top: profileBackground.topAnchor, left: profileBackground.leftAnchor,
                                      paddingTop: 69, paddingLeft: 69)

        nickNameTextView.anchor(top: profileBackground.bottomAnchor, left: leftAnchor, right: rightAnchor,
                                 paddingTop: 28, paddingLeft: 100, paddingRight: 100)
        nickNameTextView.centerX(inView: self)

        nickNameLineView.anchor(top: nickNameTextView.bottomAnchor, left: leftAnchor, right: rightAnchor,
                                paddingTop: 9, paddingLeft: 90, paddingRight: 90, width: 195, height: 1)

        aboutNickNameLabel.anchor(top: nickNameLineView.bottomAnchor, left: leftAnchor, right: rightAnchor,
                                  paddingTop: 8, paddingLeft: 89, paddingRight: 88)
        aboutNickNameLabel.centerX(inView: self)
        
        checkLabel.anchor(top: aboutNickNameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,
                          paddingTop: 6, paddingLeft: 80, paddingRight: 79)
        checkLabel.centerX(inView: self)
        
        lineView.anchor(top: aboutNickNameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 49, height: 0.5)
        categoryLabel.anchor(top: lineView.bottomAnchor, left: leftAnchor, right: rightAnchor,
                             paddingTop: 30, paddingLeft: 134, paddingRight: 133)
        categoryLabel.centerX(inView: self)

    }
}

extension EditProfileHeaderView: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // 키보드의 return 버튼이 눌리면 키보드가 내려감
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        
        // 글자 수 제한..웨않되!!
        guard let words = textView.text else { return true }
        let newLength = words.count + (text.count - range.length)
        return newLength <= 6
    }
    
}
