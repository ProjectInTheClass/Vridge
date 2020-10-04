//
//  NewPostViewController.swift
//  CumtomLoginDemo
//
//  Created by Kang Mingu on 2020/09/12.
//  Copyright © 2020 Kang Mingu. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

protocol TableViewReload {
    func done()
}


class NewPostViewController: UIViewController {
    
    // MARK: - Properties
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var delegate: TableViewReload?
    
    let indicator = UIActivityIndicatorView()
    
    lazy var photoUrl: String = ""
    
    lazy var cancelButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleCancel))
    
    lazy var saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
    
    let contentsTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "contents"
        tf.borderStyle = .roundedRect
        return tf
    }()
    let nameTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "name"
        tf.borderStyle = .roundedRect
        return tf
    }()
    let nicknameTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "nickname"
        tf.borderStyle = .roundedRect
        return tf
    }()
    let yearTf: UITextField = {
        let tf = UITextField()
        tf.placeholder = "year"
        tf.borderStyle = .roundedRect
        return tf
    }()
    let photoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        button.frame.size = CGSize(width: 200, height: 200)
        button.contentMode = .scaleToFill
        return button
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    // MARK: - Selector
    
    @objc func addPhoto() {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    @objc func handleCancel() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        
        var ref: DocumentReference? = nil
        
        ref = db.collection("data").addDocument(data: [
            "contents": contentsTf.text,
            "name": nameTf.text,
            "nickname": nicknameTf.text,
            "year": Int(yearTf.text!), // error?????
            "image": photoUrl
            ], completion: { error in
                if let err = error {
                    print("failed add doc. error: \(err.localizedDescription)")
                }
        })
        
        delegate?.done()
        
        let currentUid = Auth.auth().currentUser?.uid
        
        db.collection("point").document(Sharing.shared.userMail).setData([
            "point": 1], merge: true) { err in
                if let err = err {
                    print(err.localizedDescription)
                }
        }
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - Helper
    
    func configureUI() {
        
        view.backgroundColor = .yellow
        
        view.addSubview(indicator)
        indicator.hidesWhenStopped = true
        indicator.center = view.center
        indicator.style = .large
        indicator.isUserInteractionEnabled = false
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        
        view.addSubview(contentsTf)
        view.addSubview(nameTf)
        view.addSubview(nicknameTf)
        view.addSubview(yearTf)
        view.addSubview(photoButton)
        
        
        contentsTf.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 30)
        photoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: contentsTf.rightAnchor, right: view.rightAnchor, paddingTop: 20, paddingRight: 20, width: 200, height: 200)
        nameTf.anchor(top: contentsTf.bottomAnchor, left: view.leftAnchor, paddingTop: 30)
        nicknameTf.anchor(top: nameTf.bottomAnchor, left: view.leftAnchor, paddingTop: 30)
        yearTf.anchor(top: nicknameTf.bottomAnchor, left: view.leftAnchor, paddingTop: 30)
        
    }
    
}

extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        indicator.startAnimating()
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.photoButton.setBackgroundImage(image, for: .normal)
            self.photoButton.setImage(nil, for: .normal)
            
            guard let mainPhoto = image.jpegData(compressionQuality: 0.3) else { return }
            let filename = NSUUID().uuidString
            let ref = storage.reference(withPath: "/image/\(filename)")
            
            ref.putData(mainPhoto, metadata: nil) { (metaData, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                ref.downloadURL { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    guard let photoUrl = url?.absoluteString else { return }
                    self.photoUrl = photoUrl
                    self.indicator.stopAnimating()
                }
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
}
