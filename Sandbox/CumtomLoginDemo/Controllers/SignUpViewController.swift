//
//  SignUpViewController.swift
//  CumtomLoginDemo
//
//  Created by Kang Mingu on 2020/09/05.
//  Copyright © 2020 Kang Mingu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var firstNameTf: UITextField!
    @IBOutlet weak var lastNameTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var pwTf: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    let indicator = UIActivityIndicatorView()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
    }
    
    
    // MARK: - Helper
    
    // check the field and validate that the data is correct
    // if everything is correct, this method will return nil, otherwise it returns error message
    func validateField() -> String? {
        
        // check that all field are filled in
        if firstNameTf.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTf.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTf.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || pwTf.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            
            return "fill in all fields"
        }
        
        // check if the pw is secured
        
        return nil
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        
        indicator.startAnimating()
        
        // validate field
        let error = validateField()
        
        if error != nil {
            
            indicator.stopAnimating()
            //There's something wrong with the field, show error msg
            showError(error!)
        } else {
            
            // create cleaned version of the data
            let firstName = firstNameTf.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTf.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTf.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pw = pwTf.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            // create user
            Auth.auth().createUser(withEmail: email, password: pw) { (result, err) in
                if let err = err {
                    
                    self.indicator.stopAnimating()
                    // there's an error while creating user
                    print("error : \(err.localizedDescription)")
                    self.showError(err.localizedDescription)
                    
                } else {
                    
                    // user was created successfully, now store firstname and lastname
                    let db = Firestore.firestore()
                    
                    db.collection("users").document(email).setData(["firstname": firstName, "lastname": lastName, "point": 0, "uid": result!.user.uid]) { (error) in
                        
                        if let err = error {
                            print("failed saving user data")
                            self.showError(err.localizedDescription)
                        }
                    }
                    // transition to the home screen
                    self.transitionToHome()
                }
            }
            
            
        }
        
    }
    
    func transitionToHome() {
        
        let vc = HomeViewController()
        navigationController?.pushViewController(vc, animated: true)
        indicator.stopAnimating()
    }
    
    func showError(_ message: String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func setUpElements() {
        
//        errorLabel.alpha = 0
//        errorLabel.numberOfLines = 0
        
        view.backgroundColor = .white
        view.addSubview(indicator)
        indicator.hidesWhenStopped = true
        indicator.center = view.center
        indicator.style = .large
    }

}
