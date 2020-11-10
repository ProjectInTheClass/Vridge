//
//  MyPostViewController.swift
//  MyPageView
//
//  Created by 김루희 on 2020/10/29.
//

import UIKit

private let cellID = "Cell"

class MyPostViewController: UIViewController {

    // MARK: - Properties
    
    var myPosts = [Post]() {
        didSet { collectionView.reloadData() }
    }
    
    let customNavBar = CustomNavBar()
    
    let collectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return cv
    }()
    
    let emptyStateImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "imgMypostEmptystate")
        return iv
    }()
    
    let emptyStateLabel1: UILabel = {
        let label = UILabel()
        label.text = "아직 작성한 게시글이 없네요."
        label.textAlignment = .center
        label.font = UIFont.SFSemiBold(size: 15)
        label.textColor = .vridgeGray
        return label
    }()
    
    let emptyStateLabel2: UILabel = {
        let label = UILabel()
        label.text = "오늘 하루 채식 식단을 인증해주세요!"
        label.textAlignment = .center
        label.font = UIFont.SFSemiBold(size: 13)
        label.textColor = .vridgeGray
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavBar.titleLabel.text = "내 게시글"
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
    
    
    // MARK: - API
    
    func fetchMyPost() {
        PostService.shared.fetchMyPosts { posts in
            self.myPosts = posts.sorted(by: { $0.timestamp > $1.timestamp })
        }
    }
    
    
    // MARK: - Selectors
    
    @objc func fetchAgain() {
        fetchMyPost()
    }
    
    // MARK: - Helpers
        
    func configureUI() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(fetchAgain),
                                               name: Notification.Name("fetchAgain"), object: nil)
        fetchMyPost()
        
        view.backgroundColor = UIColor(named: headerBackgroundColor)
        
        customNavBar.delegate = self
        
        let labelStack = UIStackView(arrangedSubviews: [emptyStateLabel1, emptyStateLabel2])
        labelStack.spacing = 12
        labelStack.alignment = .center
        labelStack.axis = .vertical
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addSubview(emptyStateImageView)
        collectionView.addSubview(labelStack)
        
        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(1)
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        
        collectionView.register(MyPostCell.self, forCellWithReuseIdentifier: cellID)
        
        collectionView.backgroundColor = UIColor(named: "color_all_viewBackground")
        view.addSubview(customNavBar)
        view.addSubview(collectionView)
        
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                            right: view.rightAnchor, height: 44)
        collectionView.anchor(top: customNavBar.bottomAnchor, left: view.leftAnchor,
                              bottom: view.bottomAnchor, right: view.rightAnchor)
        emptyStateImageView.centerX(inView: collectionView, topAnchor: collectionView.topAnchor, paddingTop: 186)
        labelStack.centerX(inView: collectionView, topAnchor: emptyStateImageView.bottomAnchor, paddingTop: 23)
        
    }

}

extension MyPostViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPosts.count
        // images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MyPostCell
//        cell.backgroundColor = .red
//        cell.myPostImage.image = images[indexPath.row]
        cell.myPostImage.kf.setImage(with: URL(string: myPosts[indexPath.item].images[0]))
        
        if myPosts.count == 0 {
            emptyStateImageView.isHidden = false
            emptyStateLabel1.isHidden = false
            emptyStateLabel2.isHidden = false
        } else {
            emptyStateImageView.isHidden = true
            emptyStateLabel1.isHidden = true
            emptyStateLabel2.isHidden = true
        }
        
        return cell
        
    }
    
    
}

extension MyPostViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let controller = FeedDetailViewController(post: myPosts[indexPath.item], index: indexPath.item)
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    

}

extension MyPostViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 셀 사이즈
        let width = ((collectionView.frame.width / 3) - 2)
        let height = ((collectionView.frame.width / 3) - 2)
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // 셀들의 위아래 간격
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // 셀들의 양 옆 간격
        return 3
    }
}

extension MyPostViewController : CustomNavBarDelegate {
    func backButtonDidTap() {
        navigationController?.popViewController(animated: true) //뒤로 간다는 것
    }
    
    
}

extension MyPostViewController : UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // 스와이핑으로 뒤로 가기
    }
}

extension MyPostViewController: FeedDetailViewDelegate {
    
    func reloadMyFeeds() {
        fetchMyPost()
    }
    
    
}
