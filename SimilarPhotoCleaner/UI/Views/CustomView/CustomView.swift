//
//  CustomView.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 10.04.2025.
//

import Foundation
import UIKit

class CustomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        addSubviews()
        setupSubviews()
        makeConstraints()
    }
    
    func addSubviews() {}
    
    func setupSubviews() {}
    
    func makeConstraints() {}
}
