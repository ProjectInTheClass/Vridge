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
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        
        let text = NSMutableAttributedString(string: "오늘 하루 채식 식단을 기록해보세요.\n단, 채식과 관련 없는 내용은 지양해 주세요.\n* 200자까지 작성 할 수 있어요.\n** 사진은 필수로 선택해 주셔야 해요.")
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        text.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, text.length))
        
        label.attributedText = text
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.SFRegular(size: 14)
        label.textColor = .vridgePlaceholderColor
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = .white
        font = UIFont.SFRegular(size: 14)
        isScrollEnabled = true
        
        addSubview(placeholderLabel)
        
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor,
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
        placeholderLabel.isHidden = !text.isEmpty
    }
}
