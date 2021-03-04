//
//  DonationViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2021/03/04.
//

import UIKit

class DonationViewController: UIViewController {
    
    // MARK: - Properties
    
    let customNavBar = CustomNavBar()
    
    let donationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("기부하기", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .yellow
        button.setDimensions(width: 120, height: 50)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(donationButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        NotificationCenter.default.post(name: Notification.Name("hidePostButton"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: - Selectors
    
    @objc func donationButtonDidTap() {
        print("DEBUG: make donation...")
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        view.backgroundColor = .white
        
        customNavBar.titleLabel.text = "개발자에게 기부하기"
        customNavBar.delegate = self
        
        view.addSubview(customNavBar)
        view.addSubview(donationButton)
        
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                            right: view.rightAnchor, height: 44)
        donationButton.center(inView: view)
    }

}

// MARK: - UIGestureRecognizerDelegate

extension DonationViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - CustomNavBarDelegate

extension DonationViewController: CustomNavBarDelegate {
    
    func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
}
