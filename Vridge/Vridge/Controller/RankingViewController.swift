//
//  RankingViewController.swift
//  Vridge_Pages
//
//  Created by Kang Mingu on 2020/10/09.
//

import UIKit
import AuthenticationServices

import Firebase
import BLTNBoard
import Lottie

private let cellID = "rankingCell"

class RankingViewController: UIViewController {
    
    // MARK: - Properties
    
    var user: User?
    
//    var totalUser: Int? {
//        didSet { fetchUserRanking() }
//    }
    
//    var totalMyTypeUser: Int? {
//        didSet { fetchMyTypeUserRanking(); print("DEBUG: total mytype user is \(totalMyTypeUser)") }
//    }
    
    private let topView = RankingCustomTopView()
    private let secondView = RankingSecondView()
    
    private var selectedFilter: RankingFilterOptions = .all {
        didSet { tableView.reloadData() }
    }
    
    private var allRank = [User]() {
        didSet { tableView.reloadData() }
    }
    
    private var myTypeRank = [User]() {
        didSet { tableView.reloadData() }
    }
    
    private var currentDataSource: [User] {
        switch selectedFilter {
        case .all: return allRank
        case .myType: return myTypeRank
        }
    }
    
    let animationView: AnimationView = {
        let av = Lottie.AnimationView(name: loadingAnimation)
        av.loopMode = .loop
        av.isHidden = true
        return av
    }()
    
    private let actionSheetViewModel = ActionSheetViewModel()
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
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
//            self.showLoginView()
            self.performSignin()
        }
        
        rootItem.alternativeHandler = { _ in
            self.dismissBulletin()
        }
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    
    // MARK: - Lifecycle
    
    init(user: User?) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
//        fetchTotalUser()
//        fetchTotalMyTypeUser()
        fetchUserRanking()
        fetchMyTypeUserRanking()
        
        view.addSubview(animationView)
        animationView.center(inView: view)
        animationView.setDimensions(width: 100, height: 100)
        animationView.contentMode = .scaleAspectFill
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        NotificationCenter.default.post(name: Notification.Name("hidePostButton"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
                
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - API
    
//    func fetchTotalUser() {
//        UserService.shared.fetchTotalUser { numberOfUsers in
//            self.totalUser = numberOfUsers
//        }
//    }
    
//    func fetchTotalMyTypeUser() {
//        if Auth.auth().currentUser == nil {
//            print("DEBUG: no user exist")
//        } else {
//            UserService.shared.fetchTotalMyTypeUser(myType: (user?.vegieType)!) { numberOfMyTypeUsers in
//                self.totalMyTypeUser = numberOfMyTypeUsers
//            }
//        }
//    }
    
    func fetchUserRanking() {
        UserService.shared.fetchRanking { users in
//            if users.count == self.totalUser {
//                self.allRank = users.sorted(by: { $0.point > $1.point })
                self.allRank = users
//            }
        }
    }
    
    func fetchMyTypeUserRanking() {
        if Auth.auth().currentUser == nil {
            print("DEBUG: no user exist2")
        } else {
            UserService.shared.fetchMyTypeRanking(myType: (user?.vegieType)!) { users in
//                if users.count == self.totalMyTypeUser {
                    print("DEBUG: user type is ===== \(self.user?.vegieType?.rawValue)")
                    self.myTypeRank = users
//                }
            }
        }
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        
        view.backgroundColor = UIColor(named: headerBackgroundColor)
        
        view.addSubview(topView)
        view.addSubview(secondView)
        view.addSubview(tableView)
        
        topView.delegate = self
        secondView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(RankingCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = UIColor(named: "color_ranking_bottomBg")
        
        topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                       right: view.rightAnchor, height: 56)
        secondView.anchor(top: topView.bottomAnchor, left: view.leftAnchor,
                          right: view.rightAnchor, height: 44)
        tableView.anchor(top: secondView.bottomAnchor, left: view.leftAnchor,
                         bottom: view.bottomAnchor, right: view.rightAnchor)
        
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

// MARK: - UITableViewDataSource/Delegate

extension RankingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDataSource.count - 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID,
                                                 for: indexPath) as! RankingCell
        cell.backgroundColor = UIColor(named: "color_ranking_bottomBg")
        cell.number.text = "\(indexPath.row + 4)"
        cell.username.text = currentDataSource[indexPath.row + 3].username
        cell.profileImage.kf.setImage(with: currentDataSource[indexPath.row + 3].profileImageURL)
        cell.pointLabel.text = "\(currentDataSource[indexPath.row + 3].point)"
        cell.type.text = "@\(currentDataSource[indexPath.row + 3].type ?? "")"
        cell.type.textColor = currentDataSource[indexPath.row + 3].vegieType?.typeColor
//        cell.type.textColor = Type.shared.typeColor(typeName: currentDataSource[indexPath.row + 3].type ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if selectedFilter == .all {
            let header = RankingHeader(user: allRank)
            return header
        } else {
            let header = RankingHeader(user: myTypeRank)
            return header
        }
        
        
        // MARK: - ranking header, ranking update needed !!!!
    }
}

extension RankingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 243
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}


// MARK: - RankingCustomTopViewDelegate

extension RankingViewController: RankingCustomTopViewDelegate {
    
    func handleFindMe() {
        print("DEBUG: Handle find me")
    }
    
    func handleBackToMain() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension RankingViewController: RankingSecondViewDelegate {
    
    func showBulletin() {
        bulletinManager.backgroundColor = UIColor(named: "color_mypage_myPostCountBoxBg") ?? .white
        bulletinManager.showBulletin(above: self)
    }
    
    
    func selection(_ view: RankingSecondView, didselect index: Int) {
        guard let filter = RankingFilterOptions(rawValue: index) else { return }
        self.selectedFilter = filter
        print("DEBUG: filter is \(selectedFilter)")
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


extension RankingViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    
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
                
                self.navigationController?.popViewController(animated: true)
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
            
            fetchMyTypeUserRanking()
            
            print("DEBUG: logged in and update home tab")
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            guard let tab = window.rootViewController as? MainTabBarController else { return }
            
            tab.fetchUser()
            print("DEBUG: New user is '\(username)'")
            
            return
        }
    }
}



