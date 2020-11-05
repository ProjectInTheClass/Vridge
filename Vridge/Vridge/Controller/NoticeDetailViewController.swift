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
    let tableView = UITableView()
    
    let customNavBar = CustomNavBar()
    
    var notice: [noticeContent] = [
        noticeContent(title: "채식 인증 챌린지 서비스 Vridge 런칭! 제목이 두~~줄이면 이렇게 레이아웃이 잡힙니다.", date: "2020.11.30", content: "안녕하세요. Team Vridge입니다. \n채식 입문자들을 위한 채식 인증 챌린지 서비스Vridge가 드디어 세상에 나오게 되었습니다! \n \n어떻게 하면 채식 입문자들이 쉽게 채식을 지속할 수 있을까? 라는 생각을 바탕으로 많은 고민과 노력 끝에 나온 저희의 자식같은 서비스입니다. \n많은 사용과 관심 부탁드립니다 :) \n감사합니다💚" )]
    
    // MARK: - Lifecycle
    
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
        customNavBar.delegate = self
        
        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(1)
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back5")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back5")
        
        
        view.addSubview(tableView)
        view.addSubview(customNavBar)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(NoticeDetailCell.self, forCellReuseIdentifier: cellID)
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.anchor(top: customNavBar.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
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
        
        let contents = notice[indexPath.row]
        if indexPath.section == 0 {
            cell.noticeDetailTitle.text = contents.title
            cell.noticeDetailDate.text = contents.date
            
        } else {
            cell.noticeDetailContent.text = contents.content
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            let contents = notice[indexPath.row]
            if contents.title.count >= 30 {
                return 107
            } else {
                return 85
            }
        } else if indexPath.section == 1 {
            return 689
        } else {
            return 0
        }
        
        
    }
    
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
