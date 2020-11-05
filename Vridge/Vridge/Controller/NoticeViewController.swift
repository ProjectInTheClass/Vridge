//
//  NoticeViewController.swift
//  MyPageView
//
//  Created by 김루희 on 2020/10/29.
//

import UIKit

struct noticeList {
    var title: String
    var date: String
    
    init(title: String, date: String) {
        self.title = title
        self.date = date
    }
}

private let cellID = "CellID"
class NoticeViewController: UIViewController {
    
    //MARK: - Properties
    
    let tableView = UITableView()

    let customNavBar = CustomNavBar()
    
    var list: [noticeList] = [
        noticeList(title: "[공지] 채식 인증 서비스 Vridge 런칭!", date: "2020.11.30"),
        noticeList(title: "채식 인증 챌린지 서비스 Vridge 런칭! 제목이 두~~줄이면 이렇게 레이아웃이 잡힙니다.", date: "2020.11.30")
    ].reduce([],{ [$1] + $0 })
  
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.post(name: Notification.Name("hidePostButton"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

        tabBarController?.tabBar.isHidden = false
        
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        
        customNavBar.delegate = self
        
        view.backgroundColor = UIColor(named: "color_all_viewBackground")
        
//        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(1)
        
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back5")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back5")
        
        view.addSubview(tableView)
        view.addSubview(customNavBar)

        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(NoticeCell.self, forCellReuseIdentifier: cellID)
        
        tableView.anchor(top: customNavBar.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.rightAnchor)
        
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 44)
    }

}

extension NoticeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NoticeCell
        
        let lists = list[indexPath.row]
        cell.noticeListTitle.text = lists.title
        cell.noticeListDate.text = lists.date
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = UIColor(named: "color_all_viewBackground")
        return cell
    }
    
    
}

extension NoticeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let lists = list[indexPath.row]
        if lists.title.count >= 30 {
            return 102
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let controller = NoticeDetailViewController()
            navigationController?.pushViewController(controller, animated: true)
            
        case 1:
            let controller = NoticeDetailViewController()
            navigationController?.pushViewController(controller, animated: true)
            
        default: print("DEBUG: error")
        }
        
    }
}

extension NoticeViewController: CustomNavBarDelegate {
    func backButtonDidTap() {
        navigationController?.popViewController(animated: true) //뒤로 간다는 것
    }
    
}

extension NoticeViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
