//
//  PhotoAddView.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/30.
//

import UIKit

class PhotoAddView: UIView {
    
    // MARK: - Properties
    
    private let addPhotoImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "addImageCamera")
        img.contentMode = .scaleAspectFill
        img.tintColor = .white
        return img
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setDimensions(width: 123, height: 123)
        layer.cornerRadius = 8
        isUserInteractionEnabled = true
        backgroundColor = UIColor(named: borderColor)
        
        addSubview(addPhotoImage)
        
        addPhotoImage.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
