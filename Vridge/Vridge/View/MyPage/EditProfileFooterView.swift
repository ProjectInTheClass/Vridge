//
//  EditProfileFooterView.swift
//  MyPageView
//
//  Created by 김루희 on 2020/11/02.
//

import UIKit

protocol EditProfileFooterViewDelegate: class {
    func deleteAccountDidTap()
}


class EditProfileFooterView: UIView {

    // MARK: - Properties
    
    weak var delegate: EditProfileFooterViewDelegate?
    
    let deleteAccountButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원 탈퇴", for: .normal)
//        button.setTitleColor(.gray, for: .normal)
        button.tintColor = UIColor(named: "color_editprofile_deleteaccount_text")
        button.titleLabel?.font = UIFont.SFMedium(size: 13)
        button.addTarget(self, action: #selector(deleteAccountDidTap), for: .touchUpInside)
        return button
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
    
    @objc func deleteAccountDidTap() {
        delegate?.deleteAccountDidTap()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        backgroundColor = UIColor(named: "color_all_viewBackground")
        
        addSubview(deleteAccountButton)
        
        deleteAccountButton.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 64)
        deleteAccountButton.centerX(inView: self)
        
    }
}
