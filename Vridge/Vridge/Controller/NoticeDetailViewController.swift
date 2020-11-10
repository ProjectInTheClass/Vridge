//
//  NoticeDetailViewController.swift
//  MyPageView
//
//  Created by 김루희 on 2020/10/31.
//

import UIKit

struct noticeContent {
    var title: String
    var date: String
    var content: String
    
    init(title: String, date: String, content: String) {
        self.title = title
        self.date = date
        self.content = content
    }
}

private let cellID = "Cell"
class NoticeDetailViewController: UIViewController {

    // MARK: - Properties
    
    var notice: Notice
    
    let tableView = UITableView()
    
    let customNavBar = CustomNavBar()
    
//    var notice: [noticeContent] = [
//        noticeContent(title: "[공지] 채식 인증 챌린지 서비스 Vridge 런칭!", date: "2020.11.30", content: "안녕하세요. Team Vridge입니다. \n채식 입문자들을 위한 채식 인증 챌린지 서비스Vridge가 드디어 세상에 나오게 되었습니다! \n \n어떻게 하면 채식 입문자들이 쉽게 채식을 지속할 수 있을까? 라는 생각을 바탕으로 많은 고민과 노력 끝에 나온 저희의 자식같은 서비스입니다. \n많은 사용과 관심 부탁드립니다 :) \n감사합니다💚" )]
    
    
    // MARK: - Lifecycle
    
    init(notice: Notice) {
        self.notice = notice
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.post(name: Notification.Name("hidePostButton"), object: nil)
    }

    // MARK: - Helpers
    
    func configureUI() {
        
        view.backgroundColor = UIColor(named: "color_all_viewBackground")
        
        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(1)
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back5")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back5")
        
        
        view.addSubview(tableView)
        view.addSubview(customNavBar)
        
        tableView.delegate = self
        tableView.dataSource = self
        customNavBar.delegate = self
        
        tableView.register(NoticeDetailCell.self, forCellReuseIdentifier: cellID)
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.anchor(top: customNavBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, height: 44)
        
    }

}

extension NoticeDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NoticeDetailCell
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        
        if indexPath.section == 0 {
            cell.noticeDetailTitle.text = notice.title
            cell.noticeDetailDate.text = formatter.string(from: notice.timestamp)
            
        } else {
            cell.noticeDetailContent.text = notice.content
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let header = NoticeDetailHeader()
            return header
        default:
            let header = NoticeDetailHeader()
            return header
        }
    }
    
}

extension NoticeDetailViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0{
//            let contents = notice[indexPath.row]
//            if contents.title.count >= 30 {
//                return 107
//            } else {
//                return 85
//            }
//        } else if indexPath.section == 1 {
//            return 689
//        } else {
//            return 0
//        }
//
//    }  동적 셀 높이 줘서 여기도 주석 처리함
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 0
        default: return 1
        }
    }
    
}

extension NoticeDetailViewController: CustomNavBarDelegate {
    func backButtonDidTap() {
        navigationController?.popViewController(animated: true) //뒤로 간다는 것
    }
    
}

extension NoticeDetailViewController : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
