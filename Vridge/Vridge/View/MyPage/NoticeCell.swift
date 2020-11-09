//
//  NoticeCell.swift
//  MyPageView
//
//  Created by 김루희 on 2020/10/29.
//

import UIKit

class NoticeCell: UITableViewCell {

    
    // MARK: - Properties
    
    let noticeListTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFRegular(size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    let noticeListDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFMedium(size: 13)
        label.textColor = UIColor.rgb(red: 153, green: 153, blue: 153)
        return label
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.setDimensions(width: 375, height: 1)
        view.backgroundColor = UIColor(named: "color_mypage_line")
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        addSubview(noticeListTitle)
        addSubview(noticeListDate)
        addSubview(lineView)
        
        noticeListTitle.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor,
                               paddingTop: 20, paddingLeft: 20, paddingRight: 63)
        noticeListDate.anchor(top: noticeListTitle.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 20)
        lineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}


