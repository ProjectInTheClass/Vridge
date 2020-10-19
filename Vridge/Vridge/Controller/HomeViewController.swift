//
//  ViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/02.
//

import UIKit

private let cellID = "cellID"
private let headerID = "headerID"

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let vridgeLogo: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "imgVridgeLogo")
        return imgView
    }()
    
    private let vridgeText: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "imgVridgeText")
        return imgView
    }()
    
    private lazy var rankButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "btnRank"), for: .normal)
        btn.addTarget(self, action: #selector(handleShowRanking), for: .touchUpInside)
        btn.tintColor = .black
        return btn
    }()
    
    var numberOfPost = 0
    
    var posts = [Post]() {
        didSet { tableView.reloadData() }
    }
    
    var user: User? {
        didSet { print("DEBUG: user did set") }
    }
    
    var point: Int? {
        didSet { tableView.reloadData() }
    }
    
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
    
    let refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return rc
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(1)
        numberOfPosts()
        configureUI()
        fetchPosts()
        fetchPoint()
        fetchUserType()
        
        view.addSubview(indicator)
        indicator.startAnimating()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchAgain),
                                               name: Notification.Name("fetchAgain"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.post(name: Notification.Name("showPostButton"), object: nil)
    }
    
    
    // MARK: - Selectors
    
    @objc func fetchAgain() {
        fetchPosts()
        fetchPoint()
        print("DEBUG: it worked!!")
    }
    
    @objc func handleRefresh() {
        print("DEBUG: Refresh feed")
        fetchPosts()
        fetchPoint()
    }
    
    @objc func handleShowRanking() {
        NotificationCenter.default.post(name: Notification.Name("hidePostButton"), object: nil)
        
        let controller = RankingViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // MARK: - Helpers
    
    func fetchUserType() {
        UserService.shared.fetchUserType { type in
            self.type = type
        }
    }
    
    func fetchPoint() {
        UserService.shared.fetchUserPoint { point in
            self.point = point
        }
    }
    
    func numberOfPosts() {
        PostService.shared.numberOfPosts { nums in
            self.numberOfPost = nums
        }
    }
    
    func loadMore() {
        let from = posts.count
        let to = from + POST_LOAD_AT_ONCE >= numberOfPost ? numberOfPost : from + POST_LOAD_AT_ONCE
        
        PostService.shared.refetchPost(post: posts, from: from, upto: to) { posts in
            self.posts = posts.sorted(by: { $0.timestamp > $1.timestamp })
        }
        tableView.scrollToRow(at: IndexPath(item: from - 1, section: 0), at: .bottom, animated: true)
    }
    
    func configureUI() {
        let logoImage = UIBarButtonItem(customView: vridgeLogo)
        let logoText = UIBarButtonItem(customView: vridgeText)
        navigationItem.leftBarButtonItems = [logoImage, logoText]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rankButton)
        
        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(1)
        
        //hide navigationBar borderLine
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.refreshControl = refreshControl
        
        tableView.register(HomeFeedCell.self, forCellReuseIdentifier: cellID)
        
        view.addSubview(tableView)
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
    }
    
    func fetchPosts() {
        PostService.shared.fetchPosts { posts in
            self.posts = posts.sorted(by: { $0.timestamp > $1.timestamp })
            self.indicator.stopAnimating()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func showReportAlert() {
        let alert = UIAlertController(title: noTitle, message: reportMessage, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
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
        cell.type.text = "@\(type!)"
//        cell.type.textColor = posts[indexPath.row].user.vegieType?.typeColor
        cell.type.textColor = Type.shared.typeColor(typeName: type!) // 별로 좋은 방법은 아닌데 일단 이 방법으로....
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let user = user else { return nil }
        guard let point = point else { return nil}
        let header = HomeHeaderView(frame: .zero, user: user, point: point)
        
        header.backgroundColor = .white
        
        return header
    }
    
}


// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollHeight = scrollView.frame.size.height
        if offsetY == contentHeight - scrollHeight
        {
            loadMore()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 137
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if  indexPath.row == lastRowIndex {
            let spinner = UIActivityIndicatorView(style: .large)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false
        }
    }
    
}

extension HomeViewController: HomeFeedCellDelegate {
    
    func currentUserAmendTapped(sender: Post, row: Int) {
        let viewModel = ActionSheetViewModel()
        present(viewModel.amendActionSheet(self, row: row, post: sender), animated: true)
    }
    
    func reportButtonTapped(sender: Post, row: Int) {
        let viewModel = ActionSheetViewModel()
        present(viewModel.reportActionSheet(self, post: sender), animated: true, completion: nil)
        
    }
    
}
