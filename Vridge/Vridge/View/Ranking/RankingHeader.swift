//
//  RankingHeader.swift
//  Vridge_Pages
//
//  Created by Kang Mingu on 2020/10/09.
//

import UIKit

class RankingHeader: UIView {
    
    // MARK: - Properties
    
    var viewModel = RankingViewModel()
    
    lazy var profileImage2 = viewModel.profileImage2
    lazy var profileImage1 = viewModel.profileImage1View
    lazy var profileImage3 = viewModel.profileImage3
    
    lazy var username2 = viewModel.username2
    lazy var username1 = viewModel.username1
    lazy var username3 = viewModel.username3
    
    lazy var type2 = viewModel.type2
    lazy var type1 = viewModel.type1
    lazy var type3 = viewModel.type3
    
    lazy var point2 = viewModel.point2
    lazy var point1 = viewModel.point1
    lazy var point3 = viewModel.point3
    
    lazy var saladImage2 = viewModel.pointImage2
    lazy var saladImage1 = viewModel.pointImage1
    lazy var saladImage3 = viewModel.pointImage3
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        let imageWithPoint2 = UIStackView(arrangedSubviews: [saladImage2, point2])
        imageWithPoint2.spacing = 0
        imageWithPoint2.alignment = .center
        
        let imageWithPoint1 = UIStackView(arrangedSubviews: [saladImage1, point1])
        imageWithPoint1.spacing = 0
        imageWithPoint1.alignment = .center
        
        let imageWithPoint3 = UIStackView(arrangedSubviews: [saladImage3, point3])
        imageWithPoint3.spacing = 0
        imageWithPoint3.alignment = .center
        
        let userStack2 = UIStackView(arrangedSubviews: [profileImage2, username2,
                                                        type2, imageWithPoint2])
        userStack2.axis = .vertical
        userStack2.setCustomSpacing(14, after: profileImage2)
        userStack2.setCustomSpacing(3, after: username2)
        userStack2.setCustomSpacing(0, after: type2)
        userStack2.alignment = .center
        
        let userStack1 = UIStackView(arrangedSubviews: [profileImage1, username1,
                                                        type1, imageWithPoint1])
        userStack1.axis = .vertical
        userStack1.setCustomSpacing(14, after: profileImage1)
        userStack1.setCustomSpacing(3, after: username1)
        userStack1.setCustomSpacing(0, after: type1)
        userStack1.alignment = .center
        
        let userStack3 = UIStackView(arrangedSubviews: [profileImage3, username3,
                                                        type3, imageWithPoint3])
        userStack3.axis = .vertical
        userStack3.setCustomSpacing(14, after: profileImage3)
        userStack3.setCustomSpacing(3, after: username3)
        userStack3.setCustomSpacing(0, after: type3)
        userStack3.alignment = .center
        
        
        let stack = UIStackView(arrangedSubviews: [userStack2, userStack1, userStack3])
        stack.axis = .horizontal
        stack.spacing = 30
        stack.alignment = .bottom
        
        addSubview(stack)
        
        stack.centerX(inView: self, topAnchor: topAnchor, paddingTop: 30)
    }
    
}
