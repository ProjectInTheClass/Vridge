//
//  TestViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/04.
//

import UIKit

import YPImagePicker

private let reusableIdentifier = "PostPhotoCell"

class TestViewController: UIViewController {
    
    // MARK: - Properties
    
    private let textView: CaptionTextView = {
        let tv = CaptionTextView()
        tv.isUserInteractionEnabled = true
        tv.layer.borderWidth = 1
        tv.placeholderlabel.text = "오늘 하루 채식 식단을 기록해봐. \n단, 채식과 관련없는 내용은 지양해줘! \n* 200자까지 작성 할 수 있어"
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
        present(picker, animated: true, completion: nil)
        
        picker.didFinishPicking { (items, cancelled) in
            if cancelled {
                self.picker.dismiss(animated: true, completion: nil)
                return
            }
            
            var imageArray = [UIImage]()
            
            for item in items {
                switch item {
                case .photo(let photo): imageArray.append(photo.image) // array에 이미지들을 저장.
                default: print("Error")
                }
            }
            self.images = imageArray
            self.collectionView.reloadData()
            self.picker.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNext() {
        print("Handle add")
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "글 작성"
        picker.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "올리기",
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(handleNext))
        
        view.addSubview(textView)
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(PostPhotoCell.self, forCellWithReuseIdentifier: reusableIdentifier)
        
        textView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                        right: view.rightAnchor, paddingTop: 20,
                        paddingLeft: 16, paddingRight: 16, height: 180)
        collectionView.anchor(top: textView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                              paddingTop: 8, paddingLeft: 8, paddingRight: 8, height: 100)
    }

    
}


// MARK: - YPImagePickerDelegate

extension TestViewController: YPImagePickerDelegate, UINavigationControllerDelegate {
    
    func noPhotos() {
        print("DEBUG: no photos")
    }
    
    func shouldAddToSelection(indexPath: IndexPath, numSelections: Int) -> Bool {
        print("DEBUG: \(indexPath), \(numSelections)")
        return true
    }
}

// MARK: - UICollectionviewDataSource

extension TestViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableIdentifier,
                                                      for: indexPath) as! PostPhotoCell
        cell.backgroundColor = .systemGroupedBackground
        cell.imageView.image = images?[indexPath.item] ?? UIImage(systemName: "plus.circle")
        return cell
    }
}

// MARK: - UICollectionviewDelegate

extension TestViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleAddPhoto()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TestViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.width - 20) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
