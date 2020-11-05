//
//  SectionHeader.swift
//  MyPageView
//
//  Created by Kang Mingu on 2020/10/26.
//

import UIKit

class FirstSectionHeader: UIView {
    
    // MARK: - Properties
    
    let sectionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.rgb(red: 192, green: 192, blue: 194)
        label.font = UIFont.SFMedium(size: 13)
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        backgroundColor = UIColor(named: "color_all_viewBackground")
        
        addSubview(sectionLabel)
        
        sectionLabel.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 20)
        
    }

}
