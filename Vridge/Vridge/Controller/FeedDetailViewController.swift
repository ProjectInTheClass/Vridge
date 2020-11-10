//
//  FeedDetailViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/11/05.
//

import UIKit

protocol FeedDetailViewDelegate: class {
    func reloadMyFeeds()
}

private let tableViewCellID = "CellID"
private let tableHeaderID = "HeaderID"

class FeedDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: FeedDetailViewDelegate?
    
    private let tableView = UITableView()
    
    var post: Post {
        didSet { print("DEBUG: post == \(post.caption)") }
    }
    
    var index: Int {
        didSet { print("DEBUG: index === \(index)") }
    }
    
    private let customNavigationBar = FeedDetailCustomTopView()
    
    
    // MARK: - Lifecycle
    
    init(post: Post, index: Int) {
        self.post = post
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
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
    
    func refetchData() {
        PostService.shared.fetchMyPosts { posts in
            let newPost = posts.sorted(by: { $0.timestamp > $1.timestamp } )
            if newPost.count - 1 >= self.index {
                self.post = newPost[self.index]
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Selectors
    
    @objc func fetchAgain() {
        refetchData()
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchAgain),
                                               name: Notification.Name("fetchAgain"), object: nil)
        
        view.backgroundColor = UIColor(named: viewBackgroundColor)
        
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        
        view.addSubview(customNavigationBar)
        
        customNavigationBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                                   right: view.rightAnchor, height: 44)
        customNavigationBar.delegate = self
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellID)
        tableView.tableFooterView = UIView()
        
        tableView.anchor(top: customNavigationBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
                         right: view.rightAnchor)
        
    }
    
    func currentUserAmendTapped(sender: Post, row: Int) {
        
    }
    
    func reportButtonTapped(sender: Post, row: Int) {
        
    }
    
}

// MARK: - FeedDetailCustomTopViewDelegate

extension FeedDetailViewController: FeedDetailCustomTopViewDelegate {
    func handleBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UITableViewDataSource

extension FeedDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = FeedDetailHeader(post: post)
        header.delegate = self
        return header
    }
    
}

// MARK: - UITableViewDelegate

extension FeedDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let viewModel = FeedDetailViewModel(post: post)
        let captionHeight = viewModel.size(forWidth: view.frame.width).height
        
        return CGFloat(captionHeight + view.frame.width + 100)
    }
    
}

extension FeedDetailViewController: FeedDetailHeaderDelegate {
    
    func reportButtonDidTap() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let amendButton = UIAlertAction(title: amendTitle, style: .default) { _ in
            PostService.shared.amendPost(post: self.post) { posts in
                let controller = PostingViewController(config: .amend(self.post), post: self.post)
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
            
        }
        // 1. DB에서 삭제
        // 2. 내 게시글 다시 불러오기, 새로고침 -> 뒤로가기
        let deleteButton = UIAlertAction(title: deleteButtonTitle, style: .destructive) { _ in
            let deleteAlert = UIAlertController(title: deleteAlertTitle,
                                                message: deleteAlertMessage,
                                                preferredStyle: .alert)
            let noButton = UIAlertAction(title: no, style: .default, handler: nil)
            let okButton = UIAlertAction(title: yes, style: .destructive) { _ in
                // delete service
                PostService.shared.deletePostFromMyPost(post: self.post) { (err, ref) in
                    self.delegate?.reloadMyFeeds()
                    NotificationCenter.default.post(name: Notification.Name("refetchPosts"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                    print("DEBUG: 삭제 완료 !!")
                }
            }
            deleteAlert.addAction(noButton)
            deleteAlert.addAction(okButton)
            self.present(deleteAlert, animated: true, completion: nil)
        }
        
        let cancelButton = UIAlertAction(title: cancel, style: .cancel, handler: nil)
        
        alert.addAction(amendButton)
        alert.addAction(deleteButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true, completion: nil)
    }
    
}
