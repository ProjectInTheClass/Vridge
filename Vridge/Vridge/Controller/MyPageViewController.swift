//
//  MyPageViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/04.
//

import UIKit

class MyPageViewController: UIViewController {
    

    // MARK: - Properties

    
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var vegetarianTypeLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postBoxView: UIView!
    @IBOutlet weak var dietCountLabel: UILabel!
    @IBOutlet weak var seePostButton: UIButton!
    
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = true
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    
    @IBAction func seePostButton(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name("hidePostButton"), object: nil)
    }
    
    
    @IBAction func editProfileButton(_ sender: Any) {
    }
    
    
    @IBAction func versionCheckButton(_ sender: Any) {
        let alert = UIAlertController(title: "최신 버전이에요", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    
    @IBAction func noticeButton(_ sender: Any) {
    }
    
    @IBAction func aboutVridgeButton(_ sender: Any) {
    }
    
    
    @IBAction func logOutButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "로그아웃하시겠어요?", message: "", preferredStyle: .alert)
    
        alert.addAction(UIAlertAction(title: "로그아웃", style: .destructive, handler: { action in /*action 할 메서드나 코드 넣으면됨 여기에다가 */}))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            
        self.present(alert, animated: true)
    }
    
    
    @IBAction func signOutButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "탈퇴하시겠어요?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "회원탈퇴", style: .destructive, handler: { action in /* */}))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    

    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        postBoxView.layer.cornerRadius = 18
        postBoxView.layer.shadowColor = UIColor.black.cgColor
        postBoxView.layer.shadowOffset = CGSize(width: 0, height: 0)
        postBoxView.layer.shadowOpacity = 0.2
        postBoxView.layer.shadowRadius = 25

        seePostButton.layer.shadowColor = UIColor.black.cgColor
        seePostButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        seePostButton.layer.shadowOpacity = 0.2
        seePostButton.layer.shadowRadius = 10
    }

}


