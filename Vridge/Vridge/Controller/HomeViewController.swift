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
    
    private let logo: UILabel = {
        let label = UILabel()
        label.text = "Vridge"
        label.font = UIFont.SFBold(size: 18)
        return label
    }()
    
    var posts = [Post]() {
        didSet { tableView.reloadData() }
    }
    
    var user: User? {
        didSet { print("DEBUG: user did set") }
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
        configureUI()
        fetchPosts()
        
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
        print("DEBUG: it worked!!")
    }
    
    @objc func handleRefresh() {
        print("DEBUG: Refresh feed")
        fetchPosts()
    }
    
    @objc func handleShowRanking() {
        NotificationCenter.default.post(name: Notification.Name("hidePostButton"), object: nil)
        
        let controller = RankingViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: logo)
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "랭킹", style: .plain, target: self, action: #selector(handleShowRanking))
        navigationItem.rightBarButtonItem?.tintColor = .black
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HomeHeaderView()
        
        header.backgroundColor = .white
        
        return header
    }
}


// MARK: - UITableViewDelegate

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 167
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
