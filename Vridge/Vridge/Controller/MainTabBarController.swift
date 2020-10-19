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
    
    var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let home = nav.viewControllers.first as? HomeViewController else { return }
            home.delegates = self
            home.user = user
        }
    }
    
    private lazy var postButton: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icPost")
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleButtonTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(recognizer)
        return iv
    }()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(1)
        
        configure()
//        fetchUser()
        authenticateAndConfigureUI()
    }
    
    
    // MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    func authenticateAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginViewController()
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            fetchUser()
        }
    }
    
    
    
    // MARK: - Selectors
    
    @objc func handleButtonTapped() {
//        print("DEBUG: tapped!")
//        let controller = PostingViewController(config: .post)
//        controller.delegate = self
//        let nav = UINavigationController(rootViewController: controller)
//        nav.modalPresentationStyle = .fullScreen
        
        let controller = LoginViewController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        
//        let controller = TestViewController()
//        let nav = UINavigationController(rootViewController: controller)
        
        present(nav, animated: true, completion: nil)
    }
    
    @objc func hidePostButton() {
        postButton.isHidden = true
    }
    
    @objc func showPostButton() {
        postButton.isHidden = false
    }
    
    
    // MARK: - Helpers
    
    func configure() {
        view.addSubview(postButton)
        
        postButton.centerX(inView: view)
        postButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0)
        postButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        postButton.layer.cornerRadius = 64 / 2
        
        NotificationCenter.default.addObserver(self, selector: #selector(hidePostButton), name: Notification.Name("hidePostButton"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showPostButton), name: Notification.Name("showPostButton"), object: nil)
    }

}

extension MainTabBarController :LoginViewControllerDelegate {
    
    func userLogout() {
        print("DEBUG: handle log out man")
        do {
            try Auth.auth().signOut()
            dismiss(animated: true) {
                self.user = nil
                let nav = UINavigationController(rootViewController: LoginViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } catch (let err) {
            print("DEBUG: FAILED LOG OUT with error \(err.localizedDescription)")
        }
    }
        
}

extension MainTabBarController: HomeViewControllerDelgate {
    
    func updateUsers() {
        fetchUser()
        print("DEBUG: delegates passed to main")
    }
    
}

extension MainTabBarController: PostingViewControllerDelegate {
    
    func updateUser() {
        fetchUser()
        print("DEBUG: user update!")
        print("DEBUG: current point -== \(user?.point)")
    }
    
}



