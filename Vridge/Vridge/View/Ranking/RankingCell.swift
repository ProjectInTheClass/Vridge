//
//  RankingCell.swift
//  Vridge_Pages
//
//  Created by Kang Mingu on 2020/10/09.
//

import UIKit

class RankingCell: UITableViewCell {
    
    // MARK: - Properties
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    let number: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFHeavy(size: 16)
        label.textColor = .vridgeBlack
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    
    let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 42, height: 42)
        iv.layer.cornerRadius = 42 / 2
        iv.clipsToBounds = true
        iv.backgroundColor = .vridgePlaceholderColor
        return iv
    }()
    
    let username: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFSemiBold(size: 16)
        label.textColor = .vridgeBlack
        label.text = "김루키루키"
        return label
    }()
    
    let type: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFRegular(size: 14)
//        label.textColor = .vridgeGray
        label.text = "@pollo"
        return label
    }()
    
    let saladImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "salad")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let pointLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFHeavy(size: 16)
        label.text = "121"
        label.textColor = .vridgeBlack
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        contentView.isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    // MARK: - Selectors
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        let usernameAndType = UIStackView(arrangedSubviews: [username, type])
        usernameAndType.axis = .vertical
        usernameAndType.spacing = 1
        usernameAndType.alignment = .leading
        
        let saladAndPoint = UIStackView(arrangedSubviews: [saladImage, pointLabel])
        saladAndPoint.spacing = 0
        saladAndPoint.alignment = .center
        
        addSubview(containerView)
        containerView.addSubview(number)
        containerView.addSubview(profileImage)
        containerView.addSubview(usernameAndType)
        containerView.addSubview(saladAndPoint)
        
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
                             paddingTop: 16, paddingLeft: 16, paddingBottom: 0, paddingRight: 16)
        number.centerY(inView: containerView, leftAnchor: containerView.leftAnchor, paddingLeft: 7)
        number.anchor(right: profileImage.leftAnchor, paddingRight: 7)
        profileImage.anchor(top: containerView.topAnchor, left: containerView.leftAnchor,
                            bottom: containerView.bottomAnchor, paddingTop: 17, paddingLeft: 50,
                            paddingBottom: 17)
        usernameAndType.centerY(inView: containerView, leftAnchor: profileImage.rightAnchor,
                                paddingLeft: 15)
        saladAndPoint.centerY(inView: containerView)
        saladAndPoint.anchor(right: containerView.rightAnchor, paddingRight: 20)
    }

}
