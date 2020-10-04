//
//  CameraController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/02.
//

import UIKit

class CameraController: UIViewController {
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    
    // MARK: - Selectors
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleNext() {
        print("Handle next page")
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "글 작성"
        view.backgroundColor = .brown
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소",
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "올리기",
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(handleNext))
    }

}
