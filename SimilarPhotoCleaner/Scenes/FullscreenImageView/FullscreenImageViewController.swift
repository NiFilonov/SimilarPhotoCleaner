//
//  FullscreenImageViewController.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 20.04.2025.
//

import UIKit
import Combine
import Photos
import DifferenceKit

final class FullscreenImageViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let spacing: CGFloat = 5
        static let collectionViewHeight: CGFloat = CGSize.smallThumbnail.height
    }
    
    // MARK: - Subviews
    
    lazy private var imageView: UIImageView = {
        $0.contentMode = .scaleAspectFit
        $0.frame = sourceFrame
        return $0
    }(UIImageView())
    
    lazy private var dismissButton: UIButton = {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return $0
    }(UIButton(type: .system))
    
    lazy private var collectionView: HorizonalCollectionView = {
        $0.register(cellType: ImageCell.self)
        $0.set(delegate: self, dataSource: self)
        return $0
    }(HorizonalCollectionView(itemSize: .smallThumbnail, 
                              minimumLineSpacing: Constants.spacing))
    
    // MARK: - Private Properties
    
    private let viewModel: FullscreenImageViewModelable
    private var items = [AnyDifferentiable]()
    private var cancellables = Set<AnyCancellable>()
    private let sourceFrame: CGRect
    weak private var coordinator: FullscreenImageCoordinator?
    
    // MARK: - Initialization
    
    init(viewModel: FullscreenImageViewModelable, sourceFrame: CGRect, coordinator: FullscreenImageCoordinator) {
        self.viewModel = viewModel
        self.sourceFrame = sourceFrame
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewAppear()
        setupBindings()
        setupUI()
        animateAppearance()
    }
    
    // MARK: - Private Configuration
    
    private func setupUI() {
        view.backgroundColor = .white
        addSubviews()
        makeConstraints()
        updateCollectionView(target: viewModel.items)
    }
    
    private func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(dismissButton)
        view.addSubview(collectionView)
    }
    
    private func makeConstraints() {
        collectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(Constants.collectionViewHeight)
        }
        
        imageView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(collectionView.snp.top)
        }
        
        dismissButton.snp.makeConstraints {
            $0.size.equalTo(CGSize.button)
            $0.leading.top.equalTo(view.safeAreaLayoutGuide).offset(.doubleOffset)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupBindings() {
        viewModel.selectedImagePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] asset in
                self?.imageView.load(asset: asset)
            })
            .store(in: &cancellables)
    }
    
    private func updateCollectionView(target: [AnyDifferentiable]) {
        collectionView.reload(source: items, target: target) { [unowned self] items in
            self.items = items
        }
    }
    
    private func animateAppearance() {
        UIView.animate(withDuration: .normal) {
            self.imageView.frame = self.view.bounds
        }
    }
    
    private func handleImageCellTap(indexPath: IndexPath) {
        viewModel.selectImage(index: indexPath.row)
    }
    
    // MARK: - Actions
    
    @objc private func handleDismiss() {
        UIView.animate(withDuration: .normal, animations: {
            self.imageView.frame = self.sourceFrame
        }, completion: { _ in
            self.dismiss(animated: false)
        })
    }
}

// MARK: - UICollectionViewDataSource

extension FullscreenImageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row].base
        if let viewModel = item as? ImageCellViewModel {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ImageCell.self) as ImageCell
            cell.viewModel = viewModel
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate

extension FullscreenImageViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleImageCellTap(indexPath: indexPath)
    }
}
