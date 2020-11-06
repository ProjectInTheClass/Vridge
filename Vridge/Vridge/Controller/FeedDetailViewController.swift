//
//  FeedDetailViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/11/05.
//

import UIKit

private let feedCell = "FeedCell"

class FeedDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var post: Post {
        didSet { print("DEBUG: post == \(post.caption)")}
    }
    
    private let customNavigationBar = FeedDetailCustomTopView()
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 45, height: 45)
        iv.layer.cornerRadius = 45 / 2
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .vridgePlaceholderColor
        iv.clipsToBounds = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleImageTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(recognizer)
        return iv
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = UIColor(named: "indicatorSelectedColor")
        pc.pageIndicatorTintColor = .vridgePlaceholderColor
        pc.isEnabled = false
        pc.numberOfPages = post.images.count
        pc.isHidden = pc.numberOfPages == 1 ? true : false
        pc.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
//        pc.preferredIndicatorImage = UIImage(named: "indicatorUnselect") //ios 14 and above
        return pc
    }()
    
    lazy var username: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFSemiBold(size: 14)
        label.textColor = UIColor(named: allTextColor)
        return label
    }()
    
    lazy var type: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFRegular(size: 14)
        return label
    }()
    
    let time: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFRegular(size: 12)
        label.textColor = .vridgeGray
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFRegular(size: 14)
        label.textColor = UIColor(named: allTextColor)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var reportButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "btnReport"), for: .normal)
        button.addTarget(self, action: #selector(handleReportTapped), for: .touchUpInside)
        button.tintColor = UIColor(named: "color_all_button_normal")
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.heightAnchor.constraint(equalTo: cv.widthAnchor).isActive = true
        layout.scrollDirection = .horizontal
        cv.isPagingEnabled = true
        return cv
    }()
    
    
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
        print("DEBUG: viewLoaded == \(post.caption)")
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
    
    
    // MARK: - Selectors
    
    @objc func handleImageTapped() {
        print("DEBUG: profile image tapped")
    }
    
    @objc func handleReportTapped() {
        
    }
    

    // MARK: - Helpers
    
    func configureUI() {
        
        view.backgroundColor = UIColor(named: viewBackgroundColor)
        
        navigationController?.navigationBar.backIndicatorImage = UIImage()
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage()
        
        let userNameAndType = UIStackView(arrangedSubviews: [username, type])
        userNameAndType.spacing = 4
        userNameAndType.alignment = .leading
        userNameAndType.distribution = .fillProportionally
        
        let stack = UIStackView(arrangedSubviews: [userNameAndType, time, captionLabel])
        stack.axis = .vertical
        stack.setCustomSpacing(3, after: userNameAndType)
        stack.setCustomSpacing(10, after: time)
        stack.alignment = .leading
        
        view.addSubview(profileImageView)
        view.addSubview(stack)
        view.addSubview(customNavigationBar)
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        
        customNavigationBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(FeedImageCell.self, forCellWithReuseIdentifier: feedCell)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        customNavigationBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                                   right: view.rightAnchor, height: 44)
        profileImageView.anchor(top: customNavigationBar.bottomAnchor, left: view.leftAnchor,
                                paddingTop: 15, paddingLeft: 16)
        stack.anchor(top: customNavigationBar.bottomAnchor, left: profileImageView.rightAnchor,
                     right: view.rightAnchor, paddingTop: 20, paddingLeft: 14, paddingRight: 16)
        collectionView.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                              paddingTop: 10, paddingLeft: 16, paddingRight: 16)
        pageControl.anchor(top: collectionView.bottomAnchor, paddingTop: 4)
        pageControl.centerX(inView: collectionView)
        
        let viewModel = FeedDetailViewModel(post: post)
        
        username.text = viewModel.username
        type.text = viewModel.type
        type.textColor = viewModel.typeColor
        time.text = viewModel.timestamp
        captionLabel.text = viewModel.caption
        
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


extension FeedDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCell,
                                                      for: indexPath) as! FeedImageCell
        cell.backgroundColor = .clear
        cell.imageURL = post.images[indexPath.row]
        
        return cell
    }
    
    
}

extension FeedDetailViewController: UICollectionViewDelegate {
    
}

extension FeedDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let page = Int(targetContentOffset.pointee.x / collectionView.frame.width)
        self.pageControl.currentPage = page
    }
}
