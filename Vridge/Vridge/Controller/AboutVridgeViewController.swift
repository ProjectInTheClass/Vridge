//
//  AboutVridgeViewController.swift
//  MyPageView
//
//  Created by 김루희 on 2020/10/29.
//

import UIKit

import GoogleMobileAds

private let cellID = "Cell"

class AboutVridgeViewController: UIViewController {

    // MARK: - Properties
    
    let tableView = UITableView()
    let customNavBar = CustomNavBar()
    
    let bannerView: GADBannerView = {
        let view = GADBannerView(adSize: kGADAdSizeBanner)
        return view
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavBar.titleLabel.text = "브릿지란?"
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
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

    // MARK: - Helpers
    
    func configureUI() {
        
        bannerView.adUnitID = adMobID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        view.backgroundColor = UIColor(named: headerBackgroundColor)
        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(1)
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "btnBack")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "btnBack")
        
        customNavBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.allowsSelection = false
        
        tableView.register(AboutVridgeCell.self, forCellReuseIdentifier: cellID)
        
        
        view.addSubview(tableView)
        view.addSubview(customNavBar)
        view.addSubview(bannerView)
        
        tableView.anchor(top: customNavBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
                         right: view.rightAnchor)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                            right: view.rightAnchor, height: 44)
        bannerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: 50)
        
    }

}

extension AboutVridgeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! AboutVridgeCell
        return cell
    }
    
    
}

extension AboutVridgeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1206
    }
    
}

extension AboutVridgeViewController: CustomNavBarDelegate {
    func backButtonDidTap() {
        navigationController?.popViewController(animated: true) //뒤로 간다는 것
    }
    
}

extension AboutVridgeViewController : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

