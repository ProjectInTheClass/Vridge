//
//  JoiningViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2021/01/02.
//

import UIKit

import Lottie

class JoiningViewController: UIViewController {
    
    // MARK: - Properties
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "btnBack"), for: .normal)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        button.tintColor = UIColor(named: normalButtonColor)
        return button
    }()
    
    let pageTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
        label.font = UIFont.SFRegular(size: 26)
        label.textColor = UIColor(named: allTextColor)
        return label
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = UIImage(systemName: "envelope")
        let view = Utilities().inputContainerView(textField: emailTf, color: .lightGray)
        return view
    }()
    
    private lazy var pwContainerView: UIView = {
        let image = UIImage(systemName: "lock")
        let view = Utilities().inputContainerView(textField: passwordTf, color: .lightGray)
        return view
    }()
    
    private let emailTf: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "이메일")
        return tf
    }()
    
    private let passwordTf: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "비밀번호")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private lazy var pwContainerView2: UIView = {
        let image = UIImage(systemName: "lock")
        let view = Utilities().inputContainerView(textField: passwordTf2, color: .lightGray)
        return view
    }()
    
    private let passwordTf2: UITextField = {
        let tf = Utilities().textField(withPlaceholder: "비밀번호 확인")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음", for: .normal)
        button.tintColor = UIColor(named: viewBackgroundColor)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        button.backgroundColor = .vridgeGray
        button.layer.cornerRadius = 8
        button.isEnabled = false
        return button
    }()
    
    let emailContainerUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .vridgeGreen
        view.isHidden = true
        return view
    }()
    
    let pwContainerUnderLine: UIView = {
        let view = UIView()
        view.backgroundColor = .vridgeGreen
        view.isHidden = true
        return view
    }()
    
    let pwContainerUnderLine2: UIView = {
        let view = UIView()
        view.backgroundColor = .vridgeGreen
        view.isHidden = true
        return view
    }()
    
    let animationView: AnimationView = {
        let av = Lottie.AnimationView(name: loadingAnimation)
        av.loopMode = .loop
        av.isHidden = true
        return av
    }()
    
    lazy var recognizer = UITapGestureRecognizer(target: self, action: #selector(handleKeyboardDown))
    
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    
    // MARK: - Selectors
    
    @objc func handleKeyboardDown() {
        view.endEditing(true)
    }
    
    @objc func handleBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleNext() {
        animationView.isHidden = false
        animationView.play()
        AuthService.shared.joinNewUser(email: emailTf.text!, password: passwordTf.text!,
                                       animation: animationView) { (error, ref) in
            let controller = SelectTypeViewController()
            self.navigationController?.pushViewController(controller, animated: true)
            self.animationView.stop()
            self.animationView.isHidden = true
        }
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        view.addGestureRecognizer(recognizer)
        view.backgroundColor = UIColor(named: viewBackgroundColor)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, pwContainerView, pwContainerView2])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .equalSpacing
        
        stack.addSubview(animationView)
        animationView.center(inView: stack)
        animationView.setDimensions(width: 100, height: 100)
        animationView.contentMode = .scaleAspectFill
        
        view.addSubview(backButton)
        view.addSubview(stack)
        view.addSubview(pageTitleLabel)
        view.addSubview(emailContainerUnderLine)
        view.addSubview(pwContainerUnderLine)
        view.addSubview(pwContainerUnderLine2)
        view.addSubview(nextButton)
        
        emailTf.delegate = self
        passwordTf.delegate = self
        passwordTf2.delegate = self
        
        backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor)
        pageTitleLabel.anchor(top: backButton.bottomAnchor, left: view.leftAnchor,
                              paddingTop: 16, paddingLeft: 36)
        stack.anchor(top: pageTitleLabel.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        emailContainerUnderLine.anchor(left: emailContainerView.leftAnchor,
                                       bottom: emailContainerView.bottomAnchor,
                                       right: emailContainerView.rightAnchor,
                                       paddingLeft: 8, height: 1)
        pwContainerUnderLine.anchor(left: pwContainerView.leftAnchor,
                                       bottom: pwContainerView.bottomAnchor,
                                       right: pwContainerView.rightAnchor,
                                       paddingLeft: 8, height: 1)
        pwContainerUnderLine2.anchor(left: pwContainerView2.leftAnchor,
                                       bottom: pwContainerView2.bottomAnchor,
                                       right: pwContainerView2.rightAnchor,
                                       paddingLeft: 8, height: 1)
        nextButton.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                          paddingTop: 32, paddingLeft: 36, paddingRight: 32, height: 48)
        
    }

}

extension JoiningViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTf {
            emailContainerUnderLine.isHidden = false
        } else if textField == passwordTf {
            pwContainerUnderLine.isHidden = false
        } else {
            pwContainerUnderLine2.isHidden = false
        }
        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if emailTf.text!.count > 4 && passwordTf.text!.count > 5 && passwordTf.text == passwordTf2.text {
            print("DEBUG: enabled")
            nextButton.backgroundColor = .vridgeGreen
            nextButton.isEnabled = true
        } else {
            nextButton.backgroundColor = .vridgeGray
            nextButton.isEnabled = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTf {
            emailContainerUnderLine.isHidden = true
        } else if textField == passwordTf {
            pwContainerUnderLine.isHidden = true
        } else {
            pwContainerUnderLine2.isHidden = true
        }
    }
}
