//
//  BaseCollectionViewCell.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 13.04.2025.
//

import Reusable
import UIKit

open class BaseCollectionViewCell<T>: UICollectionViewCell, Reusable {
    
    public var viewModel: T? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }

            update(with: viewModel)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initCell()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    private func initCell() {
        backgroundColor = .clear
        
        addSubviews()
        makeConstraints()
    }
    
    open func addSubviews() {}
    
    open func makeConstraints() {}
    
    open func update(with viewModel: T) {}
}
