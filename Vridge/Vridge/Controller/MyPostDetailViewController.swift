//
//  MyPostDetailViewController.swift
//  Vridge
//
//  Created by 김루희 on 2020/11/06.
//

import UIKit

private let cellID = "Cell"

class MyPostDetailViewController: UIViewController {

    // MARK: - Properties
    
    let tableView = UITableView()
    
    let customNavBar = CustomNavBar()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavBar.titleLabel.text = "내 게시글"
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        configureUI()
        view.backgroundColor = .yellow
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        tabBarController?.tabBar.isHidden = false
    }

   // MARK: - Helpers

    func configureUI() {
        
        customNavBar.delegate = self
        tableView.delegate  = self
        tableView.dataSource = self
        
        tableView.register(MyPostDetailCell.self, forCellReuseIdentifier: cellID)
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableView.automaticDimension

        view.addSubview(customNavBar)
        view.addSubview(tableView)
        
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 44)
        tableView.anchor(top: customNavBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
    }
}

extension MyPostDetailViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MyPostDetailCell
        
        return cell
    }
    
    
}

extension MyPostDetailViewController : UITableViewDelegate {
    
}

extension MyPostDetailViewController : CustomNavBarDelegate {
    func backButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension MyPostDetailViewController : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
