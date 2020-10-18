//
//  PostPhotoCell.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/04.
//

import UIKit

class PostPhotoCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    let addPhotoImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.tintColor = .black
        return iv
    }()
    
    let photoCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFRegular(size: 14)
        return label
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.tintColor = .black
        iv.layer.cornerRadius = 8
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
