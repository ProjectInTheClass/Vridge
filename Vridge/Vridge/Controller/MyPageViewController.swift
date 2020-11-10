//
//  MyPageViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/04.
//

import UIKit

import Firebase

private let cellID = "CellID"

class MyPageViewController: UIViewController {
    
    // MARK: - Properties

    let tableView = UITableView(frame: .zero, style: .grouped)
    let firstSectionMenu = ["공지사항", "브릿지란?", "앱 버전 1.0.0"]
    var secondSectionMenu = ["프로필 수정", "로그아웃"]
    
    var user: User? {
        didSet { tableView.reloadData() }
    }
    
    let customNavBar = CustomNavBar()
    
    let backView : UIView = {
        let view = UIView()
//        view.backgroundColor = .vridgeGreen
        return view
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
        guard let uid = Auth.auth().currentUser?.uid else {
            secondSectionMenu = ["로그인"]
            user = nil
            return
        }
        UserService.shared.fetchUser(uid: uid) { user in
            print("DEBUG: set user again")
            self.user = user
        }
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(refetchUser),
                                               name: Notification.Name("refetchUser"),
                                               object: nil)
        
        view.addSubview(backView)
        view.addSubview(tableView)
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
        
//        guard let user = user else {
//            let topHeader = MyPageTopHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 265), user: nil)
//            tableView.tableHeaderView = topHeader
//            topHeader.usernameLabel.text = self.user?.username ?? "로그인이 필요해요"
//            topHeader.delegate = self
//            topHeader.backgroundColor = UIColor(named: viewBackgroundColor)
//            return
//        }
//        let topHeader = MyPageTopHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 265), user: user)
//        tableView.tableHeaderView = topHeader
//        topHeader.delegate = self
//        topHeader.backgroundColor = UIColor(named: viewBackgroundColor)
        
        let topHeader = MyPageTopHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 265),
                                            user: user)
        tableView.tableHeaderView = topHeader
        topHeader.usernameLabel.text = user?.username ?? "로그인이 필요해요"
        topHeader.delegate = self
        topHeader.backgroundColor = UIColor(named: viewBackgroundColor)
        
        
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
                    let controller = EditProfileViewController()
                    navigationController?.pushViewController(controller, animated: true)
                    fetchUser()
                case 1:
                    let alert = UIAlertController(title: logOutTitle, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: logOutAnswer, style: .destructive, handler: { action in
                        AuthService.shared.logOut(viewController: self)
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
            print("DEBUG: no user exist")
            let viewModel = ActionSheetViewModel()
            present(viewModel.pleaseLogin(self), animated: true, completion: nil)
        } else {
            let controller = MyPostViewController()
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
}

