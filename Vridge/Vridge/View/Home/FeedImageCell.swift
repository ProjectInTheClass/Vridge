//
//  FeedImageCell.swift
//  Vridge_Pages
//
//  Created by Kang Mingu on 2020/10/08.
//

import UIKit

class FeedImageCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var imageURL: String? {
        didSet { configure() }
    }
    
    let feedImages: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
//        iv.image = UIImage(systemName: "person")
        return iv
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(feedImages)
        feedImages.addConstraintsToFillView(self)
        prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    
    // MARK: - Helpers
    
    override func prepareForReuse() {
        super.prepareForReuse()
        feedImages.image = nil
    }
    
    func configure() {
        
        guard let url = imageURL else { return }
        
        feedImages.kf.setImage(with: URL(string: url))
    }
    
}
