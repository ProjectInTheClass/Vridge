//
//  HomeHeaderView.swift
//  Vridge_Pages
//
//  Created by Kang Mingu on 2020/10/07.
//

import UIKit

class HomeHeaderView: UIView {
        
    // MARK: - Properties
    
    var user: User {
        didSet { reloadInputViews() }
    }
    
    var point: Int
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "\(user.username) 님,"
        label.font = UIFont.SFBold(size: 28)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.attributedText = descriptionAttributed
        label.numberOfLines = 2
        return label
    }()
    
    lazy var kkiOrIl: UILabel = {
        let label = UILabel()
        label.text = point > 99 ? "일" : "끼"
        return label
    }()
    
    lazy var pointOrDays: UILabel = {
        let label = UILabel()
        label.text = point > 99 ? "\(Int(point / 3))" : "\(point)"
        return label
    }()
    
    var descriptionAttributed: NSAttributedString {
        let head = NSMutableAttributedString(string: "브릿지와 함께 ", attributes: [.font: UIFont.SFLight(size: 28)!])
        head.append(NSAttributedString(string: "\(pointOrDays.text!)\(kkiOrIl.text!)",
                                              attributes: [.font: UIFont.SFBold(size: 28)!]))
        head.append(NSAttributedString(string: " 째\n채식에 참여하고 있어요!",
                                       attributes: [.font: UIFont.SFLight(size: 28)!]))
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        head.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, head.length))
        return head
    }
    
    let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .vridgePlaceholderColor
        return view
    }()
    
    
    // MARK: - Lifecycle
    
    init(frame: CGRect, user: User, point: Int) {
        self.user = user
        self.point = point
        super.init(frame: frame)
        
        addSubview(usernameLabel)
        addSubview(descriptionLabel)
        addSubview(underLine)
        
        usernameLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 20)
        descriptionLabel.anchor(top: usernameLabel.bottomAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 20)
        underLine.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 0.5)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
}
