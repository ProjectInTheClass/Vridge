//
//  TabBarController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/02.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - Properties
    
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

        view.addSubview(postButton)
        
        postButton.centerX(inView: view)
        postButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 8)
        postButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        postButton.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.2).isActive = true
        postButton.layer.cornerRadius = view.frame.width * 0.2 / 2
    }
    
    
    // MARK: - Selectors
    
    @objc func handleButtonTapped() {
        let controller = PostingViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    

    

}
