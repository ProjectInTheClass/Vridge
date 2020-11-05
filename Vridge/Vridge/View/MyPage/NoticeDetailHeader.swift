//
//  NoticeDetailHeader.swift
//  MyPageView
//
//  Created by 김루희 on 2020/10/31.
//

import UIKit

class NoticeDetailHeader: UIView {
    
    // MARK: - Properties

    
    let line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "color_mypage_line")
        return view
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        addSubview(line)
        backgroundColor = .white
        
        line.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 1)
        
    }
    
}
