//
//  ViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/02.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .green
        button.setDimensions(width: 200, height: 50)
        button.layer.cornerRadius = 36 / 2
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
    }


}

