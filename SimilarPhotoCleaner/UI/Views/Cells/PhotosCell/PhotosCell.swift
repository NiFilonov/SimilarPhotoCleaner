//
//  PhotosCell.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 13.04.2025.
//

import Foundation
import UIKit
import DifferenceKit
import Combine

final class PhotosCell: BaseTableViewCell<PhotosCellViewModel> {
    
    // MARK: - Constants
    
    private enum Constants {
        static let height: CGFloat = 215
        static let spacing: CGFloat = 5
        static let headerHeight: CGFloat = 47
    }
    
    // MARK: - Subviews
    
    lazy private var header: PhotosHeaderView = {
        $0.delegate = self
        return $0
    }(PhotosHeaderView())
    
    lazy private var collectionView: HorizonalCollectionView = {
        $0.set(delegate: self, dataSource: self)
        $0.register(cellType: ImageCell.self)
        return $0
    }(HorizonalCollectionView(itemSize: .thumbnail,
                              minimumLineSpacing: Constants.spacing))
    
    // MARK: - Private Properties
    
    private var items = [AnyDifferentiable]()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }
    
    override func addSubviews() {
        contentView.addSubview(header)
        contentView.addSubview(collectionView)
    }
    
    override func makeConstraints() {
        header.snp.makeConstraints {
            $0.height.equalTo(Constants.headerHeight)
            $0.centerX.equalToSuperview()
            $0.leading.top.equalToSuperview().offset(.doubleOffset)
        }
        
        collectionView.snp.makeConstraints {
            $0.height.equalTo(Constants.height)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(header.snp.bottom).offset(.offset)
        }
    }
    
    // MARK: - Internal Methods
    
    override func update(with viewModel: PhotosCellViewModel) {
        header.update(title: viewModel.title,
                      actionTitle: viewModel.selectionButtonTitle)
        collectionView.reload(source: items, target: viewModel.items) { items in
            self.items = items
        }
        
        viewModel.model.imagesModels.forEach { model in
            model.selectionPublisher
                .debounce(for: .debounce, scheduler: RunLoop.main)
                .sink { [weak self] _ in
                    self?.updateHeaderButton()
                }
                .store(in: &cancellables)
        }
    }
    
    // MARK: - Private Methods
    
    private func updateHeaderButton() {
        header.update(actionTitle: viewModel?.selectionButtonTitle ?? .empty)
    }
    
    private func handleImageCellTap(indexPath: IndexPath) {
        guard let asset = viewModel?.model.imagesModels[indexPath.row].asset,
              let model = viewModel?.model,
              let imageCell = collectionView.cellForItem(at: indexPath) as? ImageCell else { return }
        
        viewModel?.didTappedOn(imageData: ImageData(asset: asset, model: model, imageCellBounds: imageCell.bounds, coordinateSpace: imageCell))
    }
}

// MARK: - PhotosHeaderViewDelegate

extension PhotosCell: PhotosHeaderViewDelegate {
    
    func selectionChanged(_ photosHeaderView: PhotosHeaderView) {
        viewModel?.onAllSelectionClicked()
    }
}

// MARK: - UICollectionViewDataSource

extension PhotosCell: UICollectionViewDataSource {
    
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

extension PhotosCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleImageCellTap(indexPath: indexPath)
    }
}
