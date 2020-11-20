//
//  MyPostDetailCell.swift
//  Vridge
//
//  Created by 김루희 on 2020/11/06.
//

import UIKit

class MyPostDetailCell: UITableViewCell {

    // MARK: - Properties
    
    let userImage : UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(width: 45, height: 45)
        iv.layer.cornerRadius = 45 / 2
        iv.backgroundColor = .yellow
        return iv
    }()
    
    lazy var username: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFSemiBold(size: 14)
        label.textColor = UIColor(named: allTextColor)
        label.text = "루희"
        return label
    }()
    
    lazy var type: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFRegular(size: 14)
        label.text = "@vegan"
        return label
    }()
    
    let date: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFRegular(size: 12)
        label.textColor = .vridgeGray
        label.text = "2020년 11월 30일"
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFRegular(size: 14)
        label.textColor = UIColor(named: allTextColor)
        label.numberOfLines = 0
        label.text = "너무 맛잇다. 마트 다녀오셨어열? 우왕 옆 집 텃밭에 영기엄마가 호박고구마를.. 줬다 이양호 오아아ㅏ아아아ㅏ아할아버지는 짜장면이 싫다고 하셧얼"
        return label
    }()
    
    lazy var reportButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "btnReport"), for: .normal)
//        button.addTarget(self, action: #selector(handleReportTapped), for: .touchUpInside)
        button.tintColor = UIColor(named: "color_all_button_normal")
        return button
    }()
    
    let feedImages : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 343, height: 343)
        iv.layer.cornerRadius = 10
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .vridgeGreen
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(named: viewBackgroundColor)
        
        addSubview(userImage)
        addSubview(username)
        addSubview(type)
        addSubview(date)
        addSubview(captionLabel)
        addSubview(reportButton)
        addSubview(feedImages)
        
        
        userImage.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        username.anchor(top: topAnchor, left: userImage.rightAnchor, paddingTop: 21, paddingLeft: 14)
        type.anchor(top: topAnchor, left: username.rightAnchor, paddingTop: 20, paddingLeft: 4)
        date.anchor(top: username.bottomAnchor, left: userImage.rightAnchor, paddingTop: 3, paddingLeft: 14)
        captionLabel.anchor(top: userImage.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 16, paddingRight: 16)
        reportButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 12)
        feedImages.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        feedImages.centerX(inView: self)
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
