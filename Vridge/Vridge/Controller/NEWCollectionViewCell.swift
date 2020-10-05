//
//  NEWCollectionViewCell.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/05.
//

import UIKit

class NEWCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let label = UILabel()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
