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
    
    
    let profileBg : UIView = {
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
    
    lazy var editProfileImgButton : UIButton = {
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
    
    let nickNameTextField : UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임 입력"
        textField.textAlignment = .center
        textField.textColor = UIColor(named: "color_all_text")
        textField.font = UIFont.SFSemiBold(size: 18)
        textField.tintColor = UIColor(named: "color_cursor") // cursor 색상
        return textField
    }()
    
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
        
        nickNameTextField.delegate = self
        
        addSubview(profileBg)
        addSubview(profileImage)
        addSubview(editProfileImgButton)
        addSubview(nickNameTextField)
        addSubview(nickNameLineView)
        addSubview(aboutNickNameLabel)
    
        profileBg.anchor(top: topAnchor, paddingTop: 50)
        profileBg.centerX(inView: self)
        
        profileImage.anchor(top: profileBg.topAnchor, paddingTop: 4)
        profileImage.centerX(inView: self)
            
        editProfileImgButton.anchor(top: profileBg.topAnchor, left: profileBg.leftAnchor, paddingTop: 69, paddingLeft: 69)
        
        nickNameTextField.anchor(top: profileBg.bottomAnchor, left: leftAnchor, right: rightAnchor,
                                 paddingTop: 30, paddingLeft: 100, paddingRight: 100)
        nickNameTextField.centerX(inView: self)
        
        nickNameLineView.anchor(top: nickNameTextField.bottomAnchor, left: leftAnchor, right: rightAnchor,
                                paddingTop: 9, paddingLeft: 90, paddingRight: 90, width: 195, height: 1)
        
        aboutNickNameLabel.anchor(top: nickNameLineView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 89, paddingRight: 88)
        aboutNickNameLabel.centerX(inView: self)
        

    }
}

extension EditProfileHeaderView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 7
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(nickNameTextField.text!)
        nickNameTextField.endEditing(true)
        return true
    }
    
}
