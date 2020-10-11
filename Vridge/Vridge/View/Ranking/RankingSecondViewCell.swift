//
//  RankingSecondViewCell.swift
//  Vridge_Pages
//
//  Created by Kang Mingu on 2020/10/09.
//

import UIKit

class RankingSecondViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var option: RankingFilterOptions! {
        didSet { titleLabel.text = option.description }
    }
    
    override var isSelected: Bool {
        didSet {
            titleLabel.textColor = isSelected ? .black : .vridgePlaceholderColor
            titleLabel.font = isSelected ? UIFont.SFSemiBold(size: 16) : UIFont.SFSemiBold(size: 16)
        }
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFSemiBold(size: 16)
        label.textColor = .vridgePlaceholderColor
        return label
    }()
    
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        titleLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
