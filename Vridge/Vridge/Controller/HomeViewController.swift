//
//  ViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/02.
//

import UIKit
import AuthenticationServices

import Lottie
import BLTNBoard
import Firebase

private let cellID = "cellID"
private let headerID = "headerID"

protocol HomeViewControllerDelgate: class {
    func updateUsers()
}

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegates: HomeViewControllerDelgate?
    
    private let vridgeLogo: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "imgVridgeLogo")
        return imgView
    }()
    
    private let vridgeText: UIButton = {
        let imgView = UIButton(type: .system)
        imgView.tintColor = UIColor(named: "home_vridgeTypo")
        imgView.setImage(UIImage(named: "vridgetext"), for: .normal)
//        imgView.isUserInteractionEnabled = false
        return imgView
    }()
        
    private lazy var rankButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setBackgroundImage(UIImage(named: "btnRank"), for: .normal)
        btn.addTarget(self, action: #selector(handleShowRanking), for: .touchUpInside)
        btn.backgroundColor = UIColor(named: "vridgeGreen")
        return btn
    }()
    
    var numberOfPost = 0
    
    var posts = [Post]() {
        didSet { tableView.reloadData() }
    }
    
    var user: User? {
        didSet { print("DEBUG: user did set as \(user?.username)")
            print("DEBUG: user point now == \(user?.point)")
            tableView.reloadData() }
    }
    
//    var point: Int? {
//        didSet { tableView.reloadData() }
//    }
    
//    lazy var point = user?.point
    
    var type: String? {
        didSet { tableView.reloadData() }
    }
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    lazy var indicator: UIActivityIndicatorView = {
        let ic = UIActivityIndicatorView()
        ic.color = .vridgeBlack
        ic.style = .large
        ic.center = view.center
        return ic
    }()
    
    let animationView: AnimationView = {
        let av = Lottie.AnimationView(name: loadingAnimation)
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
        
        rootItem.alternativeButtonTitle = "그냥 둘러보기"
        rootItem.appearance.alternativeButtonTitleColor = .vridgeGreen
        
        rootItem.actionHandler = { _ in
            self.performSignin()
        }
        
        rootItem.alternativeHandler = { _ in
            self.dismissBulletin()
        }
        return BLTNItemManager(rootItem: rootItem)
    }()
    
    var viewModel = ActionSheetViewModel()
    
    var page = 1
    
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        animationView.play()
        
        let refreshControl: UIRefreshControl = {
            let rc = UIRefreshControl()
            let loadingView = Lottie.AnimationView(name: loadingAnimation)
            loadingView.play()
            loadingView.contentMode = .scaleAspectFit
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.loopMode = .loop
            rc.addSubview(loadingView)
            loadingView.anchor(top: rc.topAnchor, paddingTop: 20, width: 120, height: 60)
            loadingView.centerX(inView: rc)
            rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
            rc.tintColor = .clear
            return rc
        }()
        
        tableView.refreshControl = refreshControl
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bulletinManager.backgroundColor = UIColor(named: "color_mypage_myPostCountBoxBg") ?? .white
        
        configureUI()
        fetchPosts()
//        fetchPoint()
        fetchUserType()
        
        view.addSubview(animationView)
        animationView.center(inView: view)
        animationView.setDimensions(width: 100, height: 100)
        animationView.contentMode = .scaleAspectFill
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchAgain),
                                               name: Notification.Name("fetchAgain"),
                                               object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        numberOfPosts()
        fetchUser()
        
        print("DEBUG: user point now ================= \(user?.point)")
        
        super.viewWillAppear(true)
        NotificationCenter.default.post(name: Notification.Name("showPostButton"), object: nil)
    }
    
    
    // MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    func fetchUserType() {
        UserService.shared.fetchUserType { type in
            self.type = type
        }
    }
    
//    func fetchPoint() {
//        UserService.shared.fetchUserPoint { point in
//            self.point = point
//        }
//    }
    
    func numberOfPosts() {
        PostService.shared.numberOfPosts { nums in
            self.numberOfPost = nums
            print("DEBUG: number of posts ==== \(self.numberOfPost)")
        }
    }
    
    func fetchPosts() {
        PostService.shared.fetchPosts { posts in
            self.posts = posts.sorted(by: { $0.timestamp > $1.timestamp })
            self.indicator.stopAnimating()
            self.animationView.isHidden = true
            
            self.checkIfUserReportPost()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func checkIfUserReportPost() {
        posts.forEach { post in
            PostService.shared.checkIfUserReportedPost(post) { didReport in
                guard didReport == true else { return }
                
                if let index = self.posts.firstIndex(where: { $0.postID == post.postID }) {
                    self.posts[index].isReported = true
//                    if self.posts[index].isReported {
//                        self.posts.remove(at: index)
//                    }
                }
            }
        }
    }
    
    func loadMore(row: Int? = -1) {
        let from = posts.count
        let to = from + POST_LOAD_AT_ONCE >= numberOfPost ? numberOfPost : from + POST_LOAD_AT_ONCE
        
        PostService.shared.refetchPost(post: posts, from: from, upto: to) { posts in
            self.posts = posts.sorted(by: { $0.timestamp > $1.timestamp })
            
            self.checkIfUserReportPost()
            print("DEBUG: loaded more")
            if (self.page * 10) - (from - 1) == 1 && row == -1 {
                self.tableView.scrollToRow(at: IndexPath(item: from - 1, section: 0), at: .bottom, animated: true)
            }
        }
    }
    
    
    // MARK: - Selectors
    
    @objc func fetchAgain() {
        fetchPosts()
//        fetchPoint()
        print("DEBUG: it worked!!")
    }
    
    @objc func handleRefresh() {
        print("DEBUG: Refresh feed")
        fetchPosts()
//        fetchPoint()
    }
    
    @objc func handleShowRanking() {
        NotificationCenter.default.post(name: Notification.Name("hidePostButton"), object: nil)
        
        let controller = RankingViewController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func refetchPosts() {
        fetchPosts()
        print("DEBUG: refetch posts form Home View Controller")
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        navigationItem.title = ""
        
        let logoImage = UIBarButtonItem(customView: vridgeLogo)
        let logoText = UIBarButtonItem(customView: vridgeText)
        navigationItem.leftBarButtonItems = [logoImage, logoText]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rankButton)
        
        
        // navigation bar tint color set..
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor(named: viewBackgroundColor)?.withAlphaComponent(1.0)
        
        viewModel.delegate = self
        
        // hide navigationBar borderLine..
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: viewBackgroundColor)
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(HomeFeedCell.self, forCellReuseIdentifier: cellID)
        
        view.addSubview(tableView)
        view.addSubview(indicator)
        indicator.center = view.center
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
    }
    
    func showReportAlert() {
        let alert = UIAlertController(title: noTitle, message: reportMessage, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
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


// MARK: - UITableViewDataSource

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! HomeFeedCell
        
        cell.delegate = self
        cell.posts = posts[indexPath.row]
        cell.row = indexPath.row
        cell.selectionStyle = .none
        
        cell.reportedLabel.isHidden = !posts[indexPath.row].isReported
        cell.reportedView.alpha = posts[indexPath.row].isReported ? 1 : 0
        cell.captionLabel.isHidden = posts[indexPath.row].isReported
        cell.collectionView.isHidden = posts[indexPath.row].isReported
        cell.profileImageView.isHidden = posts[indexPath.row].isReported
        cell.reportButton.isHidden = posts[indexPath.row].isReported
        cell.username.isHidden = posts[indexPath.row].isReported
        cell.type.isHidden = posts[indexPath.row].isReported
        cell.time.isHidden = posts[indexPath.row].isReported
        
        if posts[indexPath.row].isReported {
            cell.pageControl.isHidden = true
        }
        
        if posts[indexPath.row].isReported {
            // array에서 없애버리기
//            posts.remove(at: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if user == nil {
            let header = HomeHeaderView(frame: .zero, user: nil)
            header.backgroundColor = UIColor(named: "color_all_viewBackground")
            return header
        } else {
            let header = HomeHeaderView(frame: .zero, user: user)
            header.backgroundColor = UIColor(named: "color_all_viewBackground")
            return header
        }
    }
    
}

// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 137
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 600
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return tableView.estimatedRowHeight
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
//        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
//        if  indexPath.row == lastRowIndex && (page * 10) - lastRowIndex == 1 {
//            print("DEBUG: last index row === \(lastRowIndex)")
//            let spinner = UIActivityIndicatorView(style: .large)
//            spinner.startAnimating()
//            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
//
//            tableView.tableFooterView = spinner
//            tableView.tableFooterView?.isHidden = false
//        }
        
        let lastElement = posts.count - 1
        if indexPath.row == lastElement {
            page += 1
//            loadMore()
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let controller = FeedDetailViewController(post: posts[indexPath.row], index: indexPath.row)
//        navigationController?.pushViewController(controller, animated: true)
//        print("DEBUG: cell tapped ! ")
//    }
    
}

extension HomeViewController: HomeFeedCellDelegate {
    
    func pleaseLogin() {
//        let viewModel = ActionSheetViewModel()
//        present(viewModel.pleaseLogin(self), animated: true, completion: nil)
        
        bulletinManager.showBulletin(above: self)
    }
    
    func currentUserAmendTapped(sender: Post, row: Int) {
        present(viewModel.amendActionSheet(self, row: row, post: sender), animated: true)
    }
    
    func reportButtonTapped(sender: Post, row: Int) {
        present(viewModel.reportActionSheet(self, post: sender, row: row), animated: true, completion: nil)
    }
    
    func cellTapped() {
//        showFeedDetail()
    }
    
}

extension HomeViewController: ActionSheetViewModelDelegate {
    
    func updateUser() {
        delegates?.updateUsers()
        print("DEBUG: delegate passed to HOmeVIewCOntroller")
        self.tableView.reloadData()
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


extension HomeViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    
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

