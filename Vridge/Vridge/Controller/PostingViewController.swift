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

private let reusableIdentifier = "PostPhotoCell"

class PostingViewController: UIViewController {
    
    // MARK: - Properties
    
    private var configuration: PostingConfiguration
    private lazy var viewModel = PostingViewModel(config: configuration)
    private var post: Post?
    
    let actionSheetViewModel = ActionSheetViewModel()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "글 작성"
        label.font = UIFont.SFRegular(size: 20)
        return label
    }()
    
    let textView: CaptionTextView = {
        let tv = CaptionTextView()
        tv.isUserInteractionEnabled = true
        tv.contentInset = UIEdgeInsets(top: -6, left: 0, bottom: 0, right: 0)
//        tv.layer.borderWidth = 1
//        tv.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        return tv
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        flowLayout.scrollDirection = .horizontal
        cv.backgroundColor = .clear
        return cv
    }()
    
    lazy var completeButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        button.setTitle("완료", for: .normal)
        button.tintColor = .vridgeGreen
        button.titleLabel?.font = UIFont.SFSemiBold(size: 16)
        return button
    }()
    
    
    private var images: [UIImage]?
    
    private var config = ImagePicker.shared.imagePickerView
    lazy var picker = YPImagePicker(configuration: config)
    
    private let indicator = UIActivityIndicatorView()
    
    
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
    
    @objc func handleCancel() {
        if textView.hasText {
            present(actionSheetViewModel.leavingPostPage(self), animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleNext() {
        
        switch configuration {
        case .post:
            if images == nil {
                present(actionSheetViewModel.photoUploadAlert(self), animated: true, completion: nil)
            } else {
                guard let caption = textView.text else { return }
                guard let images = images else { return }
                PostService.shared.uploadPost(caption: caption, photos: images,
                                              indicator: indicator, view: self) { (err, ref) in
                    if let err = err {
                        print("DEBUG: failed posting with error \(err.localizedDescription)")
                    }
                    NotificationCenter.default.post(name: Notification.Name("cellToFirst"), object: nil)
                }
            }
        case .amend(_):
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
        
        textView.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.style = .large
        indicator.color = .vridgeGreen
        indicator.hidesWhenStopped = true
        indicator.centerX(inView: textView)
        indicator.centerY(inView: textView)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back5"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completeButton)
        navigationItem.rightBarButtonItem?.tintColor = .vridgeGreen
        
        view.addSubview(textView)
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PostPhotoCell.self, forCellWithReuseIdentifier: reusableIdentifier)
        
        textView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                        right: view.rightAnchor, paddingTop: 20,
                        paddingLeft: 16, paddingRight: 16, height: 180)
        collectionView.anchor(top: textView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                              paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 140)// height 수정필요
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
        return images?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier,
                                                      for: indexPath) as! PostPhotoCell
        
        switch configuration {
        
        case .post:
            cell.imageView.image = images?[indexPath.item] ?? UIImage(systemName: "plus.circle")
            cell.imageView.layer.borderWidth = images?[indexPath.item] == nil ? 0: 4
            cell.numberingLabel.isHidden = images?[indexPath.item] == nil
            cell.numberingLabel.text = String(indexPath.item + 1)
        case .amend(_):
            cell.imageView.kf.setImage(with: URL(string: viewModel.images[indexPath.item]))
            cell.imageView.layer.borderWidth = 4
            cell.numberingLabel.text = String(indexPath.item + 1)
        }
        return cell
    }
}

// MARK: - UICollectionviewDelegate

extension PostingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch configuration {
        case .post:
            handleAddPhoto()
        case .amend(_):
            present(actionSheetViewModel.noPhotoChangeAllowed(self), animated: true, completion: nil)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PostingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 20) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
