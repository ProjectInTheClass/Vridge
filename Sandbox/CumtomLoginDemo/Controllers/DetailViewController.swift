//
//  DetailViewController.swift
//  CumtomLoginDemo
//
//  Created by Kang Mingu on 2020/09/10.
//  Copyright © 2020 Kang Mingu. All rights reserved.
//

import UIKit
import Kingfisher
import FirebaseFirestore

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    let db = Firestore.firestore()
    
    let titleLabel = UILabel()
    let contentsLabel = UILabel()
    let imageView = UIImageView()
    
    let comment = UILabel()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    
    // MARK: - Selector
    
    @objc func handleOK() {
        
        var ref: DocumentReference? = nil
        
//        ref = db.collection("data").addDocument(data: [
//            "name": textField.text ?? "no one",
//            "year": 1991,
//            "nickname": "puss"
//            ], completion: { error in
//                if let err = error {
//                    print("failed add doc. error: \(err.localizedDescription)")
//                }
//        })
        
    }
    
    
    // MARK: - Helper
    
    func configureUI() {
        
        view.backgroundColor = .white
        
        navigationItem.title = Sharing.shared.name ?? "NONE"
        
        view.addSubview(titleLabel)
        view.addSubview(contentsLabel)
        view.addSubview(imageView)
        view.addSubview(comment)
        
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 30, paddingLeft: 30)
        contentsLabel.anchor(top: titleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 30, paddingRight: 30)
        imageView.anchor(top: contentsLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 30, paddingLeft: 30, paddingRight: 30, height: 300)
        comment.anchor(top: imageView.bottomAnchor, paddingTop: 20)
        comment.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        titleLabel.text = "title : \(Sharing.shared.name)"
        contentsLabel.text = "content : \(Sharing.shared.contents.replacingOccurrences(of: "\\n", with: "\n"))"
        contentsLabel.numberOfLines = 0
        
        let url = URL(string: Sharing.shared.image)
        if Sharing.shared.image == "" {
            imageView.image = UIImage(systemName: "person")
        } else {
            imageView.kf.setImage(with: url)
        }
        
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.isMultipleTouchEnabled = true
        comment.text = Sharing.shared.comment
    }
    

}
