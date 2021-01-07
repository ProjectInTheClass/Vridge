//
//  Utilities.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/09/16.
//  Copyright © 2020 Kang Mingu. All rights reserved.
//

import UIKit

class Utilities {
    
    func inputContainerView(textField: UITextField, color: UIColor) -> UIView {
        
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
//        let iv = UIImageView()
//        iv.tintColor = UIColor(named: normalButtonColor)
//        iv.contentMode = .scaleToFill
//        iv.image = image
//        view.addSubview(iv)
//        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
//        iv.setDimensions(width: 24, height: 20)
        
        view.addSubview(textField)
        textField.font = UIFont.SFRegular(size: 14)
        textField.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                         right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = color
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                           right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        
        return view
    }
    
    func textField(withPlaceholder placeholder: String) -> UITextField {
        
        let tf = UITextField()
//        tf.font = .systemFont(ofSize: 16)
        tf.font = UIFont.SFMedium(size: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.vridgeGray])
        return tf
    }
    
    func attributedButton(_ firstPart: String, _ secondPart: String) -> UIButton {
        
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attributedTitle.append(NSMutableAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }
}
