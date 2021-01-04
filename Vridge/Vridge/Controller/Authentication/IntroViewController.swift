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
        button.titleLabel?.font = UIFont.SFSemiBold(size: 16)
//        button.setTitleColor(UIColor(named: viewBackgroundColor), for: .normal)
        button.tintColor = UIColor(named: viewBackgroundColor)
        button.isEnabled = false
        return button
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "다양한 사람들과 함께하는 나의 첫 채식 기록장"
        label.textColor = UIColor(named: "color_splash_caption")
        label.font = UIFont.SFRegular(size: 14)
        return label
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = UIImage(systemName: "envelope")
        let view = Utilities().inputContainerView(textField: emailTf, color: .lightGray)
        return view
    }()
    
    let emailContainerUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .vridgeGreen
        view.isHidden = true
        return view
    }()
    
    private lazy var pwContainerView: UIView = {
        let image = UIImage(systemName: "lock")
        let view = Utilities().inputContainerView(textField: passwordTf, color: .lightGray)
        return view
    }()
    
    let pwContainerUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .vridgeGreen
        view.isHidden = true
        return view
    }()
    
    private let emailTf: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "이메일")
        return tf
    }()
    
    private let passwordTf: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "비밀번호")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let wrongPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "메일 주소 혹은 비밀번호가 올바르지 않아요."
        label.textColor = .red
        label.font = UIFont.SFRegular(size: 14)
        label.isHidden = true
        return label
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
        button.setTitleColor(UIColor(named: allTextColor), for: .normal)
        button.backgroundColor = UIColor(named: viewBackgroundColor)
        button.addTarget(self, action: #selector(handleJoin), for: .touchUpInside)
        button.setDimensions(width: 82, height: 43)
        return button
    }()
    
    let findPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("비밀번호 찾기", for: .normal)
        button.setTitleColor(UIColor(named: allTextColor), for: .normal)
        button.backgroundColor = UIColor(named: viewBackgroundColor)
        button.addTarget(self, action: #selector(handleFindPassword), for: .touchUpInside)
        button.setDimensions(width: 106, height: 43)
        return button
    }()
    
    let browseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("둘러보기", for: .normal)
        button.setTitleColor(UIColor(named: allTextColor), for: .normal)
        button.backgroundColor = UIColor(named: viewBackgroundColor)
        button.addTarget(self, action: #selector(handleBrowse), for: .touchUpInside)
        button.setDimensions(width: 82, height: 43)
        return button
    }()
    
    let buttonStackBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: allTextColor)
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
        let controller = JoiningViewController()
        navigationController?.pushViewController(controller, animated: true)
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
        animationView.isHidden = false
        animationView.play()
        AuthService.shared.loginWithEmail(email: emailTf.text!, password: passwordTf.text!) { (result, error) in
            
            if error != nil {
                self.wrongPasswordLabel.isHidden = false
                self.animationView.stop()
                self.animationView.isHidden = true
                return
            }
            
            // if 유저네임이 없을 때 = SelectTypeViewController로 push.
            
            AuthService.shared.checkIfUserHasUsername { hasUsername in
                if hasUsername {
//                    self.fetchUser()
                    self.dismiss(animated: true) {
                        self.animationView.stop()
                        self.animationView.isHidden = true
                    }
                } else {
                    print("DEBUG: this gus has no username man")
                    let selectTypeController = SelectTypeViewController()
                    self.navigationController?.pushViewController(selectTypeController, animated: true)
                }
            }
            
//            print("DEBUG: username = \(REF_USERS.child(uid).value(forKey: "username"))")
            
            // 유저네임 있는 정상적인 로그인일 때는 dismiss.
        }
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
        
//        let animationView = Lottie.AnimationView(name: "loading")
        view.addSubview(backgroundImageView)
        backgroundImageView.addConstraintsToFillView(view)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, pwContainerView])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .equalSpacing
        
        let buttonStack = UIStackView(arrangedSubviews: [joinButton, findPasswordButton, browseButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 1
        buttonStack.alignment = .center
        stack.distribution = .equalSpacing
        
        view.addSubview(loginButton)
        view.addSubview(captionLabel)
        view.addSubview(logoImageView)
        view.addSubview(indicator)
        view.addSubview(stack)
        view.addSubview(buttonStackBackgroundView)
        view.addSubview(buttonStack)
        view.addSubview(emailContainerUnderLine)
        view.addSubview(pwContainerUnderLine)
        view.addSubview(wrongPasswordLabel)
        
//        indicator.hidesWhenStopped = true
//        indicator.style = .large
        
        logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)
        logoImageView.centerX(inView: view)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 48, paddingLeft: 32, paddingRight: 32)
        wrongPasswordLabel.anchor(top: emailContainerView.bottomAnchor, paddingTop: 8)
        wrongPasswordLabel.centerX(inView: view)
//        indicator.anchor(bottom: logoImageView.topAnchor, paddingBottom: 12)
//        indicator.centerX(inView: view)
//        indicator.center(inView: view)
        buttonStackBackgroundView.anchor(top: loginButton.bottomAnchor, paddingTop: 29, width: 140, height: 18)
        buttonStackBackgroundView.centerX(inView: view)
        buttonStack.anchor(top: loginButton.bottomAnchor, paddingTop: 16)
        buttonStack.centerX(inView: view)
        
        view.addSubview(animationView)
        animationView.centerX(inView: view)
        animationView.anchor(top: captionLabel.bottomAnchor, paddingTop: 36)
        animationView.setDimensions(width: 100, height: 100)
        animationView.contentMode = .scaleAspectFill
        
        loginButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                           paddingTop: 24, paddingLeft: 36, paddingRight: 32, height: 48)
        
        captionLabel.anchor(top: logoImageView.bottomAnchor, paddingTop: 8)
        captionLabel.centerX(inView: view)
//        logOutButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, right: view.rightAnchor,
//                            paddingTop: 40, paddingRight: 40)
        
        emailContainerUnderLine.anchor(left: emailContainerView.leftAnchor,
                                       bottom: emailContainerView.bottomAnchor,
                                       right: emailContainerView.rightAnchor, paddingLeft: 8, height: 1)
        pwContainerUnderLine.anchor(left: pwContainerView.leftAnchor,
                                       bottom: pwContainerView.bottomAnchor,
                                       right: pwContainerView.rightAnchor, paddingLeft: 8, height: 1)
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
            emailContainerUnderLine.isHidden = false
        } else {
            pwContainerUnderLine.isHidden = false
        }
        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        wrongPasswordLabel.isHidden = true
        if emailTf.text!.count > 4 && passwordTf.text!.count > 5 {
            loginButton.backgroundColor = .vridgeGreen
            loginButton.isEnabled = true
        } else {
            loginButton.backgroundColor = .vridgeGray
            loginButton.isEnabled = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTf {
            emailContainerUnderLine.isHidden = true
        } else {
            pwContainerUnderLine.isHidden = true
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
