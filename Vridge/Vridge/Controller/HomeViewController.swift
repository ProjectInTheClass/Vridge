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
    
    private var posts = [Post]() {
        didSet { tableView.reloadData() }
    }
    
    var user: [User]? {
        didSet { print("DEBUG: user did set") }
    }
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    lazy var indicator: UIActivityIndicatorView = {
        let ic = UIActivityIndicatorView()
        ic.color = .vridgeBlack
        ic.style = .large
        ic.center = view.center
        return ic
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(1)
        configureUI()
        fetchPosts()
        
        view.addSubview(indicator)
        indicator.startAnimating()
    }
    
    
    // MARK: - Selectors
    
    @objc func handleShowRanking() {
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
        
        tableView.register(HomeFeedCell.self, forCellReuseIdentifier: cellID)
        
        view.addSubview(tableView)
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
    }
    
    func fetchPosts() {
        PostService.shared.fetchPosts { posts in
            self.posts = posts
            self.indicator.stopAnimating()
        }
    }
    
    func showReportAlert() {
        let alert = UIAlertController(title: "", message: "신고가 정상적으로 반영되었습니다\n신속히 처리하도록 하겠습니다",
                                      preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource/Delegate
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! HomeFeedCell
        
        cell.delegate = self
        cell.posts = posts[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HomeHeaderView()
        
        header.backgroundColor = .white
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 167
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
}


extension HomeViewController: HomeFeedCellDelegate {
    
    func reportDidTap() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let reportButton = UIAlertAction(title: "신고하기", style: .default) { _ in
            let alert = UIAlertController(title: "신고 사유 선택", message: nil, preferredStyle: .actionSheet)
            let sexualHarass = UIAlertAction(title: "성적 수치심 유발", style: .default) { _ in
                self.showReportAlert()
            }
            let swear = UIAlertAction(title: "욕설/비하", style: .default) { _ in
                self.showReportAlert()
            }
            let fraud = UIAlertAction(title: "유출/사칭/사기", style: .default) { _ in
                self.showReportAlert()
            }
            let advertise = UIAlertAction(title: "상업적 광고 및 판매", style: .default) { _ in
                self.showReportAlert()
            }
            let nonsense = UIAlertAction(title: "채식과 관련 없음", style: .default) { _ in
                self.showReportAlert()
            }
            let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(sexualHarass)
            alert.addAction(swear)
            alert.addAction(fraud)
            alert.addAction(advertise)
            alert.addAction(nonsense)
            alert.addAction(cancelButton)
            self.present(alert, animated: true, completion: nil)
        }
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(reportButton)
        alert.addAction(cancelButton)
        present(alert, animated: true, completion: nil)
    }
    
}
