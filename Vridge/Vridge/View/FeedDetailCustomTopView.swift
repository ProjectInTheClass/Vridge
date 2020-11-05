//
//  FeedDetailCustomTopView.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/11/06.
//

import UIKit

protocol FeedDetailCustomTopViewDelegate: class {
    func handleBackButtonTapped()
}

class FeedDetailCustomTopView: UIView {

    // MARK: - Properties
    
    weak var delegate: FeedDetailCustomTopViewDelegate?
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "btnBack"), for: .normal)
        button.tintColor = UIColor(named: "color_all_button_normal")
        button.addTarget(self, action: #selector(handleBackToMain), for: .touchUpInside)
        return button
    }()
    
    private let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "color_all_line")
        return view
    }()
    
    
    // MARK: - Lifecyele
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: viewBackgroundColor)
        
        addSubview(backButton)
        addSubview(underLine)
        
        backButton.anchor(top: topAnchor, left: leftAnchor)
        underLine.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func handleBackToMain() {
        delegate?.handleBackButtonTapped()
    }
    
}
