//
//  RankingSecondView.swift
//  Vridge_Pages
//
//  Created by Kang Mingu on 2020/10/09.
//

import UIKit

protocol RankingSecondViewDelegate: class {
    func selection(_ view: RankingSecondView, didselect index: Int)
}

private let reusableCell = "reuseCell"

class RankingSecondView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: RankingSecondViewDelegate?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private let underLine: UIView = {
        let view = UIView()
        view.backgroundColor = .vridgeBlack
        return view
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addSubview(underLine)
        
        underLine.anchor(left: leftAnchor, bottom: bottomAnchor,
                         width: frame.width / 2, height: 2)
    }
    
    
    // MARK: - Selectors
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        addSubview(collectionView)
        
        collectionView.register(RankingSecondViewCell.self, forCellWithReuseIdentifier: reusableCell)
        
        collectionView.addConstraintsToFillView(self)
    }
}


extension RankingSecondView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RankingFilterOptions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusableCell,
                                                      for: indexPath) as! RankingSecondViewCell
        
        let option = RankingFilterOptions(rawValue: indexPath.row)
        cell.option = option
        
        return cell
    }
    
}

extension RankingSecondView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let xPosition = cell?.frame.origin.x ?? 0
        
        UIView.animate(withDuration: 0.3) {
            self.underLine.frame.origin.x = xPosition
        }
        
        delegate?.selection(self, didselect: indexPath.row)
        
    }
}

extension RankingSecondView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = CGFloat(RankingFilterOptions.allCases.count)
        
        return CGSize(width: frame.width / count, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
