//
//  testCell.swift
//  MyPageView
//
//  Created by Kang Mingu on 2020/10/26.
//

import UIKit

class MenuCell: UITableViewCell {
    
    // MARK: - Properties
    
    let menuName: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFMedium(size: 16)
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor(named: "color_all_viewBackground")
        
        addSubview(menuName)
        
        menuName.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 20)
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
