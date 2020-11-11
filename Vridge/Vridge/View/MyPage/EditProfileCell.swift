//
//  EditProfileCell.swift
//  MyPageView
//
//  Created by 김루희 on 2020/11/01.
//

import UIKit

protocol EditProfileDelegate: class {
    func typeDidTap(type: String)
}

class EditProfileCell: UITableViewCell {

    // MARK: - Properties
    
    weak var delegate: EditProfileDelegate?
    
    let vegieTypeName : UILabel = {
        let label = UILabel()
        label.font = UIFont.SFBold(size: 16)
        label.textColor = UIColor(named: "color_editprofile_vegietype_text")
        return label
    }()
    
    let vegieTypeDescription : UILabel = {
        let label = UILabel()
        label.font = UIFont.SFSemiBold(size: 12)
        label.textColor = UIColor(named: "color_editprofile_vegietype_text")
        return label
    }()
    
    let vegieTypeImage : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .white
//        iv.image = UIImage(named: "typeImage")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let typeButtonView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
//        button.addTarget(self, action: #selector(), for: .touchUpInside)
        return view
    }()
    
    var typeColor: UIColor?
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor(named: "color_all_viewBackground")
        
        addSubview(typeButtonView)
        addSubview(vegieTypeName)
        addSubview(vegieTypeDescription)
        addSubview(vegieTypeImage)
        
        typeButtonView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
                              paddingTop: 6, paddingLeft: 16, paddingBottom: 6, paddingRight: 16,
                              width: 343, height: 84)
        typeButtonView.centerX(inView: self)
        
        vegieTypeName.anchor(top: typeButtonView.topAnchor, left: typeButtonView.leftAnchor, paddingTop: 23, paddingLeft: 84)
        vegieTypeDescription.anchor(top: vegieTypeName.bottomAnchor, left: typeButtonView.leftAnchor,
                                    paddingTop: 4, paddingLeft: 84)
        vegieTypeImage.anchor(top: typeButtonView.topAnchor, left: typeButtonView.leftAnchor, paddingTop: 18, paddingLeft: 18)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: true)
        
        
        
        if selected {
//            typeButtonView.backgroundColor = .vridgeGreen // 채식 타입 별로 색상 지정해줘야 함 ->> 근데 그냥 vridgeGreen으로 갈 것 같다..
            typeButtonView.backgroundColor = typeColor
            vegieTypeName.textColor = .white
            vegieTypeDescription.textColor = .white
            delegate?.typeDidTap(type: vegieTypeName.text!)
        } else {
            typeButtonView.backgroundColor = UIColor(named: "color_editprofile_vegietype_button")
            vegieTypeName.textColor = UIColor(named: "color_editprofile_vegietype_text")
            vegieTypeDescription.textColor = UIColor(named: "color_editprofile_vegietype_text")
        }
        
        
    }

}
