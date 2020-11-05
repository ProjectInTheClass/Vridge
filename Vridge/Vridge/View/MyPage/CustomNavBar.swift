//
//  CustomNavBar.swift
//  MyPageView
//
//  Created by 김루희 on 2020/10/29.
//

import UIKit

protocol CustomNavBarDelegate: class {
    func backButtonDidTap()
}

class CustomNavBar: UIView {

    //MARK: - Properties
    weak var delegate: CustomNavBarDelegate?
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "공지사항"
        label.font = UIFont.SFBold(size: 18)
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "btnBack"), for: .normal)
        button.tintColor = UIColor(named: "color_all_button_normal")
        button.addTarget(self, action: #selector(backButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "color_all_line")
        return view
    }()
    
    let navBarView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "color_all_headerBg")
        return view
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(navBarView)
        addSubview(titleLabel)
        addSubview(backButton)
        addSubview(lineView)
        
        
        titleLabel.centerX(inView: self)
        titleLabel.centerY(inView: self)
        
        backButton.anchor(top: topAnchor, left: leftAnchor)
        
        lineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 0.5)
        navBarView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: -44 ,height: 88)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func backButtonDidTap() {
        delegate?.backButtonDidTap()
    }
}
