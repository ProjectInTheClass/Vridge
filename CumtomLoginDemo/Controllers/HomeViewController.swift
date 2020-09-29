//
//  HomeViewController.swift
//  CumtomLoginDemo
//
//  Created by Kang Mingu on 2020/09/08.
//  Copyright © 2020 Kang Mingu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

private let cellId = "cell"

class HomeViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    let db = Firestore.firestore()
    
    let logOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log out", for: .normal)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.backgroundColor = .black
        button.tintColor = .white
        return button
    }()
    
    let tableView = UITableView()
    let firstLabel = UILabel()
    var names: [dataModel] = []
    lazy var addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAdd))
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
//        addDoc()
        readDoc()
    }
    
    
    // MARK: - Selector
    
    @objc func handleAdd() {
        let vc = UINavigationController(rootViewController: NewPostViewController())
        vc.modalPresentationStyle = .popover
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
            presentMainController()
        } catch {
            print("something wrong")
        }
    }
    
    
    // MARK: - Helper
    
    func presentMainController() {
        
        navigationController?.popViewController(animated: true)
        
//        DispatchQueue.main.async {
//            let controller = LoginViewController()
//            let nav = UINavigationController(rootViewController: controller)
//            nav.modalPresentationStyle = .fullScreen
//            self.present(nav, animated: true, completion: nil)
//        }
    }
    
    func configureUI() {
        
        navigationItem.rightBarButtonItem = addButton
        
        if let user = Auth.auth().currentUser {
            print("nice! you're now signed in as \(user.uid), email: \(user.email ?? "unknown")")
        } else {
            presentMainController()
        }
        
        view.backgroundColor = .systemPink
        
        view.addSubview(logOutButton)
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        tableView.allowsSelection = false
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -160),
            
            tableView.topAnchor.constraint(equalTo: logOutButton.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
        
        ])
        
//        firstLabel.text = Auth.auth().currentUser?.email ?? "idk"
        
        
    }
    
//    func addDoc() {
//
//        var ref: DocumentReference? = nil
//
//        ref = db.collection("data").addDocument(data: [
//            "name": "Johnny",
//            "year": 1991,
//            "nickname": "puss"
//            ], completion: { error in
//                if let err = error {
//                    print("failed add doc. error: \(err.localizedDescription)")
//                }
//        })
//
//    }
    
    func readDoc() {
        
        db.collection("data").getDocuments { (snapshot, error) in
            
            if let err = error {
                print("failed reading data : \(err.localizedDescription)")
                return
            } else {
                
                var data = dataModel()
                for doc in snapshot!.documents {
                    
                    data.name = doc["name"] as! String
                    data.nickName = doc["nickname"] as! String
                    data.year = doc["year"] as! Int
                    data.contents = doc["contents"] as! String
                    data.image = doc["image"] as! String
                    self.names.append(data)
                }
                self.tableView.reloadData()
            }
            
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        cell.textLabel?.text = names[indexPath.row].name
        cell.detailTextLabel?.text = String(names[indexPath.row].year)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = DetailViewController()
        
        Sharing.shared.name = names[indexPath.row].name
        Sharing.shared.contents = names[indexPath.row].contents
        Sharing.shared.image = names[indexPath.row].image
        
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension HomeViewController: TableViewReload {
    
    func done() {
        self.tableView.reloadData()
    }
    
    
}
