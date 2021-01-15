//
//  Extension.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/05.
//  Copyright © 2020 Kang Mingu. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        paddingTop : CGFloat = 0,
        paddingLeft : CGFloat = 0,
        paddingBottom : CGFloat = 0,
        paddingRight : CGFloat = 0,
        width: CGFloat? = nil,
        height: CGFloat? = nil) {
        
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    
    
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo:view.centerYAnchor , constant: yConstant!).isActive = true
        
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil, paddingLeft: CGFloat? = nil,
                 constant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant!).isActive = true
        
        if let leftAnchor = leftAnchor, let padding = paddingLeft {
            
            self.leftAnchor.constraint(equalTo: leftAnchor, constant: padding).isActive = true
        }
    }
    
    func setDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func addConstraintsToFillView(_ view: UIView) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    func makeAborderWidth(border: CGFloat, color: CGColor) {
        
        self.layer.borderColor = color
        self.layer.borderWidth = border
    }
    
    func makeAcircle( dimension : Int) {
        
        self.layer.cornerRadius = CGFloat(dimension / 2)
        self.clipsToBounds = true
        self.setDimensions(width: CGFloat(dimension), height: CGFloat(dimension))
    }
    
    func makeAborder(radius: Int) {
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
    }
    
    
}

extension UITextField {
    func disableAutoFill() {
        if #available(iOS 12, *) {
            textContentType = .oneTimeCode
        } else {
            textContentType = .init(rawValue: "")
        }
    }
}

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static let vridgeTabBar = UIColor.rgb(red: 0, green: 213, blue: 98)
    
    static let vridgeGreen = UIColor.rgb(red: 3, green: 213, blue: 100)
    static let vridgePlaceholderColor = UIColor.rgb(red: 192, green: 192, blue: 194)
    static let vridgeBlack = UIColor.rgb(red: 21, green: 21, blue: 21)
    static let vridgeGray = UIColor.rgb(red: 153, green: 153, blue: 153)
    static let vridgeWhite = UIColor.rgb(red: 245, green: 245, blue: 245)
    static let vridgePostingBorder = UIColor.rgb(red: 245, green: 245, blue: 245)
    
    // type color
    static let vridge_typeFruitarian = UIColor.rgb(red: 174, green: 234, blue: 0)
    static let vridge_typeVegan = UIColor.rgb(red: 60, green: 242, blue: 0)
    static let vridge_typeLacto = UIColor.rgb(red: 100, green: 221, blue: 23)
    static let vridge_typeOvo = UIColor.rgb(red: 0, green: 209, blue: 48)
    static let vridge_typeLactoOvo = UIColor.rgb(red: 0, green: 213, blue: 98)
    static let vridge_typePesco = UIColor.rgb(red: 31, green: 186, blue: 109)
    static let vridge_typePollo = UIColor.rgb(red: 35, green: 190, blue: 0)
    static let vridge_typeFlexitarian = UIColor.rgb(red: 0, green: 178, blue: 72)
}

extension UIColor {
     static func dynamic(light: UIColor, dark: UIColor) -> UIColor {

         if #available(iOS 13.0, *) {
             return UIColor(dynamicProvider: {
                 switch $0.userInterfaceStyle {
                 case .dark:
                     return dark
                 case .light, .unspecified:
                     return light
                 @unknown default:
                     assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                     return light
                 }
             })
         }

         // iOS 12 and earlier
         return light
     }
}

extension UIColor {
    private static let customColor = UIColor.rgb(red: 245, green: 245, blue: 245)
    private static let customColorDarkMode = UIColor.rgb(red: 0, green: 0, blue: 0)
    
    static let borderColor = UIColor.dynamic(light: customColor, dark: customColorDarkMode)
}

extension UIFont {
    
    static func SFRegular(size: CGFloat) -> UIFont? {
        let font = UIFont(name: "SFPro-Regular", size: size)
        return font
    }
    
    static func SFSemiBold(size: CGFloat) -> UIFont? {
        let font = UIFont(name: "SFPro-Semibold", size: size)
        return font
    }
    
    static func SFBold(size: CGFloat) -> UIFont? {
        let font = UIFont(name: "SFPro-Bold", size: size)
        return font
    }
    
    static func SFHeavy(size: CGFloat) -> UIFont? {
        let font = UIFont(name: "SFPro-Heavy", size: size)
        return font
    }
    
    static func SFUltraLight(size: CGFloat) -> UIFont? {
        let font = UIFont(name: "SFPro-Ultralight", size: size)
        return font
    }
    
    static func SFThin(size: CGFloat) -> UIFont? {
        let font = UIFont(name: "SFPro-Thin", size: size)
        return font
    }
    
    static func SFLight(size: CGFloat) -> UIFont? {
        let font = UIFont(name: "SFPro-Light", size: size)
        return font
    }
    
    static func SFMedium(size: CGFloat) -> UIFont? {
        let font = UIFont(name: "SFPro-Medium", size: size)
        return font
    }
    
    static func SFBlack(size: CGFloat) -> UIFont? {
        let font = UIFont(name: "SFPro-Black", size: size)
        return font
    }
    
}


extension String {
    func isValidEmailAddress(email: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: email)
    
    }
    
    func validatePassword() -> Bool {
        let passwordRegEx = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8}$"
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        
        return predicate.evaluate(with: self)
    }
}

extension UITextField {
    
    func oneTimecodeTextField() {
        
        
    }
}


extension UIViewController {
    
    func floatingButton(selector : Selector) {
        let btn = UIButton(type: .custom)
        view.addSubview(btn)
        btn.anchor(bottom: view.bottomAnchor,right: view.rightAnchor,paddingBottom: 80,paddingRight: 30)
        btn.setDimensions(width: 60, height: 60)
        btn.makeAcircle(dimension: 60)
        btn.setTitle("shop", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        btn.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        btn.layer.borderWidth = 3.0
        btn.addTarget(self, action: selector, for: .touchUpInside)
        
    }

    
    func showAlertOK(mainTitle : String , mainMessage : String , alertMessage: String,  completion : @escaping() -> Void) {

        let alert = UIAlertController(title: mainTitle, message: mainMessage, preferredStyle: .alert)
        

        let ok = UIAlertAction(title: alertMessage, style: .default) { completion in
            
        }
//        let cancel =  UIAlertAction(title: "취소", style: .cancel, handler: nil )
//
        alert.addAction(ok)
        //alert.addAction(cancel)
        
        present(alert, animated: true , completion: nil)
    }
}

extension String {
   public var hasWhiteSpace: Bool {
      return self.contains(" ")
   }
}
