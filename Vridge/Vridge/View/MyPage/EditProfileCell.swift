//
//  EditProfileCell.swift
//  MyPageView
//
//  Created by 김루희 on 2020/11/01.
//

import UIKit

class EditProfileCell: UITableViewCell {

    // MARK: - Properties
    
    let vegieTypeName : UILabel = {
        let label = UILabel()
        label.font = UIFont.SFBold(size: 16)
        label.textColor = UIColor(named: "color_editprofile_vegietype_text")
        return label
    }()
    
    let vegieTypeDescription : UILabel = {
        let label = UILabel()
        label.font = UIFont.SFMedium(size: 12)
        label.textColor = UIColor(named: "color_editprofile_vegietype_text")
        return label
    }()
    
    let vegieTypeImage : UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 36, height: 36)
        iv.layer.cornerRadius = 36 / 2
        iv.backgroundColor = .white
//        iv.image = UIImage(named: "typeImage")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let typeButtonView : UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor(named: "color_editprofile_vegietype_button")
        view.layer.cornerRadius = 8
//        view.layer.borderColor = UIColor(named: "color_editprofile_vegietype_buttonborder")?.cgColor
//        view.layer.borderWidth = 2
        
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5 // 그림자 크기
//        button.addTarget(self, action: #selector(), for: .touchUpInside)
        
        return view
    }()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor(named: "color_all_viewBackground")
        
        addSubview(typeButtonView)
        addSubview(vegieTypeName)
        addSubview(vegieTypeDescription)
        addSubview(vegieTypeImage)
        
        typeButtonView.anchor(top: topAnchor, bottom: bottomAnchor, paddingTop: 10, paddingBottom: 10, width: 296, height: 64)
        typeButtonView.centerX(inView: self)
        vegieTypeName.anchor(top: typeButtonView.topAnchor, left: typeButtonView.leftAnchor, paddingTop: 14, paddingLeft: 76)
        vegieTypeDescription.anchor(top: vegieTypeName.bottomAnchor, left: typeButtonView.leftAnchor,
                                    paddingTop: 1, paddingLeft: 76)
        vegieTypeImage.anchor(top: typeButtonView.topAnchor, left: typeButtonView.leftAnchor, paddingTop: 14, paddingLeft: 22)
        
        
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
            typeButtonView.backgroundColor = .vridgeGreen // 채식 타입 별로 색상 지정해줘야 함
//            typeButtonView.layer.borderColor = UIColor.vridgeGreen.cgColor // 채식 타입 별로 색상 지정해줘야 함
            vegieTypeName.textColor = .white
            vegieTypeDescription.textColor = .white
        } else {
            typeButtonView.backgroundColor = UIColor(named: "color_editprofile_vegietype_button")
//            typeButtonView.layer.borderColor = UIColor(named: "color_editprofile_vegietype_buttonborder")?.cgColor
            vegieTypeName.textColor = UIColor(named: "color_editprofile_vegietype_text")
            vegieTypeDescription.textColor = UIColor(named: "color_editprofile_vegietype_text")
        }
        
        // 버튼 누르고 나서 border 부분 오류가 있는데 어떻게 해결해야 하는지 모르겠음
        // 다크모드로 색상 변경하면 왜 갑자기 라이트모드일 때 색상이 border에 들어가는 건지 모르겠음..

        // Configure the view for the selected state
    }

}
