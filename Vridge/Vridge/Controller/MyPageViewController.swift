//
//  MyPageViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/04.
//

import UIKit
import AuthenticationServices

import Firebase
import BLTNBoard
import Lottie

private let cellID = "CellID"

class MyPageViewController: UIViewController {
    
    // MARK: - Properties

    let tableView = UITableView(frame: .zero, style: .grouped)
    let firstSectionMenu = ["공지사항", "브릿지란?", "앱 버전 1.0.0"]
    var secondSectionMenu = ["프로필 수정", "로그아웃"]
    
    var user: User? {
        didSet { tableView.reloadData(); configureUI() }
    }
    
    let customNavBar = CustomNavBar()
    
    lazy var backView : UIView = {
        let view = UIView()
        view.backgroundColor = user?.vegieType?.typeColor ?? .vridgeGreen
        return view
    }()
    
    lazy var indicator: UIActivityIndicatorView = {
        let ic = UIActivityIndicatorView()
        ic.color = .vridgeBlack
        ic.style = .large
        ic.center = view.center
        return ic
    }()
    
    let animationView: AnimationView = {
        let av = Lottie.AnimationView(name: loadingAnimation)
        av.isHidden = true
        av.loopMode = .loop
        return av
    }()
    
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
            self.performSignin()
        }
        
        rootItem.alternativeHandler = { _ in
            self.dismissBulletin()
        }
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.post(name: Notification.Name("showPostButton"), object: nil)
        fetchUser()
//        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    
    // MARK: - Selectors
    
    @objc func refetchUser() {
        print("DEBUG: try to refetch user")
        fetchUser()
    }
    
    
    // MARK: - API
    
    func fetchUser() {
        print("DEBUG: fetchiing user from myPage Veiw")
        guard let uid = Auth.auth().currentUser?.uid else {
            secondSectionMenu = ["로그인"]
            user = nil
            return
        }
        UserService.shared.fetchUser(uid: uid) { user in
            print("DEBUG: set user again")
            self.secondSectionMenu = ["프로필 수정", "로그아웃"]
            self.user = user
            self.configureUI()
        }
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        bulletinManager.backgroundColor = UIColor(named: "color_mypage_myPostCountBoxBg") ?? .white
        view.addSubview(backView)
        view.addSubview(tableView)
        
        view.addSubview(animationView)
        animationView.center(inView: view)
        animationView.setDimensions(width: 100, height: 100)
        animationView.contentMode = .scaleAspectFill
        
        
        view.backgroundColor = UIColor(named: viewBackgroundColor)
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MenuCell.self, forCellReuseIdentifier: cellID)
//        tableView.tableFooterView = UIView()
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
                         right: view.rightAnchor)
        backView.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                        height: view.frame.height / 2)
        backView.backgroundColor = user?.vegieType?.typeColor ?? .vridgeGreen
        
        let topHeader = MyPageTopHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 265),
                                            user: user)
        tableView.tableHeaderView = topHeader
        topHeader.usernameLabel.text = user?.username ?? "로그인이 필요해요"
        topHeader.delegate = self
        topHeader.backgroundColor = UIColor(named: viewBackgroundColor)
        
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


extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return firstSectionMenu.count
        default: return secondSectionMenu.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MenuCell
        
        switch indexPath.section {
        case 0: cell.menuName.text = firstSectionMenu[indexPath.row]
        default: cell.menuName.text = secondSectionMenu[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let header = FirstSectionHeader()
            header.sectionLabel.text = "기본 정보"
            return header
        default:
            let header = SecondSectionHeader()
            header.sectionLabel.text = "설정"
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            
            switch indexPath.row {
            case 0:
                let controller = NoticeViewController()
                navigationController?.pushViewController(controller, animated: true)
                
            case 1: // case 0 처럼 화면 이동 코드를 작성하면 됨.
                let controller = AboutVridgeViewController()
                navigationController?.pushViewController(controller, animated: true)
                
            case 2:
                let alert = UIAlertController(title: versionCheckTitle, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: confirm, style: .default, handler: nil))
                self.present(alert, animated: true)
                
            default: print("DEBUG: error")
            }
            
        } else {
            
            if Auth.auth().currentUser == nil {
                let loginController = LoginViewController()
                loginController.modalPresentationStyle = .fullScreen
                present(loginController, animated: true, completion: nil)
                
            } else {
                
                switch indexPath.row {
                case 0:
                    guard let user = user else { return }
                    let controller = EditProfileViewController(user: user)
                    navigationController?.pushViewController(controller, animated: true)
                    fetchUser()
                case 1:
                    let alert = UIAlertController(title: logOutTitle, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: logOutAnswer, style: .destructive, handler: { action in
                        AuthService.shared.logOut(viewController: self)
                        self.tableView.reloadData()
                    }))
                    alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                    
                default: print("DEBUG: error")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 28
        default: return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}


extension MyPageViewController: MyPageTopHeaderViewDelegate {
    
    func seeMyPostButtonTapped() {
        
        if Auth.auth().currentUser == nil {
//            let viewModel = ActionSheetViewModel()
//            present(viewModel.pleaseLogin(self), animated: true, completion: nil)
            bulletinManager.showBulletin(above: self)
        } else {
            let controller = MyPostViewController()
            navigationController?.pushViewController(controller, animated: true)
        }
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


extension MyPageViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    
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
                    print("DEBUG: logged in and update home tab")
                    
                    guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
                    guard let tab = window.rootViewController as? MainTabBarController else { return }
                    
                    tab.fetchUser()
                }
                
                
                // 이 곳을 바꿔보자 Auth Service 안에서 lottie 넣기.
                
                
                
                self.secondSectionMenu = ["프로필 수정", "로그아웃"]
                self.animationView.isHidden = false
                self.animationView.play()
                
                return
            }
//             handle if user hasn't registered...
            
            let firstName = name.givenName ?? ""
            let familyName = name.familyName ?? ""
            let username = familyName + firstName
//            AuthService.shared.signInNewUser(viewController: self, credential: credential,
//                                             email: email, username: username)
            
            print("DEBUG: logged in and update home tab")
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            guard let tab = window.rootViewController as? MainTabBarController else { return }
            
            tab.fetchUser()
            print("DEBUG: New user is '\(username)'")
            
            return
        }
    }
}
