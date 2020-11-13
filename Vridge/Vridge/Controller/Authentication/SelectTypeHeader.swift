//
//  SelectTypeHeader.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/11/13.
//

import UIKit

protocol SelectTypeHeaderDelegate: class {
    func setProfilePhotoDidTap()
    func usernameDidSet(usernameText: String, canUse: Bool)
}

class SelectTypeHeader: UIView {

    // MARK: - Properties
    
    weak var delegate: SelectTypeHeaderDelegate?
    
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
    
    let checkLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.SFMedium(size: 11)
        label.textColor = UIColor.rgb(red: 255, green: 69, blue: 58)
        label.text = "중복된 닉네임이에요. 다른 닉네임을 사용해주세요"
        label.alpha = 0
        return label
    }()
    
    let checkLabel2 : UILabel = {
        let label = UILabel()
        label.font = UIFont.SFMedium(size: 11)
        label.textColor = .vridgeGreen
        label.text = "사용 가능한 닉네임이에요"
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
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
        delegate?.setProfilePhotoDidTap()
        print("DEBUG: button tapped from the header")
    }
    
    
    // MARK: - Helpers

    func configureUI() {
        
        backgroundColor = UIColor(named: viewBackgroundColor)
        
        nickNameTextField.delegate = self
        
        addSubview(profileBackground)
        addSubview(profileImage)
        addSubview(editProfileImageButton)
        addSubview(nickNameTextField)
        addSubview(nickNameLineView)
        addSubview(aboutNickNameLabel)
        addSubview(checkLabel)
        addSubview(checkLabel2)
        addSubview(lineView)
        addSubview(categoryLabel)

    
        profileBackground.anchor(top: topAnchor, paddingTop: 30)
        profileBackground.centerX(inView: self)

        profileImage.anchor(top: profileBackground.topAnchor, paddingTop: 4)
        profileImage.centerX(inView: self)
            
        editProfileImageButton.anchor(top: profileBackground.topAnchor, left: profileBackground.leftAnchor,
                                      paddingTop: 69, paddingLeft: 69)

        nickNameTextField.anchor(top: profileBackground.bottomAnchor, left: leftAnchor, right: rightAnchor,
                                 paddingTop: 28, paddingLeft: 100, paddingRight: 100)
        nickNameTextField.centerX(inView: self)

        nickNameLineView.anchor(top: nickNameTextField.bottomAnchor, left: leftAnchor, right: rightAnchor,
                                paddingTop: 9, paddingLeft: 90, paddingRight: 90, width: 195, height: 1)

        aboutNickNameLabel.anchor(top: nickNameLineView.bottomAnchor, left: leftAnchor, right: rightAnchor,
                                  paddingTop: 8, paddingLeft: 89, paddingRight: 88)
        aboutNickNameLabel.centerX(inView: self)
        
        checkLabel.anchor(top: aboutNickNameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,
                          paddingTop: 6, paddingLeft: 80, paddingRight: 79)
        checkLabel.centerX(inView: self)
        checkLabel2.anchor(top: aboutNickNameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,
                          paddingTop: 6, paddingLeft: 80, paddingRight: 79)
        checkLabel2.centerX(inView: self)
        
        lineView.anchor(top: aboutNickNameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 49, height: 0.5)
        categoryLabel.anchor(top: lineView.bottomAnchor, left: leftAnchor, right: rightAnchor,
                             paddingTop: 30, paddingLeft: 134, paddingRight: 133)
        categoryLabel.centerX(inView: self)

    }
    
}

// MARK: - UITextFieldDelegate

extension SelectTypeHeader: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if text.contains(".") {
            nickNameTextField.text = text.replacingOccurrences(of: ".", with: "")
        } else if text.contains("#") {
            nickNameTextField.text = text.replacingOccurrences(of: "#", with: "")
        } else if text.contains("$") {
            nickNameTextField.text = text.replacingOccurrences(of: "$", with: "")
        } else if text.contains("[") {
            nickNameTextField.text = text.replacingOccurrences(of: "[", with: "")
        } else if text.contains("]") {
            nickNameTextField.text = text.replacingOccurrences(of: "]", with: "")
        } else if text.contains(" ") {
            nickNameTextField.text = text.replacingOccurrences(of: " ", with: "")
        }
        
        if text.count >= 7 {
            let name = text
            nickNameTextField.text = String(name.dropLast())
        } else {
            
            AuthService.shared.checkUserNameExistency(username: text.lowercased()) { canUse in
                self.checkLabel.alpha = canUse ? 0 : 1
                self.checkLabel2.alpha = canUse ? 1 : 0
                self.delegate?.usernameDidSet(usernameText: text.lowercased(), canUse: canUse)
                print("DEBUG: can use? \(canUse)")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(nickNameTextField.text!)
        nickNameTextField.endEditing(true)
        return true
    }

}
