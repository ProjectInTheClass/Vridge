//
//  MyPostViewController.swift
//  MyPageView
//
//  Created by 김루희 on 2020/10/29.
//

import UIKit

class MyPostViewController: UIViewController {

    // MARK: - Properties
    
    let customNavBar = CustomNavBar()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavBar.titleLabel.text = "내 게시글"
        configureUI()
        view.backgroundColor = .yellow
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.post(name: Notification.Name("hidePostButton"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tabBarController?.tabBar.isHidden = false
    }
    // MARK: - Helpers
        
    func configureUI() {
        
        customNavBar.delegate = self
        
        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(1)
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "btnBack")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "btnBack")
        
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 44)
    }

}

extension MyPostViewController : CustomNavBarDelegate {
    func backButtonDidTap() {
        navigationController?.popViewController(animated: true) //뒤로 간다는 것
    }
    
    
}
