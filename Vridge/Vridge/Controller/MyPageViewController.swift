//
//  MyPageViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/04.
//

import UIKit

class MyPageViewController: UIViewController {
    

    // MARK: - Properties

    @IBOutlet var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.navigationBar.isHidden = true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        // 테이블 헤더
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 295))
        header.backgroundColor = .systemRed
        tableView.tableHeaderView = header
        
        let headerLabel = UILabel(frame: CGRect(x: 20, y: 11, width: 60, height: 21))
        headerLabel.text = "Vridge"
        headerLabel.font = UIFont(name: "futura", size: 18)

        header.addSubview(headerLabel)
    }
    
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        navigationController?.navigationBar.isHidden = false
    }
    

}

extension UIViewController: UITableViewDelegate {
        
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 156
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label  = UILabel()
        label.text = "내 식단"
        
        let button: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("내 식단", for: .normal)
            return button
        }()
        
        return button
    }
 
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension UIViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Test"
        return cell
    }
    
    
}

