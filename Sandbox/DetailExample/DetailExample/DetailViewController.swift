//
//  DetailViewController.swift
//  DetailExample
//
//  Created by Kang Mingu on 2020/10/04.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var list: VegetarianTypeModel?
    @IBOutlet weak var centerLabel: UILabel!
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
        navigationItem.title = list?.type
        
        centerLabel.text = list?.description
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
