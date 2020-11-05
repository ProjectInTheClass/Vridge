//
//  FeedDetailViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/11/05.
//

import UIKit

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
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.heightAnchor.constraint(equalTo: cv.widthAnchor).isActive = true
        layout.scrollDirection = .horizontal
        cv.isPagingEnabled = true
        return cv
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = UIColor(named: "indicatorSelectedColor")
        pc.pageIndicatorTintColor = .vridgePlaceholderColor
        pc.isEnabled = false
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
        
        view.addSubview(customNavigationBar)
        customNavigationBar.delegate = self
        
        customNavigationBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                                   right: view.rightAnchor, height: 44)
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
