//
//  RankingCustomTopView.swift
//  Vridge_Pages
//
//  Created by Kang Mingu on 2020/10/09.
//

import UIKit

protocol RankingCustomTopViewDelegate: class {
    func handleFindMe()
    func handleBackToMain()
}

class RankingCustomTopView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: RankingCustomTopViewDelegate?
    
    private lazy var findMeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "btnMyranking"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleFindMe), for: .touchUpInside)
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "btnBack"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleBackToMain), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecyele
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func handleFindMe() {
        delegate?.handleFindMe()
    }
    
    @objc func handleBackToMain() {
        NotificationCenter.default.post(name: Notification.Name("showPostButton"), object: nil)
        delegate?.handleBackToMain()
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        addSubview(backButton)
        addSubview(findMeButton)
        
        backButton.anchor(top: topAnchor, left: leftAnchor)
        findMeButton.anchor(top: topAnchor, right: rightAnchor)
    }
    
}
