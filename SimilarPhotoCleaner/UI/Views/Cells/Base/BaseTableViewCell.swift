//
//  BaseTableViewCell.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 13.04.2025.
//

import Reusable
import UIKit

open class BaseTableViewCell<T>: UITableViewCell, Reusable {
    
    public var viewModel: T? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }

            update(with: viewModel)
        }
    }
    
    required public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initCell()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    private func initCell() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        
        addSubviews()
        makeConstraints()
    }
    
    open func addSubviews() {}
    
    open func makeConstraints() {}
    
    open func update(with viewModel: T) {}
}

