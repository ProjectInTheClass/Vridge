//
//  HomeHeaderView.swift
//  Vridge_Pages
//
//  Created by Kang Mingu on 2020/10/07.
//

import UIKit

class HomeHeaderView: UIView {
        
    // MARK: - Properties
    
    let label1: UILabel = {
        let label = UILabel()
        label.text = "브릿지 님,"
        label.font = UIFont.SFBold(size: 28)
        return label
    }()
    
    let label2: UILabel = {
        let label = UILabel()
        
        let text = NSMutableAttributedString(string: "오늘 하루도\n맛있는 채식하셨나요?")
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        text.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, text.length))
        
        label.attributedText = text
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = UIFont.SFLight(size: 28)
        return label
    }()
    
    let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .vridgePlaceholderColor
        return view
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label1)
        addSubview(label2)
        addSubview(underLine)
        
        label1.anchor(top: topAnchor, left: leftAnchor, paddingTop: 22, paddingLeft: 20)
        label2.anchor(top: label1.bottomAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 20)
        underLine.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
