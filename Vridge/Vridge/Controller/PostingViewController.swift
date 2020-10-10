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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "글 작성"
        label.font = UIFont.SFRegular(size: 20)
        return label
    }()
    
    private let textView: CaptionTextView = {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    // MARK: - Selectors
    
    @objc func handleCancel() {
        
        if textView.hasText {
            let alert = UIAlertController(title: "이 페이지를 벗어날 거야?",
                                          message: "지금까지 작성한\n글들은 저장되지 않아…!",
                                          preferredStyle: .alert)
            let noButton = UIAlertAction(title: "아니오", style: .default, handler: nil)
            let yesButton = UIAlertAction(title: "예", style: .destructive) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(noButton)
            alert.addAction(yesButton)
            present(alert, animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleNext() {
        if images == nil {
            let alert = UIAlertController(title: "",
                                          message: "최소 한 장의 사진을 올려주세요.",
                                          preferredStyle: .alert)
            let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
        } else {
            guard let caption = textView.text else { return }
            guard let images = images else { return }
            
            PostService.shared.uploadPost(caption: caption, photos: images,
                                          indicator: indicator, view: self) { (err, ref) in
                if let err = err {
                    print("DEBUG: failed with posting with error \(err.localizedDescription)")
                }
            }
        }
        // 글에 담길 항목 모두 담고 + REF_USER.uid.child(point) += 1
        // PostService.shared.upload
    }
    
    
    // MARK: - Helpers
    
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
        cell.imageView.image = images?[indexPath.item] ?? UIImage(systemName: "plus.circle")
        cell.imageView.layer.borderWidth = images?[indexPath.item] == nil ? 0: 4
        return cell
    }
}

// MARK: - UICollectionviewDelegate

extension PostingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleAddPhoto()
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
