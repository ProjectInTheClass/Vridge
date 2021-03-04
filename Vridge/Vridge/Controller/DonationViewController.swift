//
//  DonationViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2021/03/04.
//

import UIKit

class DonationViewController: UIViewController {
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
//        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.post(name: Notification.Name("hidePostButton"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: - Selectors
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        view.backgroundColor = .yellow
    }

}

// MARK: - UIGestureRecognizerDelegate

extension DonationViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
