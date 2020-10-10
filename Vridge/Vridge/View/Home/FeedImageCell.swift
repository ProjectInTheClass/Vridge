//
//  FeedImageCell.swift
//  Vridge_Pages
//
//  Created by Kang Mingu on 2020/10/08.
//

import UIKit

class FeedImageCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var posts = [Post]() {
        didSet { configureUI() }
    }
    
    let feedImages: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(systemName: "person")
        return iv
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(feedImages)
        feedImages.addConstraintsToFillView(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
//        feedImages.kf.setImage(with: URL(string: photos[0]))
    }
    
}
