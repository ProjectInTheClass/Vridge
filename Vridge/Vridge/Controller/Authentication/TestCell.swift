//
//  TestCell.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/17.
//

import UIKit

class TestCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let typeLabel = UILabel()
    let detailLabel = UILabel()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(typeLabel)
        addSubview(detailLabel)
        
        typeLabel.center(inView: self)
        detailLabel.anchor(top: typeLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
