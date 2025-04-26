//
//  MainViewController.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 10.04.2025.
//

import Foundation
import UIKit
import DifferenceKit
import Combine

final class MainViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let headerHeight: CGFloat = 180
        static let cellHeight: CGFloat = 286
    }
    
    // MARK: - Subviews
    
    private let headerView: HeaderView = {
        $0.set(title: Strings.Main.Header.title)
        return $0
    }(HeaderView())
    
    lazy private var tableView: UITableView = {
        $0.register(cellType: PhotosCell.self)
        $0.backgroundColor = .primaryBackgroundColor
        $0.layer.roundedCorners()
        $0.separatorStyle = .none
        $0.dataSource = self
        $0.delegate = self
        return $0
    }(UITableView())
    
    lazy private var button: Button = {
        $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        $0.configure(title: Strings.Main.Action.title(Int.zero), icon: Assets.Icons.delete.image)
        return $0
    }(Button())
    
    private let activityIndicator: UIActivityIndicatorView = {
        $0.hidesWhenStopped = true
        return $0
    }(UIActivityIndicatorView(style: .large))
    
    // MARK: - Private Properties
    
    private var viewModel: MainViewModelable
    private var items = [AnyDifferentiable]()
    private var cancellables = Set<AnyCancellable>()
    private weak var coordinator: MainCoordinator?
    
    // MARK: - Initialization
    
    init(viewModel: MainViewModelable, coordinator: MainCoordinator? = nil) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await viewModel.viewAppear()
        }
    }
    
    // MARK: - Private Configuration
    
    private func setupUI() {
        addSubviews()
        makeConstraints()
        setupSubviews()
    }
    
    private func addSubviews() {
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(button)
        view.addSubview(activityIndicator)
    }
    
    private func makeConstraints() {
        headerView.snp.makeConstraints {
            $0.leading.trailing.top.equalTo(view)
            $0.height.equalTo(Constants.headerHeight)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalTo(view)
            $0.top.equalTo(headerView.snp.bottom).inset(.doubleOffset)
        }
        
        button.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(.tripleOffset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(.quadripleOffset)
        }
        
        activityIndicator.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
        }
    }
    
    private func setupSubviews() {
        let bottomOffset = view.safeAreaInsets.bottom
        + CGFloat(button.intrinsicContentSize.height)
        + Dimensions.Spacing.quadripleOffset
        + Dimensions.Spacing.doubleOffset
        tableView.contentInset = UIEdgeInsets(top: .zero,
                                       left: .zero,
                                       bottom: bottomOffset,
                                       right: .zero)
    }
    
    // MARK: - Private Methods
    
    private func setupListener() {
        viewModel.itemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.updateTableView(targetItems: items)
            }
            .store(in: &cancellables)
        
        viewModel.selectedItemsCountPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] photosCount, selectedPhotosCount in
                self?.updateHeaderView(photosCount: photosCount, selectedPhotosCount: selectedPhotosCount)
                self?.updateButton(selectedPhotosCount: selectedPhotosCount)
            }
            .store(in: &cancellables)
        
        viewModel.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                self?.updateActivityState(isLoading: isLoading)
            }
            .store(in: &cancellables)
        
        viewModel.completionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cleaningResult in
                self?.coordinator?.showCompletion(cleaningResult: cleaningResult)
            }
            .store(in: &cancellables)
    }
    
    private func updateHeaderView(photosCount: Int, selectedPhotosCount: Int) {
        headerView.update(description: Strings.Main.Header.description(photosCount, selectedPhotosCount))
    }
    
    private func updateButton(selectedPhotosCount: Int) {
        button.set(title: Strings.Main.Action.title(selectedPhotosCount))
        button.isEnabled = selectedPhotosCount > .zero
    }
    
    private func updateTableView(targetItems: [AnyDifferentiable]) {
        let changes = StagedChangeset(source: items, target: targetItems)
        tableView.reload(using: changes, with: .none) { [weak self] data in
            self?.items = data
        }
    }
    
    private func updateActivityState(isLoading: Bool)  {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func buttonTapped() {
        viewModel.deleteRequested()
    }
}

// MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let viewModel = items[indexPath.row].base as? PhotosCellViewModel {
            let cell = tableView.dequeueReusableCell(for: indexPath) as PhotosCell
            cell.viewModel = viewModel
            cell.viewModel?.output = self
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}

// MARK: - PhotosCellViewModelOutput

extension MainViewController: PhotosCellViewModelOutput {
    
    func photosCellViewModel(_ photosCellViewModel: PhotosCellViewModel, imageData: ImageData) {
        guard let window = tableView.window else { return }
        let imageFrame = imageData.coordinateSpace.convert(imageData.imageCellBounds, to: window)
        coordinator?.showFullscreenImage(model: imageData.model,asset: imageData.asset, sourceFrame: imageFrame)
    }
}
