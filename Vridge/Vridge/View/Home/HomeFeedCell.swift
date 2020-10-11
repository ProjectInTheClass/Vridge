//
//  HomeFeedCell.swift
//  Vridge_Pages
//
//  Created by Kang Mingu on 2020/10/08.
//

import UIKit

import Kingfisher

protocol HomeFeedCellDelegate: class {
    func reportDidTap()
}

private let feedCell = "FeedCell"

class HomeFeedCell: UITableViewCell {
    
    // MARK: - Properties
    
    weak var delegate: HomeFeedCellDelegate?
    
    var posts: Post? {
        didSet { collectionView.reloadData(); configure() }
    }
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.setDimensions(width: 45, height: 45)
        iv.layer.cornerRadius = 45 / 2
        iv.image = UIImage(systemName: "person")
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .vridgePlaceholderColor
        iv.clipsToBounds = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleImageTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(recognizer)
        return iv
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.setDimensions(width: 284, height: 284)
        layout.scrollDirection = .horizontal
        cv.isPagingEnabled = true
        cv.layer.cornerRadius = 10
        return cv
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .black
        pc.pageIndicatorTintColor = .vridgePlaceholderColor
        pc.isEnabled = false
//        pc.preferredIndicatorImage = UIImage(named: "indicatorUnselect")
        return pc
    }()
    
    lazy var username: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFSemiBold(size: 14)
        label.textColor = .vridgeBlack
        label.text = "user name man"
        return label
    }()
    
    lazy var type: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFRegular(size: 14)
        label.textColor = .vridgeGreen
        label.text = "@ vegan"
        return label
    }()
    
    let time: UILabel = {
        let label = UILabel()
        label.text = "3분 전 업로드"
        label.font = UIFont.SFRegular(size: 12)
        label.textColor = .vridgeGray
        return label
    }()
    
    let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘 점심으로 먹은 샐러드볼! 오늘도 채식 인증 성공! 완전 배부르고 맛있었다. 진짜 상큼하고 아삭하고 건강한 맛"
        label.font = UIFont.SFRegular(size: 14)
        label.textColor = .vridgeBlack
        label.numberOfLines = 0
        return label
    }()
    
    lazy var reportButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "btnReport"), for: .normal)
        button.addTarget(self, action: #selector(handleReportTapped), for: .touchUpInside)
        button.tintColor = .black
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = false
        
        collectionView.register(FeedImageCell.self, forCellWithReuseIdentifier: feedCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
        let userNameAndType = UIStackView(arrangedSubviews: [username, type])
        userNameAndType.spacing = 4
        userNameAndType.alignment = .leading
        userNameAndType.distribution = .fillProportionally
        
        let stack = UIStackView(arrangedSubviews: [userNameAndType, time])
        stack.axis = .vertical
        stack.spacing = 3
        stack.alignment = .leading
        
        let timeAndCaptionStack = UIStackView(arrangedSubviews: [stack, captionLabel])
        timeAndCaptionStack.axis = .vertical
        timeAndCaptionStack.spacing = 10
        timeAndCaptionStack.alignment = .leading
        
        addSubview(profileImageView)
        addSubview(collectionView)
        addSubview(pageControl)
        addSubview(timeAndCaptionStack)
        addSubview(reportButton)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 15, paddingLeft: 16)
        timeAndCaptionStack.anchor(top: topAnchor, left: profileImageView.rightAnchor,
                                   right: rightAnchor, paddingTop: 20, paddingLeft: 14,
                                   paddingRight: 16)
        collectionView.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,
                              paddingTop: 10, paddingLeft: 75, paddingRight: 16)
        pageControl.anchor(top: collectionView.bottomAnchor, bottom: bottomAnchor,
                           paddingTop: 10, paddingBottom: 10)
        pageControl.centerX(inView: collectionView)
        reportButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 11)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func handleReportTapped() {
        delegate?.reportDidTap()
    }
    
    @objc func handleImageTapped() {
        print("DEBUG: profile image tapped")
    }
    
    
    // MARK: - Helpers
    
    func configure() {
        guard let posts = posts else { return }
        
        let numberOfPages = posts.images.count
        pageControl.numberOfPages = numberOfPages
        pageControl.isHidden = numberOfPages == 1 ? true : false
        captionLabel.text = posts.caption
        username.text = posts.user.username
//        prepareForReuse()
    }
    
}

// MARK: - UICollectionViewDataSource

extension HomeFeedCell: UICollectionViewDataSource {
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts!.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCell,
                                                      for: indexPath) as! FeedImageCell
        
        
        
        cell.backgroundColor = .clear
        cell.imageURL = posts?.images[indexPath.row]
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegate

extension HomeFeedCell: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension HomeFeedCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let page = Int(targetContentOffset.pointee.x / collectionView.frame.width)
        self.pageControl.currentPage = page
    }
}
