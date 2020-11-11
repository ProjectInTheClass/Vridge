//
//  TabBarController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/02.
//

import UIKit

import Firebase
import BLTNBoard

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let home = nav.viewControllers.first as? HomeViewController else { return }
            
            guard let nav2 = viewControllers?[2] as? UINavigationController else { return }
            guard let myPage = nav2.viewControllers.first as? MyPageViewController else { return }
            
            home.delegates = self
            home.user = user
            myPage.user = user
        }
    }
    
    
    private let postButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setBackgroundImage(UIImage(named: "icPost"), for: .normal)
        btn.backgroundColor = .vridgeGreen
        btn.addTarget(self, action: #selector(handleButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    var descriptionAttributedString: NSAttributedString {
        let head = NSMutableAttributedString(string: "다양한 사람들과 함께 나의 첫 채식을\n즐겁게 챌린지 형식으로 시작해보세요!",
                                             attributes: [.font: UIFont.SFRegular(size: 14)!])
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 5
        head.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, head.length))
        return head
    }
    
    lazy var bulletinManager: BLTNItemManager = {
        let rootItem = BLTNPageItem(title: "브릿지 가입하기")

        rootItem.appearance.titleTextColor = UIColor(named: allTextColor) ?? .black
        rootItem.appearance.titleFontDescriptor = UIFont.SFBold(size: 24)?.fontDescriptor
        rootItem.appearance.titleFontSize = 24

        rootItem.descriptionText = "다양한 사람들과 함께 나의 첫 채식을\n즐겁게 챌린지 형식으로 시작해보세요!"
        rootItem.appearance.descriptionFontSize = 14
        rootItem.appearance.descriptionFontDescriptor = UIFont.SFRegular(size: 14)?.fontDescriptor
        rootItem.appearance.descriptionTextColor = UIColor(named: allTextColor) ?? .black
    
        rootItem.actionButtonTitle = "Apple ID로 시작하기"
        rootItem.appearance.actionButtonTitleColor = .white
        rootItem.appearance.actionButtonColor = .black
        rootItem.appearance.actionButtonCornerRadius = 8
        
        rootItem.requiresCloseButton = false
        
        rootItem.alternativeButtonTitle = "그냥 둘러볼래요"
        rootItem.appearance.alternativeButtonTitleColor = .vridgeGreen
        
        rootItem.actionHandler = { _ in
            self.showLoginView()
        }
        
        rootItem.alternativeHandler = { _ in
            self.dismissBulletin()
        }
        return BLTNItemManager(rootItem: rootItem)
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
            print("DEBUG: user update!")
            print("DEBUG: current point -== \(user.point)")
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
        
        let actionSheetViewModel = ActionSheetViewModel()
        
        if Auth.auth().currentUser == nil {
//            present(actionSheetViewModel.pleaseLogin(self), animated: true)
            bulletinManager.backgroundColor = UIColor(named: "color_mypage_myPostCountBoxBg") ?? .white
            bulletinManager.showBulletin(above: self)
            
            
        } else {
        
            let controller = PostingViewController(config: .post)
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
        
//        let controller = LoginViewController()
//        controller.delegate = self
//        let nav = UINavigationController(rootViewController: controller)
//        nav.modalPresentationStyle = .fullScreen
        
//        let controller = TestViewController()
//        let nav = UINavigationController(rootViewController: controller)
        
        present(nav, animated: true, completion: nil)
                }
    }
    
    @objc func hidePostButton() {
        postButton.isHidden = true
    }
    
    @objc func showPostButton() {
        postButton.isHidden = false
    }
    
    
    // MARK: - Helpers
    
    func templateNavController(_ rootViewController: UIViewController, image: UIImage?) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        
        return nav
    }
    
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
    
    func showLoginView() {
        
        bulletinManager.dismissBulletin(animated: true)
        
        print("DEBUG: show login view")
        let controller = LoginViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func dismissBulletin() {
        bulletinManager.dismissBulletin(animated: true)
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
    
    func fetchUserAgain() {
        fetchUser()
    }
    
}



