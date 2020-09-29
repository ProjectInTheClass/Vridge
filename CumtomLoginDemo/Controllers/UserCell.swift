//
//  UserCell.swift
//  CumtomLoginDemo
//
//  Created by Kang Mingu on 2020/09/09.
//  Copyright © 2020 Kang Mingu. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    // MARK: - Properties
    
    let profileImage: UIImageView = {
        let imgView = UIImageView()
        return imgView
    }()
    
    let mainView = UIView()
    
    lazy var button: UIButton = {
        let butt = UIButton(type: .system)
        butt.addTarget(self, action: #selector(handleTapped), for: .touchUpInside)
        butt.setTitle("dkfjksdjfksjdflksj", for: .normal)
        return butt
    }()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(mainView)
        mainView.addSubview(profileImage)
        mainView.addSubview(button)
        
        mainView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        button.anchor(top: mainView.topAnchor, left: mainView.leftAnchor, paddingTop: 30, paddingLeft: 80)
        
        mainView.backgroundColor = .yellow
        
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
    
    
    // MARK: - Selector
    
    @objc func handleTapped() {
        print("tapped")
    }
    
    
    // MARK: - Helper

}
