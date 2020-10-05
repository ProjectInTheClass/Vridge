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
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.tintColor = .darkGray
        iv.layer.borderColor = UIColor.vridgeGreen.cgColor
        iv.layer.borderWidth = 2
        return iv
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        imageView.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
