//
//  LoginViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/06.
//

import UIKit

import AuthenticationServices
import Firebase

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    let appleLoginButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.addTarget(self, action: #selector(handleAppleLogin), for: .touchUpInside)
        return button
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "이것은 임시 로그인 뷰입니다."
        label.textColor = .black
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        configureUI()
    }
    
    
    // MARK: - Selectors
    
    @objc func handleAppleLogin() {
        performSignin()
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        view.addSubview(appleLoginButton)
        view.addSubview(label)
        appleLoginButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                                paddingTop: 100, paddingLeft: 100, width: 100, height: 50)
        label.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10)
        label.centerX(inView: view)
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
            
            //            appleIDCredential.email
            
            // Check to see if the user has already registered,
            // if already registered => No updateChildValues...
            // else if => left user.... rejoining...
            // else => updateChildValues with default values.... sibal
            
            
            
            guard let email = appleIDCredential.email else {
                // if user already once registered...
                
                Auth.auth().signIn(with: credential) { (result, error) in
                    guard let uid = result?.user.uid else { return }
                    guard let email = result?.user.email else { return }
                    REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
                        
                        guard let dictionary = snapshot.value as? [String: AnyObject] else {
                            // Deleted account and rejoining
                            let values = ["uid": uid,
                                          "email": email,
                                          "point": 0] as [String: Any]
                            REF_USERS.child(uid).updateChildValues(values) { (err, ref) in
                                print("DEBUG: This user has deleted id, and trying to rejoin")
                                
                            }
                            return
                        }
                        guard let point = dictionary["point"] as? Int else { return }
                        
                        let values = ["uid": uid,
                                      "email": email,
                                      "point": point] as [String: Any]
                        
                        REF_USERS.child(uid).updateChildValues(values) { (err, ref) in
                            print("DEBUG: Existed user logged in.")
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
                return
            }
            // if user hasn't registered yet...
            Auth.auth().signIn(with: credential) { (result, error) in
                guard let uid = result?.user.uid else { return }
                
                let values = ["uid": uid,
                              "email": email,
                              "point": 0] as [String: Any]
                
                REF_USERS.child(uid).updateChildValues(values) { (err, ref) in
                    print("DEBUG: New user's email is \(email)")
                    print("DEBUG: New user logged in.")
                }
            }
            return
        }
    }
}
