//
//  LoginViewController.swift
//  CumtomLoginDemo
//
//  Created by Kang Mingu on 2020/09/05.
//  Copyright © 2020 Kang Mingu. All rights reserved.
//

import UIKit
import FirebaseAuth
import AuthenticationServices

class LoginViewController: UIViewController {
    
    // MARK: - Properties

    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var pwTf: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    let signUpButton: UIButton = {
        let butt = UIButton(type: .system)
        butt.setTitle("Sign Up", for: .normal)
        butt.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return butt
    }()
    
    let appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
        return button
    }()
    
    let indicator = UIActivityIndicatorView()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTf.text = "1@2.com"
        pwTf.text = "12345678"
        
        configureUI()
    }
    
    
    // MARK: - Selector
    
    @objc func handleAppleLogin() {
        indicator.startAnimating()
        performSignin()
    }
    
    @objc func handleSignUp() {
        let vc = SignUpViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: - Helper
    
    func performSignin() {
        
        let request = createAppleIdRequest()
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        
        authorizationController.performRequests()
        
    }
    
    func validateField() -> String? {
        
        if emailTf.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || pwTf.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "fill in all fields."
        }
        
        return nil
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        
        indicator.startAnimating()
        
        // validate textfield
        let error = validateField()
        
        if error != nil {
            
            showError(error!)
            indicator.stopAnimating()
            
        } else {
            
            let email = emailTf.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pw = pwTf.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().signIn(withEmail: email, password: pw) { (result, err) in
                
                if let err = err {
                    self.indicator.stopAnimating()
                    self.showError(err.localizedDescription)
                    print(err.localizedDescription)
                    
                } else {
                    
                    print("nice! you're now signed in as \(email), uid is \(result?.user.uid ?? "none")")
                    self.transitionToHome()
                    Sharing.shared.userMail = result?.user.email as! String
                }
                
            }
            
        }
        
    }
    
    func configureUI() {
        
        view.addSubview(signUpButton)
        
        signUpButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 50)
        
        view.addSubview(appleLoginButton)
        appleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appleLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appleLoginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 50),
        
        ])
        
        errorLabel.alpha = 0
        errorLabel.numberOfLines = 0
        
        view.addSubview(indicator)
        
        indicator.center = view.center
        indicator.style = .large
        indicator.hidesWhenStopped = true
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
    
    func showError(_ message: String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func transitionToHome() {
        
        let vc = HomeViewController()
        navigationController?.pushViewController(vc, animated: true)
        indicator.stopAnimating()
    }
    
    
   // Adapted from https://firebase.google.com/docs/auth/ios/apple?hl=ko
    
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
            
            Auth.auth().signIn(with: credential) { (result, error) in
                
                if let user = result?.user {
                    self.transitionToHome()
                    print("nice! you're now signed in as \(user.uid), email: \(user.email ?? "unknown")")
                    self.indicator.stopAnimating()
                }
            }
        }
    }
    
    
    
}
