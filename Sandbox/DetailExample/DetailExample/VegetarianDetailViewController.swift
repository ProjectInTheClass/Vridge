//
//  VegetarianDetailViewController.swift
//  DetailExample
//
//  Created by Ted Kim on 2020/10/04.
//  Copyright © 2020 김루희. All rights reserved.
//

import UIKit

class VegetarianDetailViewController: UIViewController {

    
    @IBOutlet weak var detailLabel: UILabel!
    
    var data: String = ""
    var idx = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        detailLabel.text = data
        
    }
    


}
