//
//  LoginViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/06.
//

import UIKit

import AuthenticationServices
import Firebase
import Lottie

protocol LoginViewControllerDelegate: class {
    func userLogout()
}

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    var indicator: UIActivityIndicatorView = {
        let idc = UIActivityIndicatorView(style: .large)
        idc.color = .black
        idc.hidesWhenStopped = true
        return idc
    }()
    
    weak var delegate: LoginViewControllerDelegate?
    
//    let appleLoginButton: ASAuthorizationAppleIDButton = {
//        let button = ASAuthorizationAppleIDButton()
//        button.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
//        button.backgroundColor = .yellow
//        return button
//    }()
    
    let appleLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
        button.backgroundColor = UIColor(named: "color_all_button_normal")
        button.layer.cornerRadius = 8
        button.setTitle("Apple ID로 시작하기", for: .normal)
        button.titleLabel?.font = UIFont.SFSemiBold(size: 15)
        button.setTitleColor(UIColor(named: "color_all_viewBackground"), for: .normal)
        
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = UIColor(named: "color_all_viewBackground")
        button.addSubview(imageView)
        imageView.centerY(inView: button, leftAnchor: button.leftAnchor, paddingLeft: 23.5)
        return button
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "다양한 사람들과 함께하는 나의 첫 채식 기록장"
        label.textColor = UIColor(named: "color_splash_caption")
        label.font = UIFont.SFRegular(size: 14)
        return label
    }()
    
//    private let logOutButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Log out", for: .normal)
//        button.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
//        return button
//    }()
    
    private let browseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("그냥 둘러보기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.SFSemiBold(size: 15)
        button.addTarget(self, action: #selector(handleBrowse), for: .touchUpInside)
        button.backgroundColor = UIColor.rgb(red: 5, green: 213, blue: 125)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let animationView: AnimationView = {
        let av = Lottie.AnimationView(name: loadingAnimation)
        av.isHidden = true
        av.loopMode = .loop
        return av
    }()
    
    let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Vridge_logo")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(indicator)
        indicator.center = view.center
        
        view.backgroundColor = UIColor(named: "color_all_viewBackground")
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = true
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(true)
//        
//        navigationController?.navigationBar.isHidden = false
//    }
    
    
    // MARK: - Selectors
    
    @objc func handleBrowse() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleAppleLogin() {
        performSignin()
    }
    
    @objc func handleLogOut() {
        delegate?.userLogout()
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        let animationView = Lottie.AnimationView(name: "loading")
        view.addSubview(backgroundImageView)
        backgroundImageView.addConstraintsToFillView(view)
        view.addSubview(animationView)
        
        animationView.play()
        
        view.addSubview(appleLoginButton)
        view.addSubview(browseButton)
        view.addSubview(captionLabel)
//        view.addSubview(logOutButton)
        view.addSubview(logoImageView)
        logoImageView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                             paddingTop: 286, paddingLeft: 103, paddingRight: 102)
        
        view.addSubview(animationView)
        animationView.center(inView: view)
        animationView.setDimensions(width: 100, height: 100)
        animationView.contentMode = .scaleAspectFill
        
        browseButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.rightAnchor, paddingLeft: 36, paddingBottom: 47, paddingRight: 36,
                            height: 48)
        appleLoginButton.anchor(left: view.leftAnchor, bottom: browseButton.topAnchor, right: view.rightAnchor,
                                paddingLeft: 36, paddingBottom: 12, paddingRight: 36, height: 48)
        
        captionLabel.anchor(top: logoImageView.bottomAnchor, paddingTop: 8)
        captionLabel.centerX(inView: view)
//        logOutButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor,
//                            paddingTop: 40, paddingRight: 40)
        
        animationView.center(inView: view)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        
        
    }
    
    func performSignin() {
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


extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    
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
                
                AuthService.shared.loginExistUser(viewController: self, animationView: animationView, credential: credential) { user in
//                    self.indicator.startAnimating()
                    print("DEBUG: logged in and update home tab")
                    guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
                    guard let tab = window.rootViewController as? MainTabBarController else { return }
//                    self.indicator.stopAnimating()
                    
                    tab.fetchUser()
                }
                
                return
            }
//             handle if user hasn't registered...
            
            let firstName = name.givenName ?? ""
            let familyName = name.familyName ?? ""
            let username = familyName + firstName
            AuthService.shared.signInNewUser(viewController: self, indicator: animationView, credential: credential,
                                             email: email)
            
            print("DEBUG: logged in and update home tab")
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            guard let tab = window.rootViewController as? MainTabBarController else { return }
            
            tab.fetchUser()
            print("DEBUG: New user is '\(username)'")
            
            return
        }
    }
}
