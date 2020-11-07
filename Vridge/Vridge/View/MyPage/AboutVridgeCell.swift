//
//  AboutVridgeCell.swift
//  MyPageView
//
//  Created by 김루희 on 2020/10/31.
//

import UIKit

class AboutVridgeCell: UITableViewCell {

    // MARK: - Properties
    
    let aboutImage : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "imgAboutVridge")
        iv.clipsToBounds = true
        return iv
    }()
    

    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        addSubview(aboutImage)
        
        aboutImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        
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
