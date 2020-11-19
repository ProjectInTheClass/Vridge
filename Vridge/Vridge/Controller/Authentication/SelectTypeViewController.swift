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
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    var indicator: UIActivityIndicatorView = {
        let idc = UIActivityIndicatorView(style: .large)
        idc.color = UIColor(named: allTextColor)
        idc.hidesWhenStopped = true
        return idc
    }()
    
    var profileImage = UIImage(named: "imgDefaultProfile") {
        didSet { tableView.reloadData() }
    }
    
    let imagePicker = UIImagePickerController()
    
    var userSelectedType: String? {
        didSet { if newUsername?.isEmpty == false {
            okButton.isEnabled = true
        }; print("DEBUG: selected user type ==== \(userSelectedType)") }
    }
    
    var newUsername: String?
    
    lazy var okButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        button.setTitle("완료", for: .normal)
        button.isEnabled = canProceed
        button.tintColor = .vridgeGreen
        button.titleLabel?.font = UIFont.SFSemiBold(size: 16)
        return button
    }()
    
    let customNavigationBar: UIView = {
        let view = UIView()
        view.setDimensions(width: view.frame.width, height: 44)
        view.backgroundColor = UIColor(named: headerBackgroundColor)
        let underLineView = UIView()
        underLineView.backgroundColor = UIColor(named: "color_all_line")
        view.addSubview(underLineView)
        underLineView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: 0.5)
        return view
    }()
    
    lazy var header = SelectTypeHeader(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 319))
    
    lazy var gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
    
    var firstStage = false
    var secondStage = false
    var canProceed = false {
        didSet { okButton.isEnabled = canProceed }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "프로필 설정"
        label.font = UIFont.SFSemiBold(size: 18)
        label.textAlignment = .center
        label.textColor = UIColor(named: allTextColor)
        return label
    }()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    
    // MARK: - Selectors
    
    @objc func viewDidTap() {
        view.endEditing(true)
    }
    
    @objc func handleRegistration() {
        
        indicator.startAnimating()
        
        guard let type = userSelectedType else { return }
        guard let image = profileImage else { return }
        guard let username = newUsername else { return }
        
        AuthService.shared.submitNewUserProfile(indicator: indicator, type: type, photo: image,
                                                username: username) { (err, ref) in
            self.dismiss(animated: true) {
                self.indicator.stopAnimating()
            }
        }
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        view.backgroundColor = UIColor(named: headerBackgroundColor)
        navigationItem.hidesBackButton = true
        
        view.addSubview(customNavigationBar)
        view.addSubview(okButton)
        view.addSubview(tableView)
        view.addSubview(indicator)
        view.addSubview(titleLabel)
        
        view.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.cancelsTouchesInView = false
        
        indicator.center = view.center
        
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        header.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SelectTypeCell.self, forCellReuseIdentifier: cellID)
        tableView.tableHeaderView = header
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: viewBackgroundColor)
        
        customNavigationBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                                   right: view.rightAnchor)
        tableView.anchor(top: customNavigationBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
                         right: view.rightAnchor)
        okButton.centerY(inView: customNavigationBar)
        okButton.anchor(right: view.rightAnchor, paddingRight: 16)
        titleLabel.centerY(inView: customNavigationBar)
        titleLabel.centerX(inView: view)
    }
    
    func openLibrary(_ action: UIAlertAction) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func openCamera(_ action: UIAlertAction) {
        if (UIImagePickerController .isSourceTypeAvailable(.camera)) {
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
    }
    
    func selectDefaultImage(_ action: UIAlertAction) {
        print("DEBUG: set default image here")
        header.profileImage.image = UIImage(named: "imgDefaultProfile")
//        tableView.reloadData()
    }
    
}


extension SelectTypeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VegieType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SelectTypeCell
        
        cell.vegieTypeName.text = VegieType.allCases[indexPath.row].rawValue
        cell.vegieTypeDescription.text = VegieType.allCases[indexPath.row].typeDetail
        cell.vegieTypeImage.image = VegieType.allCases[indexPath.row].typeImage
        cell.typeColor = VegieType.allCases[indexPath.row].typeColor
//        cell.delegate = self
        
        return cell
    }
    
    
    // 테이블뷰 셋팅합시다.
    
    
}

// MARK: - UITableViewDelegate

extension SelectTypeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG: user selected type is === \(VegieType.allCases[indexPath.row].rawValue)")
        self.userSelectedType = VegieType.allCases[indexPath.row].rawValue
        
        self.firstStage = true
        
        if firstStage == true && secondStage == true {
            canProceed = true
        } else {
            canProceed = false
        }
    }
}

// MARK: - SelectTypeHeaderDelegate

extension SelectTypeViewController: SelectTypeHeaderDelegate {
    
    func usernameDidSet(usernameText: String, canUse: Bool) {
        print("DEBUG: new username ====== \(usernameText)")
        self.newUsername = usernameText
        
        secondStage = canUse
        
        if firstStage == true && secondStage == true {
            canProceed = true
        } else {
            canProceed = false
        }
    }
    
    
    func setProfilePhotoDidTap() {
        print("DEBUG: button tapped from the vc")
        let alert = UIAlertController(title: "프로필 사진 수정", message: "원하는 사진으로 프로필 사진을 수정해주세요", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: camera, style: .default, handler: openCamera))
        alert.addAction(UIAlertAction(title: library, style: .default, handler: openLibrary))
        alert.addAction(UIAlertAction(title: defaultImage, style: .default, handler: selectDefaultImage))
        alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}

// MARK: - UIImagePickerControllerDelegate/UINavigationControllerDelegate

extension SelectTypeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        self.profileImage = image
        header.profileImage.image = image
        dismiss(animated: true, completion: nil)
        
    }
}
