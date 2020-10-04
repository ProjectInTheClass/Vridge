//
//  CaptionTextView.swift
//  TwitterTutorial
//
//  Created by Kang Mingu on 2020/09/18.
//  Copyright © 2020 Kang Mingu. All rights reserved.
//

import UIKit

class CaptionTextView: UITextView {
    
    // MARK: - Properties
    
    lazy var placeholderlabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        label.lineBreakStrategy = .hangulWordPriority
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = .white
        font = .systemFont(ofSize: 16)
        isScrollEnabled = true
        
        addSubview(placeholderlabel)
        
        placeholderlabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor,
                                paddingTop: 8, paddingLeft: 4, paddingRight: 4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK:  - Selector
    
    @objc func handleTextInputChange() {
        placeholderlabel.isHidden = !text.isEmpty
    }
}
