//
//  TestViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/04.
//

import UIKit

import YPImagePicker
import Firebase
import Kingfisher
import Lottie

protocol PostingViewControllerDelegate: class {
    func updateUser()
}

private let reusableIdentifier = "PostPhotoCell"

class PostingViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: PostingViewControllerDelegate?
    
    private var configuration: PostingConfiguration
    private lazy var viewModel = PostingViewModel(config: configuration)
    private var post: Post?
    
    let actionSheetViewModel = ActionSheetViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "글 작성"
        label.font = UIFont.SFSemiBold(size: 18)
        return label
    }()
    
    private var addphotoAttributedText: NSAttributedString {
        let text = NSMutableAttributedString(string: "채식 사진", attributes: [.font: UIFont.SFRegular(size: 14)!,.foregroundColor: UIColor.vridgeGreen])
        text.append(NSAttributedString(string: "을 추가해주세요", attributes: [.font: UIFont.SFRegular(size: 14) ?? .systemFont(ofSize: 14), .foregroundColor: UIColor.black]))
        return text
    }
    
    private lazy var addPhotoTitle: UILabel = {
        let label = UILabel()
        label.attributedText = addphotoAttributedText
        return label
    }()
    
    private var writeCaptionAttributedText: NSAttributedString {
        let text = NSMutableAttributedString(string: "채식 식단", attributes: [.font: UIFont.SFRegular(size: 14) ?? .systemFont(ofSize: 14),.foregroundColor: UIColor.vridgeGreen])
        text.append(NSAttributedString(string: "을 기록해주세요", attributes: [.font: UIFont.SFRegular(size: 14) ?? .systemFont(ofSize: 14), .foregroundColor: UIColor.black]))
        return text
    }
    
    private lazy var captionTitle: UILabel = {
        let label = UILabel()
        label.attributedText = writeCaptionAttributedText
        return label
    }()
    
    let textView: CaptionTextView = {
        let tv = CaptionTextView()
        tv.isUserInteractionEnabled = true
        tv.font = UIFont.SFRegular(size: 14)
        tv.textContainerInset = UIEdgeInsets(top: 15, left: 12, bottom: 15, right: 15)
        tv.layer.cornerRadius = 8
        tv.layer.borderWidth = 2
        tv.layer.borderColor = UIColor.vridgePostingBorder.cgColor
        return tv
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        flowLayout.scrollDirection = .horizontal
        cv.backgroundColor = .clear
        return cv
    }()
    
    lazy var uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleUpload), for: .touchUpInside)
        button.setTitle("완료", for: .normal)
        button.tintColor = .vridgeGreen
        button.titleLabel?.font = UIFont.SFSemiBold(size: 16)
        return button
    }()
    
    let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(named: "btnClose"), for: .normal)
        btn.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        return btn
    }()
    
    private lazy var photoAddView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "btnAddImage")
        img.contentMode = .scaleAspectFit
        img.isUserInteractionEnabled = true
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(addPhotoTapped))
        img.addGestureRecognizer(recognizer)
        return img
    }()
    
    private var images: [UIImage]?
    
    private var config = ImagePicker.shared.imagePickerView
    lazy var picker = YPImagePicker(configuration: config)
    
    private let indicator: AnimationView = {
        let av = Lottie.AnimationView(name: uploadAnimation)
        av.setDimensions(width: 160, height: 160)
        av.contentMode = .scaleAspectFill
        av.animationSpeed = 2.0
        av.loopMode = .loop
        return av
    }()
    
    
    // MARK: - Lifecycle
    
    init(config: PostingConfiguration, post: Post? = nil) {
        self.configuration = config
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        switch configuration {
        case .post:
            return
        case .amend(_):
            configureAmend()
        }
    }
    
    
    // MARK: - Selectors
    
    @objc func addPhotoTapped() {
        switch configuration {
        case .post:
            handleAddPhoto()
        case .amend(_):
            present(actionSheetViewModel.noPhotoChangeAllowed(self), animated: true, completion: nil)
        }
    }
    
    @objc func handleCancel() {
        if textView.hasText {
            present(actionSheetViewModel.leavingPostPage(self), animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleUpload() {
        
        switch configuration {
        case .post:
            if images == nil {
                present(actionSheetViewModel.photoUploadAlert(self), animated: true, completion: nil)
            } else {
                
                textView.addSubview(indicator)
                indicator.centerX(inView: textView)
                indicator.centerY(inView: textView)
                self.uploadButton.isEnabled = false
                
                guard let caption = textView.text else { return }
                guard let images = images else { return }
                PostService.shared.uploadPost(caption: caption, photos: images,
                                              indicator: indicator, view: self) { (err, ref) in
                    if let err = err {
                        print("DEBUG: failed posting with error \(err.localizedDescription)")
                    }
                    NotificationCenter.default.post(name: Notification.Name("cellToFirst"), object: nil)
                }
//                self.delegate?.updateUser()
                print("DEBUG: upload from posting view")
            }
        case .amend(_):
            
            textView.addSubview(indicator)
            indicator.centerX(inView: textView)
            indicator.centerY(inView: textView)
            self.uploadButton.isEnabled = false
            
            guard let caption = textView.text else { return }
            guard let post = post else  { return }
            let controller = HomeViewController()
            PostService.shared.amendUploadPost(viewController: controller, caption: caption, post: post) { (err, ref) in
                NotificationCenter.default.post(name: Notification.Name("fetchAgain"), object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK: - Helpers
    
    func configureAmend() {
        textView.placeholderLabel.text = nil
        textView.text = viewModel.captionLabel
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.barTintColor = UIColor.white.withAlphaComponent(1)
        textView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "btnClose"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(handleCancel))
        
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uploadButton)
        navigationItem.rightBarButtonItem?.tintColor = .vridgeGreen
        
        view.addSubview(addPhotoTitle)
        view.addSubview(collectionView)
        view.addSubview(captionTitle)
        view.addSubview(textView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addSubview(photoAddView)
        
        photoAddView.anchor(top: collectionView.topAnchor, left: collectionView.leftAnchor)
        
        collectionView.register(PostPhotoCell.self, forCellWithReuseIdentifier: reusableIdentifier)
        
        addPhotoTitle.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                             paddingTop: 20, paddingLeft: 20)
        collectionView.anchor(top: addPhotoTitle.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                              paddingTop: 13, paddingLeft: 20, height: 123)
        captionTitle.anchor(top: collectionView.bottomAnchor, left: view.leftAnchor,
                            paddingTop: 30, paddingLeft: 20)
        textView.anchor(top: captionTitle.bottomAnchor, left: view.leftAnchor,
                        right: view.rightAnchor, paddingTop: 13, paddingLeft: 20, paddingRight: 20, height: 130)
    }
    
    func handleAddPhoto() {
        ImagePicker.shared.addPhoto(view: self, picker: picker) { images in
            self.images = images
            self.collectionView.reloadData()
            self.picker.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UICollectionviewDataSource

extension PostingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch configuration {
        case .post: return images == nil ? 3 : images!.count
        case .amend(_): return images?.count ?? 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier,
                                                      for: indexPath) as! PostPhotoCell
        
        switch configuration {
        case .post:
            cell.imageView.image = images?[indexPath.item]
        case .amend(_):
            cell.imageView.kf.setImage(with: URL(string: viewModel.images[indexPath.item]))
        }
        
        
        return cell
    }
}

// MARK: - UICollectionviewDelegate

extension PostingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PostingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 123, height: 123)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 131, bottom: 0, right: 10)
    }
}


extension PostingViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        guard let words = textView.text else { return true }
        
        let newLength = words.count + text.count - range.length
        return newLength <= 200
    }
}
