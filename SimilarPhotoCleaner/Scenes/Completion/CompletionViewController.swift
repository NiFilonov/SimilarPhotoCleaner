//
//  CompletionViewController.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 25.04.2025.
//

import Foundation
import UIKit
import SnapKit

final class CompletionViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let titleHeight: CGFloat = 50
        static let descriptionItemHeight: CGFloat = 54
        static let descriptionHeight: CGFloat = 70
    }
    
    // MARK: - Subviews
    
    private var imageView: UIImageView = {
        $0.image = Assets.Images.completion.image
        $0.contentMode = .scaleAspectFit
        return $0
    }(UIImageView())
    
    private var titleLabel: UILabel = {
        $0.text = Strings.Completion.title
        $0.textColor = .primaryTextColor
        $0.font = .title
        $0.textAlignment = .center
        return $0
    }(UILabel())
    
    lazy private var descriptionViewSize: DescriptionView = {
        $0.set(image: Assets.Images.stars.image,
                            title: Strings.Completion.Info.size(clearingResult.count,
                                                                String(format: "%.1f", clearingResult.size)),
                            selectedText: Strings.Completion.Info.sizeSelection(clearingResult.count))
        return $0
    }(DescriptionView())

    lazy private var descriptionViewTime: DescriptionView = {
        $0.set(image: Assets.Images.time.image,
               title: Strings.Completion.Info.time(clearingResult.count),
                            selectedText: Strings.Completion.Info.timeSelection(clearingResult.count))
        return $0
    }(DescriptionView())
    
    private let descriptionLabel: UILabel = {
        $0.textColor = .descriptionColor
        $0.font = .description2
        $0.text = Strings.Completion.description
        $0.textAlignment = .center
        $0.numberOfLines = .zero
        return $0
    }(UILabel())
    
    lazy private var stackView: UIStackView = {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.addArrangedSubview(imageView)
        $0.addArrangedSubview(titleLabel)
        $0.addArrangedSubview(wrapIntoContainer(descriptionViewSize))
        $0.addArrangedSubview(wrapIntoContainer(descriptionViewTime))
        $0.addArrangedSubview(wrapIntoContainer(descriptionLabel, verticalOffset: 0))
        return $0
    }(UIStackView())
    
    lazy private var button: Button = {
        $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        $0.configure(title: Strings.Completion.button)
        return $0
    }(Button())
    
    // MARK: - Private Properties
    
    weak private var coordinator: CompletionCoordinator?
    private let clearingResult: CleaningResult!
    
    // MARK: - Initialization
    
    init(clearingResult: CleaningResult, coordinator: CompletionCoordinator) {
        self.clearingResult = clearingResult
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Configuration
    
    private func setupUI() {
        view.backgroundColor = .primaryBackgroundColor
        addSubviews()
        makeConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(stackView)
        view.addSubview(button)
    }
    
    private func makeConstraints() {
        button.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(.tripleOffset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(.quadripleOffset)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.lessThanOrEqualTo(button.snp.top).inset(.doubleOffset)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(Constants.titleHeight)
        }
        
        descriptionViewSize.snp.makeConstraints {
            $0.height.equalTo(Constants.descriptionItemHeight)
        }
        
        descriptionViewTime.snp.makeConstraints {
            $0.height.equalTo(Constants.descriptionItemHeight)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.height.equalTo(Constants.descriptionHeight)
        }
    }
    
    // MARK: - Private Methods
    
    private func wrapIntoContainer(_ wrappingView: UIView,
                                   verticalOffset: ConstraintOffsetTarget = .doubleOffset,
                                   horizontalOffset: ConstraintOffsetTarget = .quadripleOffset) -> UIView {
        let container = UIView()
        container.addSubview(wrappingView)
        wrappingView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.top.equalToSuperview().offset(verticalOffset)
            $0.leading.greaterThanOrEqualToSuperview().offset(horizontalOffset)
        }
        return container
    }
    
    // MARK: - Actions
    
    @objc
    private func buttonTapped() {
        coordinator?.finish()
        dismiss(animated: true)
    }
}
