//
//  TestViewController.swift
//  Vridge
//
//  Created by Kang Mingu on 2020/10/17.
//

import UIKit

private let cellID = "TESTCELL"

class TestViewController: UIViewController {
    
    // MARK: - Properties
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TestCell.self, forCellWithReuseIdentifier: cellID)
        
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                              paddingTop: 30, paddingLeft: 30, paddingBottom: 30, paddingRight: 30)
        
        collectionView.backgroundColor = .yellow
    }

}

extension TestViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return VegieType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! TestCell
        
        cell.backgroundColor = .red
        cell.typeLabel.text = VegieType.allCases[indexPath.item].rawValue
        cell.detailLabel.text = VegieType.allCases[indexPath.item].typeDetail
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = VegieType.allCases[indexPath.item].rawValue
        print("DEBUG: tapped item is \(type)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 3, height: collectionView.frame.width / 3)
    }
    
    
}
