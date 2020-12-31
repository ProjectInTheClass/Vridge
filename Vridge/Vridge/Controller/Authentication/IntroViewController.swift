//
//  IntroViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/06.
//

import UIKit

import AuthenticationServices
import Firebase
import Lottie

protocol IntroViewControllerDelegate: class {
    func userLogout()
}

class IntroViewController: UIViewController {
    
    // MARK: - Properties
    
    var indicator: UIActivityIndicatorView = {
        let idc = UIActivityIndicatorView(style: .large)
        idc.color = .black
        idc.hidesWhenStopped = true
        return idc
    }()
    
    weak var delegate: IntroViewControllerDelegate?
    
//    let appleLoginButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
//        button.backgroundColor = UIColor(named: "color_all_button_normal")
//        button.layer.cornerRadius = 8
//        button.setTitle("Apple로 계속하기", for: .normal)
//        button.titleLabel?.font = UIFont.SFSemiBold(size: 15)
//        button.setTitleColor(UIColor(named: "color_all_viewBackground"), for: .normal)
//
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "person.fill")
//        imageView.tintColor = UIColor(named: "color_all_viewBackground")
//        button.addSubview(imageView)
//        imageView.centerY(inView: button, leftAnchor: button.leftAnchor, paddingLeft: 23.5)
//        return button
//    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.backgroundColor = .vridgeGray
        button.layer.cornerRadius = 8
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont.SFSemiBold(size: 15)
        button.setTitleColor(UIColor(named: "color_all_viewBackground"), for: .normal)
        return button
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "다양한 사람들과 함께하는 나의 첫 채식 기록장"
        label.textColor = UIColor(named: "color_splash_caption")
        label.font = UIFont.SFRegular(size: 14)
        return label
    }()
    
    let emailContainerImage = UIImage(systemName: "envelope")
    let pwContainerImage = UIImage(systemName: "lock")
    
    private lazy var emailContainerView: UIView = {
        let image = emailContainerImage
        let view = Utilities().inputContainerView(withImage: image!, textField: emailTf, color: .lightGray)
        return view
    }()
    
    private lazy var pwContainerView: UIView = {
        let image = pwContainerImage
        let view = Utilities().inputContainerView(withImage: image!, textField: passwordTf, color: .lightGray)
        return view
    }()
    
    private let emailTf: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Email")
        return tf
    }()
    
    private let passwordTf: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
//    private let logOutButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Log out", for: .normal)
//        button.addTarget(self, action: #selector(handleLogOut), for: .touchUpInside)
//        return button
//    }()
    
//    private let browseButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("그냥 둘러보기", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.font = UIFont.SFSemiBold(size: 15)
//        button.addTarget(self, action: #selector(handleBrowse), for: .touchUpInside)
//        button.backgroundColor = UIColor.rgb(red: 5, green: 213, blue: 125)
//        button.layer.cornerRadius = 8
//        return button
//    }()
    
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
    
    let joinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.vridgeBlack, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleJoin), for: .touchUpInside)
        button.setDimensions(width: 82, height: 43)
        return button
    }()
    
    let findPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setTitleColor(.vridgeBlack, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleFindPassword), for: .touchUpInside)
        button.setDimensions(width: 106, height: 43)
        return button
    }()
    
    let browseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("둘러보기", for: .normal)
        button.setTitleColor(.vridgeBlack, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(handleBrowse), for: .touchUpInside)
        button.setDimensions(width: 82, height: 43)
        return button
    }()
    
    let buttonStackBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    lazy var recognizer = UITapGestureRecognizer(target: self, action: #selector(handleKeyboardDown))
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "color_all_viewBackground")
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    
    // MARK: - Selectors
    
    @objc func handleKeyboardDown() {
        view.endEditing(true)
    }
    
    @objc func handleJoin() {
        print("DEBUG: handle join...")
    }
    
    @objc func handleFindPassword() {
        print("DEBUG: handle find password...")
    }
    
    @objc func handleBrowse() {
        dismiss(animated: true, completion: nil)
        print("DEBUG: handle browse...")
    }
    
    @objc func handleAppleLogin() {
        performSignin()
    }
    
    @objc func handleLogin() {
        print("DEBUG: handle login...")
    }
    
    @objc func handleLogOut() {
        delegate?.userLogout()
    }
    
    
    // MARK: - Helpers
    
    func disableButtons() {
//        appleLoginButton.isEnabled = false
        loginButton.isEnabled = false
        findPasswordButton.isEnabled = false
        browseButton.isEnabled = false
    }
    
    func configureUI() {
        
        view.addGestureRecognizer(recognizer)
        
        emailTf.delegate = self
        passwordTf.delegate = self
        
        let animationView = Lottie.AnimationView(name: "loading")
        view.addSubview(backgroundImageView)
        backgroundImageView.addConstraintsToFillView(view)
        view.addSubview(animationView)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, pwContainerView])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .equalSpacing
        
        let buttonStack = UIStackView(arrangedSubviews: [joinButton, findPasswordButton, browseButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 1
        buttonStack.alignment = .center
        stack.distribution = .equalSpacing
        
        animationView.play()
        
        view.addSubview(loginButton)
        view.addSubview(captionLabel)
//        view.addSubview(logOutButton)
        view.addSubview(logoImageView)
        view.addSubview(indicator)
        view.addSubview(stack)
        view.addSubview(buttonStackBackgroundView)
        view.addSubview(buttonStack)
        
        indicator.hidesWhenStopped = true
        indicator.style = .large
        
        logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)
        logoImageView.centerX(inView: view)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 48, paddingLeft: 32, paddingRight: 32)
//        indicator.anchor(bottom: logoImageView.topAnchor, paddingBottom: 12)
//        indicator.centerX(inView: view)
        indicator.center(inView: view)
        buttonStackBackgroundView.anchor(top: loginButton.bottomAnchor, paddingTop: 29, width: 140, height: 18)
        buttonStackBackgroundView.centerX(inView: view)
        buttonStack.anchor(top: loginButton.bottomAnchor, paddingTop: 16)
        buttonStack.centerX(inView: view)
        
        
        view.addSubview(animationView)
        animationView.center(inView: view)
        animationView.setDimensions(width: 100, height: 100)
        animationView.contentMode = .scaleAspectFill
        
        loginButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                           paddingTop: 24, paddingLeft: 36, paddingRight: 32, height: 48)
        
        captionLabel.anchor(top: logoImageView.bottomAnchor, paddingTop: 8)
        captionLabel.centerX(inView: view)
//        logOutButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor,
//                            paddingTop: 40, paddingRight: 40)
        
        animationView.center(inView: view)
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        
    }
    
    // Apple Login 현재 사용하지 않음...
    
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

extension IntroViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTf {
            print("DEBUG: email")
            // emailTf의 언더 라인 색을 vridge Green 으로 바꾸기
        } else {
            print("DEBUG: pw")
            // pwTf의 언더 라인 색을 vridge Green 으로 바꾸기
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTf {
            print("DEBUG: email change done")
            // emailTf의 언더 라인 색을 다시 회색 으로 바꾸기
        } else {
            print("DEBUG: pw change done")
            // pwTf의 언더 라인 색을 다시 회색 으로 바꾸기
        }
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


extension IntroViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    
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
                    
                    self.disableButtons()
                    self.indicator.startAnimating()
                }
                disableButtons()
                indicator.startAnimating()
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
            
            disableButtons()
            indicator.startAnimating()
            
            return
        }
    }
}
