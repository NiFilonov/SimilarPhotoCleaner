//
//  MainViewModel.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 10.04.2025.
//

import Foundation
import DifferenceKit
import Combine
import Photos

typealias PhotosCountData = (photosCount: Int, selectedImagesCount: Int)

// MARK: - Protocol

protocol MainViewModelable {
    var items: [AnyDifferentiable] { get }
    var itemsPublisher: AnyPublisher<[AnyDifferentiable], Never> { get }
    var selectedItemsCount: Int { get }
    var selectedItemsCountPublisher: AnyPublisher<PhotosCountData, Never> { get }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var completionPublisher: PassthroughSubject<CleaningResult, Never> { get }
    func viewAppear() async
    func deleteRequested()
}

final class MainViewModel: MainViewModelable {
    
    // MARK: - Dependencies
    
    private let photoManager: PhotoManagerProtocol
    private let imageGroupingService: ImageGroupingServiceProtocol
    private let appLifecycleService: AppLifecycleServiceProtocol
    
    // MARK: - Published Properties
    
    @Published private var model: MainModel?
    @Published private(set) var items = [AnyDifferentiable]()
    var itemsPublisher: AnyPublisher<[AnyDifferentiable], Never> {
        $items.eraseToAnyPublisher()
    }
    @Published private(set) var selectedItemsCount: Int = .zero
    var selectedItemsCountPublisher: AnyPublisher<PhotosCountData, Never> {
        $selectedItemsCount.map({ (self.model?.imagesCount ?? .zero, $0) }).eraseToAnyPublisher()
    }
    @Published private var isLoading = false
    var isLoadingPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }
    private(set) var completionPublisher = PassthroughSubject<CleaningResult, Never>()
    
    // MARK: - Private Properties
    
    private var foregroundTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    private var selectedAssets: [PHAsset] {
        model?.photos.flatMap({ $0.imagesModels.compactMap({ $0.isSelected ? $0.asset : nil }) }) ?? []
    }
    
    // MARK: - Initialization
    
    init(photoManager: PhotoManagerProtocol,
         imageGroupingService: ImageGroupingServiceProtocol,
         appLifecycleService: AppLifecycleServiceProtocol) {
        self.photoManager = photoManager
        self.imageGroupingService = imageGroupingService
        self.appLifecycleService = appLifecycleService
        setupLifecycleObserver()
    }
    
    // MARK: - Interface
    
    func viewAppear() async {
        await regroupPhotosIfNeeded()
    }
    
    func deleteRequested() {
        isLoading = true
        let selectedAssets = selectedAssets
        guard !selectedAssets.isEmpty else { return }
        Task { [weak self] in
            guard let success = try? await self?.photoManager.deleteAssets(selectedAssets) else { return }
            if success {
                await self?.clearSelectedData()
                self?.isLoading = false
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func setupLifecycleObserver() {
        foregroundTask = Task { [weak self] in
            guard let stream = await self?.appLifecycleService.observeForeground() else { return }
            
            for await _ in stream {
                await self?.appWillEnterForeground()
            }
        }
    }
    
    private func appWillEnterForeground() async {
        await regroupPhotosIfNeeded()
    }
    
    private func regroupPhotosIfNeeded() async {
        isLoading = true
        guard let photos = try? await photoManager.getPhotos() else { return }
        let groupedPhotos = await imageGroupingService.groupSimilar(fetchedAsset: photos)
        if let model {
            model.update(imagesCount: photos.count, photos: groupedPhotos)
        } else {
            model = MainModel(imagesCount: photos.count, photos: groupedPhotos)
            setupBindings()
            isLoading = false
        }
    }
    
    private func updateItems() {
        if let model {
            items = model.photos.map({ photoModel in
                return AnyDifferentiable(PhotosCellViewModel(id: photoModel.id,
                                                             title: Strings.Main.Cell.title(photoModel.imagesModels.count),
                                                             model: photoModel)) })
        } else {
            items = []
        }
    }
    
    private func updateSelectedItemsCount() {
        selectedItemsCount = model?.photos.flatMap({ $0.imagesModels }).filter({ $0.isSelected }).count ?? .zero
    }
    
    private func clearSelectedData() async {
        let selectedAssets = selectedAssets
        let selectedItemsCount = selectedAssets.count
        guard let size = try? await photoManager.calculateTotalSizeOfAssets(selectedAssets) else { return }
        model?.imagesCount -= selectedItemsCount
        removeSelectedAssetsFromModel()
        updateSelectedItemsCount()
        completionPublisher.send(CleaningResult(count: selectedItemsCount, size: size))
    }
    
    private func removeSelectedAssetsFromModel() {
        guard let model else { return }
        model.photos = model.photos
            .map { $0.copyWithUnselectedPhotos() }
            .filter { $0.imagesModels.count > 1 }
        updateItems()
    }
    
    private func reload() {
        guard let model else { return }
        model.photos.removeAll(where: { $0.imagesModels.count < 2 })
        updateItems()
    }
    
    private func setupBindings() {
        guard let model else { return }
        model.$photos
            .sink { [weak self] photoModels in
                self?.updateItems()
            }
            .store(in: &cancellables)
        
        model.photos.flatMap { model in model.imagesModels.map { $0.selectionPublisher }}
            .forEach { model in
                model
                    .debounce(for: .debounce, scheduler: RunLoop.main)
                    .sink { [weak self] _ in
                        self?.updateSelectedItemsCount()
                    }
                    .store(in: &cancellables)
            }
    }
}
