//
//  TabBarController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/02.
//

import UIKit

import Firebase

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    var user: [User]? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let home = nav.viewControllers.first as? HomeViewController else { return }
            
            home.user = user
        }
    }
    
    private lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.imageView?.clipsToBounds = true
        button.backgroundColor = .systemGreen
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.tintColor = .red
        button.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(1)
        
        fetchUser()

        view.addSubview(postButton)
        
        postButton.centerX(inView: view)
        postButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 8)
        postButton.widthAnchor.constraint(equalToConstant: 65).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
        postButton.layer.cornerRadius = 65 / 2
    }
    
    
    // MARK: - Selectors
    
    @objc func handleButtonTapped() {
        let controller = PostingViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        
//        let nav = LoginViewController()
        
        present(nav, animated: true, completion: nil)
    }
    
    
    // MARK: - Helpers
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        UserService.shared.fetchUser(uid: uid) { user in
//            print("DEBUG: What the heck users are \(user)")
            self.user?.append(user)
        }
    }

}
