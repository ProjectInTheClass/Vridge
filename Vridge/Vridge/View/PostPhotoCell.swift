//
//  PostPhotoCell.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/04.
//

import UIKit

class PostPhotoCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.tintColor = .vridgePlaceholderColor
        iv.layer.borderColor = UIColor.vridgeGreen.cgColor
        iv.layer.borderWidth = 4
        return iv
    }()
    
    let numberingLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .vridgeGreen
        label.textAlignment = .center
        label.font = UIFont.SFRegular(size: 14)
        label.setDimensions(width: 20, height: 20)
        label.textColor = .white
        label.layer.cornerRadius = 20 / 2
        label.clipsToBounds = true
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(numberingLabel)
        
        imageView.addConstraintsToFillView(self)
        numberingLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 7, paddingRight: 7)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
