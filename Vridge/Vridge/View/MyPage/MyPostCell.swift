//
//  MyPostCell.swift
//  Vridge
//
//  Created by 김루희 on 2020/11/05.
//

import UIKit

class MyPostCell: UICollectionViewCell {

    // MARK: - Properties
    
    let myPostImage : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(myPostImage)
        myPostImage.addConstraintsToFillView(self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
