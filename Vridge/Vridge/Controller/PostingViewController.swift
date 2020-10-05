//
//  TestViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/04.
//

import UIKit

import YPImagePicker

private let reusableIdentifier = "PostPhotoCell"

class PostingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let textView: CaptionTextView = {
        let tv = CaptionTextView()
        tv.isUserInteractionEnabled = true
        tv.layer.borderWidth = 1
        tv.placeholderlabel.text = "오늘 하루 채식 식단을 기록해봐. \n단, 채식과 관련없는 내용은 지양해줘!\n최소 1장, 최대 3장의 사진을 꼭 올려라잉 \n* 200자까지 작성 할 수 있어"
        tv.layer.borderColor = UIColor.systemGroupedBackground.cgColor
        return tv
    }()
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        flowLayout.scrollDirection = .horizontal
        cv.backgroundColor = .clear
        return cv
    }()
    
    private var images: [UIImage]?
    
    var config = ImagePicker.shared.imagePickerView
    lazy var picker = YPImagePicker(configuration: config)
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    // MARK: - Selectors
    
    func handleAddPhoto() {
        ImagePicker.shared.addPhoto(view: self, picker: picker) { images in
            self.images = images
            self.collectionView.reloadData()
            self.picker.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
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
            print("DEBUG: Upload photos and words to realtime database.")
        }
        
        // 글 에 담길 항목 모두 담고 + REF_USER.uid.child(point) += 1
        // PostService.shared.upload
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "글 작성"
        textView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "올리기",
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(handleNext))
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
                              paddingTop: 8, paddingLeft: 8, paddingRight: 8, height: 140)
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
}


extension PostingViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        guard let words = textView.text else { return true }
        
        let newLength = words.count + text.count - range.length
        return newLength <= 200
    }
}
