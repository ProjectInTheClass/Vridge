//
//  RankingViewController.swift
//  Vridge_Pages
//
//  Created by Kang Mingu on 2020/10/09.
//

import UIKit

import Firebase

private let cellID = "rankingCell"

class RankingViewController: UIViewController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet { fetchTotalMyTypeUser() }
    }
    
    var totalUser: Int? {
        didSet { fetchUserRanking() }
    }
    
    var totalMyTypeUser: Int? {
        didSet { fetchMyTypeUserRanking(); print("DEBUG: total mytype user is \(totalMyTypeUser)") }
    }
    
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
    //didSet 해야할지도...
    
    private var currentDataSource: [User] {
        switch selectedFilter {
        case .all: return allRank
        case .myType: return myTypeRank // users.child(uid) 에서 typeName을 가져와서
        // user_(typeName).value에서 type이 뭔지 가져와서 해당하는 소스 가져오기.
        }
    }
    
    private let actionSheetViewModel = ActionSheetViewModel()
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    
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
        fetchTotalUser()
        fetchTotalMyTypeUser()
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
    
    func fetchTotalUser() {
        UserService.shared.fetchTotalUser { numberOfUsers in
            self.totalUser = numberOfUsers
        }
    }
    
    func fetchTotalMyTypeUser() {
        if Auth.auth().currentUser == nil {
            print("DEBUG: no user exist")
        } else {
            UserService.shared.fetchTotalMyTypeUser(myType: (user?.vegieType)!) { numberOfMyTypeUsers in
                self.totalMyTypeUser = numberOfMyTypeUsers
            }
        }
    }
    
    func fetchUserRanking() {
        UserService.shared.fetchRanking { users in
            if users.count == self.totalUser {
                self.allRank = users.sorted(by: { $0.point > $1.point })
            }
        }
    }
    
    func fetchMyTypeUserRanking() {
        if Auth.auth().currentUser == nil {
            print("DEBUG: no user exist2")
        } else {
            UserService.shared.fetchMyTypeRanking(myType: (user?.vegieType)!) { users in
                if users.count == self.totalMyTypeUser {
                    print("DEBUG: user type is ===== \(self.user?.vegieType?.rawValue)")
                    self.myTypeRank = users.sorted(by: { $0.point > $1.point })
                }
            }
        }
    }
    
    
    // MARK: - Selectors
    
    
    // MARK: - Helpers
    
    
    
    func configureUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(topView)
        view.addSubview(secondView)
        view.addSubview(tableView)
        
        topView.delegate = self
        secondView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(RankingCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = .vridgeWhite
        
        topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                       right: view.rightAnchor, height: 56)
        secondView.anchor(top: topView.bottomAnchor, left: view.leftAnchor,
                          right: view.rightAnchor, height: 44)
        tableView.anchor(top: secondView.bottomAnchor, left: view.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
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
        cell.backgroundColor = .vridgeWhite
        cell.number.text = "\(indexPath.row + 4)"
        cell.username.text = currentDataSource[indexPath.row + 3].username
        cell.profileImage.kf.setImage(with: currentDataSource[indexPath.row + 3].profileImageURL)
        cell.pointLabel.text = "\(currentDataSource[indexPath.row + 3].point)"
        cell.type.text = "@\(currentDataSource[indexPath.row + 3].type!)"
        cell.type.textColor = Type.shared.typeColor(typeName: currentDataSource[indexPath.row + 3].type!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if selectedFilter == .all {
            let header = RankingHeader(user: allRank)
            header.backgroundColor = .white
            return header
        } else {
            let header = RankingHeader(user: myTypeRank)
            header.backgroundColor = .white
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
    
    func showLogin() {
        present(actionSheetViewModel.pleaseLogin(self), animated: true) {
            self.navigationController?.popViewController(animated: true)
            //로그인 뷰가 dismiss 된 후 기존의 ranking 뷰에서 내 타입 순위를 바로 볼 수 있게끔 바꿔보기.
        }
    }
    
    
    func selection(_ view: RankingSecondView, didselect index: Int) {
        guard let filter = RankingFilterOptions(rawValue: index) else { return }
        self.selectedFilter = filter
        print("DEBUG: filter is \(selectedFilter)")
    }
}


