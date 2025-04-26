//
//  ImageData.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 20.04.2025.
//

import UIKit
import Photos

struct ImageData {
    let asset: PHAsset
    let model: PhotosModel
    let imageCellBounds: CGRect
    let coordinateSpace: UICoordinateSpace
}
