//
//  NicknameTextView.swift
//  Vridge
//
//  Created by 김루희 on 2020/11/10.
//

import UIKit

class NicknameTextView: UITextView {
    
    // MARK: - Properties
    
    let placeholderLabel : UILabel = {
        let label = UILabel()
        label.text = "닉네임 입력"
        label.textAlignment = .center
        label.font = UIFont.SFSemiBold(size: 18)
        label.textColor = UIColor(named: "color_posting_placeHolder")
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        font = UIFont.SFSemiBold(size: 18)
        textAlignment = .center
        textColor = UIColor(named: "color_all_text")
        textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        backgroundColor = .clear
        isUserInteractionEnabled = true
        isScrollEnabled = false
        tintColor = .vridgeGreen
        tintColorDidChange()
        
        addSubview(placeholderLabel)
        
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 0)
        placeholderLabel.centerX(inView: self)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange),
                                               name: UITextView.textDidChangeNotification,
                                               object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK:  - Selector
    
    @objc func handleTextInputChange() {
        placeholderLabel.isHidden = !text.isEmpty
    }
}
