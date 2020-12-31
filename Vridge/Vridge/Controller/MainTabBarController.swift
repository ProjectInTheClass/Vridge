//
//  TabBarController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/02.
//

import UIKit
import AuthenticationServices

import Firebase
import BLTNBoard
import Lottie

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
        
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowOffset = CGSize(width: 0, height: 0)
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowRadius = 12
        
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
    
        rootItem.actionButtonTitle = "Apple로 계속하기"
        rootItem.appearance.actionButtonTitleColor = .white
        rootItem.appearance.actionButtonColor = .black
        rootItem.appearance.actionButtonCornerRadius = 8
        
        rootItem.requiresCloseButton = false
        
        rootItem.alternativeButtonTitle = "그냥 둘러보기"
        rootItem.appearance.alternativeButtonTitleColor = .vridgeGreen
        
        rootItem.actionHandler = { _ in
//            self.showLoginView()
            self.performSignin()
        }
        
        rootItem.alternativeHandler = { _ in
            self.dismissBulletin()
        }
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    let animationView: AnimationView = {
        let av = Lottie.AnimationView(name: loadingAnimation)
        av.loopMode = .loop
        av.isHidden = true
        return av
    }()
    
    lazy var indicator: UIActivityIndicatorView = {
        let ic = UIActivityIndicatorView()
        ic.color = .vridgeBlack
        ic.style = .large
        ic.center = view.center
        return ic
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(1)
        
        configure()
        authenticateAndConfigureUI()
        
        view.addSubview(animationView)
        animationView.center(inView: view)
        animationView.setDimensions(width: 100, height: 100)
        animationView.contentMode = .scaleAspectFill
    }
    
    
    // MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
            print("DEBUG: user update!")
        }
    }
    
    func authenticateAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = IntroViewController()
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            
            AuthService.shared.checkIfUserHasUsername { hasUsername in
                if hasUsername {
                    self.fetchUser()
                } else {
                    let selectTypeController = SelectTypeViewController()
                    let nav = UINavigationController(rootViewController: selectTypeController)
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    // MARK: - Selectors
    
    @objc func handleButtonTapped() {
        
        let actionSheetViewModel = ActionSheetViewModel()
        
        if Auth.auth().currentUser == nil {
            bulletinManager.backgroundColor = UIColor(named: "color_mypage_myPostCountBoxBg") ?? .white
            bulletinManager.showBulletin(above: self)
            
        } else {
        
            let controller = PostingViewController(config: .post)
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
        
//        let controller = IntroViewController()
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
    
    @objc func refetchPosts() {
        fetchUser()
        
        print("DEBUG: fetch user again and pass data to home vc")
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
        view.addSubview(indicator)
        indicator.center = view.center
        
        postButton.centerX(inView: view)
        postButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 0)
        postButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        postButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
        postButton.layer.cornerRadius = 64 / 2
        
        NotificationCenter.default.addObserver(self, selector: #selector(hidePostButton),
                                               name: Notification.Name("hidePostButton"),
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showPostButton),
                                               name: Notification.Name("showPostButton"),
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refetchPosts),
                                               name: Notification.Name("refetchPosts"),
                                               object: nil)
    }
    
    func showLoginView() {
        
        bulletinManager.dismissBulletin(animated: true)
        
        print("DEBUG: show login view")
        let controller = IntroViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func dismissBulletin() {
        bulletinManager.dismissBulletin(animated: true)
    }
    
    func performSignin() {
        bulletinManager.dismissBulletin(animated: true)
        
        let request = createAppleIdRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        authorizationController.performRequests()
    }
    
    func createAppleIdRequest() -> ASAuthorizationAppleIDRequest {
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        
        return request
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
}

// MARK: - IntroViewControllerDelegate

extension MainTabBarController: IntroViewControllerDelegate {
    
    func userLogout() {
        print("DEBUG: handle log out man")
        do {
            try Auth.auth().signOut()
            dismiss(animated: true) {
                self.user = nil
                let nav = UINavigationController(rootViewController: IntroViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } catch (let err) {
            print("DEBUG: FAILED LOG OUT with error \(err.localizedDescription)")
        }
    }
    
}

// MARK: - HomeViewControllerDelgate

extension MainTabBarController: HomeViewControllerDelgate {
    
    func updateUsers() {
        fetchUser()
        print("DEBUG: delegates passed to main")
    }
    
}

// MARK: - PostingViewControllerDelegate

extension MainTabBarController: PostingViewControllerDelegate {
    
    func fetchUserAgain() {
        fetchUser()
    }
    
}


// MARK: - Apple Login Method

import CryptoKit

// Unhashed nonce.
fileprivate var currentNonce: String?

@available(iOS 13, *)
private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
    }.joined()
    
    return hashString
}


extension MainTabBarController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("INVALID STATE : a login callback was received, but no request sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            guard let email = appleIDCredential.email, let name = appleIDCredential.fullName else {
                
                // handle if user already once registered... or ex user rejoining...
                
                AuthService.shared.loginExistUser(viewController: self, animationView: animationView, credential: credential, bulletin: true) { user in
                    print("DEBUG: logged in and update home tab")
                    
                    guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
                    guard let tab = window.rootViewController as? MainTabBarController else { return }
                    
                    tab.fetchUser()
                }
                
                
                
                // 이 곳을 바꿔보자 Auth Service 안에서 lottie 넣기.
                
                return
            }
//             handle if user hasn't registered...
            
            let firstName = name.givenName ?? ""
            let familyName = name.familyName ?? ""
            let username = familyName + firstName
            AuthService.shared.signInNewUser(viewController: self, indicator: animationView, credential: credential,
                                             email: email, bulletin: true)
            
            print("DEBUG: logged in and update home tab")
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            guard let tab = window.rootViewController as? MainTabBarController else { return }
            
            tab.fetchUser()
            print("DEBUG: New user is '\(username)'")
            
            return
        }
    }
}



