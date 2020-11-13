//
//  EditProfileViewController.swift
//  MyPageView
//
//  Created by Kang Mingu on 2020/10/26.
//

import UIKit

//struct vegieType {
//    var name : String
//    var description : String
//
//    init(name: String, description: String) {
//        self.name = name
//        self.description = description
//    }
//
//}

private let cellID = "Cell"

class EditProfileViewController: UIViewController {

    // MARK: - Properties
    
    var user: User
    
    let tableView = UITableView(frame: .zero, style: .grouped)
    
    let customNavBar = CustomNavBar()
    
    let imagePicker = UIImagePickerController()
    
    var profileImage : UIImage? {
        didSet { tableView.reloadData() }
    }
    
    lazy var uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleUpload), for: .touchUpInside)
        button.setTitle("완료", for: .normal)
//        button.isEnabled = false
        button.tintColor = .vridgeGreen
        button.titleLabel?.font = UIFont.SFSemiBold(size: 16)
        return button
    }()
    
    lazy var currentType = user.vegieType!.rawValue
    
    lazy var newUsername = user.username
    
    lazy var gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
    
    lazy var header = EditProfileHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 319), user: user)
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customNavBar.titleLabel.text = "프로필 수정"
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.post(name: Notification.Name("hidePostButton"), object: nil)
        print("DEBUG: \(currentType)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

        tabBarController?.tabBar.isHidden = false
    }



    // MARK: - Selectors
    
    @objc func viewDidTap() {
        view.endEditing(true)
        print("DEBUG: tapped !!!!")
    }
    
    @objc func handleUpload() {
        // 이 곳에 lottie 필요
        UserService.shared.editProfile(user: user, vegieType: currentType, profileImage: profileImage,
                                       username: newUsername) { (err, ref) in
            let alert = UIAlertController(title: "프로필이 수정되었어요", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: confirm, style: .default, handler: { _ in
                // 이 곳에 Lottie 필요
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    // MARK: - Helpers

    func configureUI() {
        
        tableView.backgroundColor = UIColor(named: "color_all_viewBackground")
        view.backgroundColor = UIColor(named: headerBackgroundColor)
        
        customNavBar.delegate = self
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        navigationController?.navigationBar.barTintColor?.withAlphaComponent(1)
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "back5")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "back5")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: cellID)
        tableView.separatorStyle = .none
        tableView.tableHeaderView = header
        header.delegate = self
        
        tableView.allowsSelection = true
        
        view.addGestureRecognizer(gestureRecognizer)
        gestureRecognizer.cancelsTouchesInView = false
        
        view.addSubview(tableView)
        view.addSubview(customNavBar)
        view.addSubview(uploadButton)
        
        tableView.anchor(top: customNavBar.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor,
                         right: view.rightAnchor)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                            right: view.rightAnchor, height: 44)
        uploadButton.anchor(right: customNavBar.rightAnchor, paddingRight: 13)
        uploadButton.centerY(inView: customNavBar)
        
    }
}

// MARK: - UITableViewDataSource

extension EditProfileViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VegieType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as!  EditProfileCell
        
        cell.vegieTypeName.text = VegieType.allCases[indexPath.row].rawValue
        cell.vegieTypeDescription.text = VegieType.allCases[indexPath.row].typeDetail
        cell.vegieTypeImage.image = VegieType.allCases[indexPath.row].typeImage
        cell.typeColor = VegieType.allCases[indexPath.row].typeColor
        cell.delegate = self
        
        if currentType == VegieType.allCases[indexPath.row].rawValue {
            print("DEBUG: indexpath === \(indexPath.row)")
            tableView.selectRow(at: IndexPath(row: indexPath.row, section: 0), animated: true, scrollPosition: .none)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = EditProfileFooterView()
        footer.delegate = self
        return footer
    }
    
    
}

// MARK: - UITableViewDelegate

extension EditProfileViewController: UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.currentType = VegieType.allCases[indexPath.row].rawValue
//        tableView.reloadData()
    }
    
}

// MARK: - CustomNavBarDelegate

extension EditProfileViewController: CustomNavBarDelegate {
    func backButtonDidTap() {
        
        let alert = UIAlertController(title: "수정 내용을 삭제하시겠어요?",
                                      message: "지금 돌아가면 수정 내용이 삭제돼요",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: confirm, style: .destructive, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
}

// MARK: - EditProfileHeaderViewDelegate

extension EditProfileViewController: EditProfileHeaderViewDelegate {
    
    func usernameDidSet(usernameText: String, canUse: Bool) {
        uploadButton.isEnabled = canUse
        self.newUsername = usernameText
        print("DEBUG: username want to change is === \(self.newUsername)")
        if newUsername == "" {
            uploadButton.isEnabled = false
        }
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
    
    func editProfileImgButtonDidTap() {
        let alert = UIAlertController(title: "프로필 사진 수정", message: "원하는 사진으로 프로필 사진을 수정해주세요", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: camera, style: .default, handler: openCamera))
        alert.addAction(UIAlertAction(title: library, style: .default, handler: openLibrary))
        alert.addAction(UIAlertAction(title: defaultImage, style: .default, handler: selectDefaultImage))
        alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

// MARK: - EditProfileFooterViewDelegate

extension EditProfileViewController: EditProfileFooterViewDelegate {
    
    func deleteAccountDidTap() {
        let alert = UIAlertController(title: deleteAccountTitle, message: deleteAccountMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: deleteAccountAnswer, style: .destructive, handler: { action in /*action 할 메서드나 코드 넣으면됨 여기에다가 */}))
        alert.addAction(UIAlertAction(title: cancel, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate/UINavigationControllerDelegate

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        self.profileImage = image
        header.profileImage.image = image
        dismiss(animated: true, completion: nil)
        
    }
}

// MARK: - UIGestureRecognizerDelegate

extension EditProfileViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}


// MARK: - EditProfileDelegate

extension EditProfileViewController: EditProfileDelegate {
    
    func typeDidTap(type: String) {
        self.currentType = type
    }
    
}

// MARK: - UIViewController Extension
                        
extension UIViewController {
     func hideKeyboard() {
         let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self,
                                                                   action: #selector(UIViewController.dismissKeyboard))
         view.addGestureRecognizer(tap)
     }
 
     @objc func dismissKeyboard()  {
         view.endEditing(true)
     }
 }
