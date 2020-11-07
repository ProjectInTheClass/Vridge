//
//  FeedDetailViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/11/05.
//

import UIKit

private let tableViewCellID = "CellID"
private let tableHeaderID = "HeaderID"

class FeedDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    
    var post: Post {
        didSet { print("DEBUG: post == \(post.caption)") }
    }
    
    private let customNavigationBar = FeedDetailCustomTopView()
    
    
    // MARK: - Lifecycle
    
    init(post: Post) {
        self.post = post
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
    

    // MARK: - Helpers
    
    func configureUI() {
        
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
