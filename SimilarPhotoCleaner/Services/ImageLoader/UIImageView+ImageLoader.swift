//
//  UIImageView+ImageLoader.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 23.04.2025.
//

import UIKit
import Photos

extension UIImageView {
    
    func load(asset: PHAsset, size: CGSize? = nil) {
        if let size {
            ImageLoader.default.loadThumbnail(for: asset, targetSize: size) { [weak self] image in
                self?.image = image
            }
        } else {
            ImageLoader.default.loadFullImage(for: asset) { [weak self] image in
                self?.image = image
            }
        }
    }
}
