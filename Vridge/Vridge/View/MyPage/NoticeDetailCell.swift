//
//  NoticeDetailCell.swift
//  MyPageView
//
//  Created by 김루희 on 2020/10/31.
//

import UIKit

class NoticeDetailCell: UITableViewCell {

    // MARK: - Properties
    
    let noticeDetailTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFSemiBold(size: 16)
        label.numberOfLines = 0
        return label
    }()
    
    let noticeDetailDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFMedium(size: 13)
        label.textColor = UIColor.rgb(red: 153, green: 153, blue: 153)
        return label
    }()
    
    let noticeDetailContent: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFRegular(size: 15)
        label.numberOfLines = 0
        return label
    }()
    
//    let lineView: UIView = {
//        let view = UIView()
//        view.setDimensions(height: 1, width: 375)
//        view.backgroundColor = .systemGray
//        return view
//    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(noticeDetailTitle)
        addSubview(noticeDetailDate)
        addSubview(noticeDetailContent)
//        addSubview(lineView)
        
        noticeDetailTitle.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)
        noticeDetailDate.anchor(top: noticeDetailTitle.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 20)
//        lineView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        noticeDetailContent.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20)

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

        // Configure the view for the selected state
    }

}
