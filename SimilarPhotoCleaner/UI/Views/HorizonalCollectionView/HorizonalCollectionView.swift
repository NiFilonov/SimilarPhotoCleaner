//
//  HorizonalCollectionView.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 20.04.2025.
//

import UIKit
import SnapKit
import Reusable
import DifferenceKit

final class HorizonalCollectionView: CustomView {
    
    // MARK: - Subviews

    lazy private var collectionView: UICollectionView = {
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        return $0
    }(UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout))
    
    lazy private var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        $0.scrollDirection = .horizontal
        $0.itemSize = itemSize
        $0.minimumLineSpacing = minimumLineSpacing
        $0.minimumInteritemSpacing = .zero
        $0.estimatedItemSize = .zero
        return $0
    }(UICollectionViewFlowLayout())
    
    // MARK: - Private Properties
    
    private let itemSize: CGSize!
    private let minimumLineSpacing: CGFloat!
    
    // MARK: - Initialization
    
    init(itemSize: CGSize, minimumLineSpacing: CGFloat) {
        self.itemSize = itemSize
        self.minimumLineSpacing = minimumLineSpacing
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func addSubviews() {
        addSubview(collectionView)
    }
    
    override func makeConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Internal Methhods
    
    func reload(source: [AnyDifferentiable], target: [AnyDifferentiable], _ handler: (([AnyDifferentiable]) -> Void)) {
        let changes = StagedChangeset(source: source, target: target)
        collectionView.reload(using: changes) { source in
            handler(source)
        }
    }
    
    func set(delegate: UICollectionViewDelegate?, dataSource: UICollectionViewDataSource?) {
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
    }
    
    func register<T: UICollectionViewCell>(cellType: T.Type) where T: Reusable {
        collectionView.register(cellType: cellType)
    }
    
    func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        collectionView.cellForItem(at: indexPath)
    }
}
