//
//  SelectTypeViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/15.
//

import UIKit

private let cellID = "testCell"

class SelectTypeViewController: UIViewController {
    
    // MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let profileImageButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        btn.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        btn.setDimensions(width: 120, height: 120)
        return btn
    }()
    
    var type: String?
    
    private let tableView = UITableView()
    
    private lazy var okButton: UIBarButtonItem = {
        let btn = UIBarButtonItem(title: "ok", style: .plain, target: self, action: #selector(handleRegistration))
        return btn
    }()
    
    var indicator: UIActivityIndicatorView = {
        let idc = UIActivityIndicatorView(style: .large)
        idc.color = .black
        idc.hidesWhenStopped = true
        return idc
    }()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    
    // MARK: - Selectors
    
    @objc func handleAddPhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleRegistration() {
        guard let profileImage = profileImage else {
            print("DEBUG: please select profile image")
            return
        }
        guard let type = type else {
            print("DEBUG: please select vegie type")
            return
        }
        
        
        // existed user change vegie type으로 실행 시켜보기
        AuthService.shared.submitNewUserProfile(viewController: self, type: type,
                                             photo: profileImage) { (err, ref) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .systemPink
        
        navigationItem.rightBarButtonItem = okButton
        
        view.addSubview(profileImageButton)
        view.addSubview(tableView)
        view.addSubview(indicator)
        indicator.center = view.center
        
        tableView.register(TypeTestCell.self, forCellReuseIdentifier: cellID)
        tableView.delegate = self
        tableView.dataSource = self
        
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        profileImageButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 100)
        profileImageButton.centerX(inView: view)
        
        tableView.anchor(top: profileImageButton.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 40, paddingLeft: 8, paddingRight: 8)
    }
    


}

extension SelectTypeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        self.profileImage = image
        
        profileImageButton.layer.cornerRadius = 120 / 2
        profileImageButton.layer.masksToBounds = true
        profileImageButton.imageView?.contentMode = .scaleAspectFill
        profileImageButton.imageView?.clipsToBounds = true
        profileImageButton.layer.borderColor = UIColor.white.cgColor
        profileImageButton.layer.borderWidth = 1
        
        self.profileImageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
}

extension SelectTypeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VegieType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TypeTestCell
        
        cell.textLabel?.text = VegieType.allCases[indexPath.row].rawValue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.type = VegieType.allCases[indexPath.row].rawValue
        print("DEBUG: \(type)")
    }
    
    
    
}
