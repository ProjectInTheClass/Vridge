//
//  RankingViewController.swift
//  Vridge_Pages
//
//  Created by Kang Mingu on 2020/10/09.
//

import UIKit

private let cellID = "rankingCell"

class RankingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let topView = RankingCustomTopView()
    private let secondView = RankingSecondView()
    
    private var selectedFilter: RankingFilterOptions = .all {
        didSet { tableView.reloadData() }
    }
    
    //    private var allRank = [User]()
    //    private var myTypeRank = [User]()
    //
    //    private var currentDataSource: [User] {
    //        switch selectedFilter {
    //        case .all: return allRank
    //        case .myType: return myTypeRank
    //        }
    //    }
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        print("DEBUG: \(selectedFilter)")
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
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(topView)
        view.addSubview(secondView)
        view.addSubview(tableView)
        
        topView.delegate = self
        secondView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(RankingCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = .vridgeWhite
        
        topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                       right: view.rightAnchor, height: 56)
        secondView.anchor(top: topView.bottomAnchor, left: view.leftAnchor,
                          right: view.rightAnchor, height: 44)
        tableView.anchor(top: secondView.bottomAnchor, left: view.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor)
        
    }
}

// MARK: - UITableViewDataSource/Delegate

extension RankingViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID,
                                                 for: indexPath) as! RankingCell
        cell.backgroundColor = .vridgeWhite
        cell.number.text = "\(indexPath.row + 9994)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = RankingHeader()
        header.backgroundColor = .white
        return header
    }
}

extension RankingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 243
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 92
    }
    
}


// MARK: - RankingCustomTopViewDelegate

extension RankingViewController: RankingCustomTopViewDelegate {
    
    func handleFindMe() {
        print("DEBUG: Handle find me")
    }
    
    func handleBackToMain() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension RankingViewController: RankingSecondViewDelegate {
    
    func selection(_ view: RankingSecondView, didselect index: Int) {
        guard let filter = RankingFilterOptions(rawValue: index) else { return }
        self.selectedFilter = filter
        print("DEBUG: filter is \(selectedFilter)")
    }
}


