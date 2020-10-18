//
//  HomeFeedCell.swift
//  Vridge_Pages
//
//  Created by Kang Mingu on 2020/10/08.
//

import UIKit

import Kingfisher

protocol HomeFeedCellDelegate: class {
    func currentUserAmendTapped(sender: Post, row: Int)
    func reportButtonTapped(sender: Post, row: Int)
}

private let feedCell = "FeedCell"

class HomeFeedCell: UITableViewCell {
    
    // MARK: - Properties
    
    weak var delegate: HomeFeedCellDelegate?
    
    var posts: Post? {
        didSet { collectionView.reloadData(); configure() }
    }
    
    var row: Int?
    
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
        pc.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
//        pc.preferredIndicatorImage = UIImage(named: "indicatorUnselect") //ios 14 and above
        return pc
    }()
    
    lazy var username: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFSemiBold(size: 14)
        label.textColor = .vridgeBlack
        return label
    }()
    
    lazy var type: UILabel = {
        let label = UILabel()
        label.font = UIFont.SFRegular(size: 14)
        label.textColor = .vridgeGreen
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(cellToFirst),
                                               name: Notification.Name("cellToFirst"), object: nil)
        
        contentView.isUserInteractionEnabled = false
        
        collectionView.register(FeedImageCell.self, forCellWithReuseIdentifier: feedCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        
        let userNameAndType = UIStackView(arrangedSubviews: [username, type])
        userNameAndType.spacing = 4
        userNameAndType.alignment = .leading
        userNameAndType.distribution = .fillProportionally
        
        let stack = UIStackView(arrangedSubviews: [userNameAndType, time, captionLabel])
        stack.axis = .vertical
        stack.setCustomSpacing(3, after: userNameAndType)
        stack.setCustomSpacing(10, after: time)
        stack.alignment = .leading
        
        addSubview(profileImageView)
        addSubview(collectionView)
        addSubview(pageControl)
        addSubview(stack)
        addSubview(reportButton)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 15, paddingLeft: 16)
        stack.anchor(top: topAnchor, left: profileImageView.rightAnchor,
                                   right: rightAnchor, paddingTop: 20, paddingLeft: 14,
                                   paddingRight: 16)
        collectionView.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor,
                              paddingTop: 10, paddingLeft: 75, paddingRight: 16)
        pageControl.anchor(top: collectionView.bottomAnchor, bottom: bottomAnchor,
                           paddingTop: 4, paddingBottom: 4)
        pageControl.centerX(inView: collectionView)
        reportButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 11)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Selectors
    
    @objc func cellToFirst() {
        // e.g 맨 위에 있던 포스트의 '두 번째' 사진을 보고있다가 그 상태에서 새로운 포스트로 사진을 '두 장이상' 올리면
        // 새로운 포스트의 '두 번째'로 스크롤이 이미 이동해있는 것을 방지하기 위해 첫 번 째 셀로 이동시키는 코드.
        // 페이지 컨트롤도 0으로 바꿔줌
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
        pageControl.currentPage = 0
        print("DEBUG: celltoFIRst man")
    }
    
    @objc func handleReportTapped() {
        guard let posts = posts else { return }
        guard let row = row else { return }
        
        if posts.user.isCurrentUser {
            delegate?.currentUserAmendTapped(sender: posts, row: row)
        } else {
            delegate?.reportButtonTapped(sender: posts, row: row)
        }
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
        captionLabel.isHidden = posts.caption == "" ? true : false
        username.text = posts.user.username
        profileImageView.kf.setImage(with: posts.user.profileImageURL)
        var timestamp: String {
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
            formatter.maximumUnitCount = 1
            formatter.unitsStyle = .abbreviated
            formatter.calendar?.locale = Locale(identifier: "ko_KR")
            let now = Date()
            return formatter.string(from: posts.timestamp, to: now) ?? "2분 전"
        }
        time.text = "\(timestamp) 전 업로드"
        
    }
    
}

// MARK: - UICollectionViewDataSource

extension HomeFeedCell: UICollectionViewDataSource {
    
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
