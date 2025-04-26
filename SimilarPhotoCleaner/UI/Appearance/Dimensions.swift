//
//  Dimensions.swift
//  SimilarPhotoCleaner
//
//  Created by Nikita Filonov on 10.04.2025.
//

import Foundation
import SnapKit
import QuartzCore

enum Dimensions {
    
    enum Spacing {
        
        static let offset: CGFloat = 8
        
        static let doubleOffset: CGFloat = 16
        
        static let tripleOffset: CGFloat = 24
        
        static let quadripleOffset: CGFloat = 32
    }
    
    enum Radius {
        
        static let smallCorner: CGFloat = 14
        
        static let corner: CGFloat = 20
        
        static let button: CGFloat = 24
    }
    
    enum Size {
        
        static let button = CGSize(width: 44, height: 44)
        
        static let thumbnail = CGSize(width: 183, height: 215)
        
        static let smallThumbnail = CGSize(width: 91, height: 107)
    }
    
    enum AnimationTime {
        
        static let small: Double = 0.2
        
        static let normal: Double = 0.3
    }
}

extension ConstraintOffsetTarget where Self == CGFloat {
    
    static var offset: CGFloat { Dimensions.Spacing.offset }
    
    static var doubleOffset: CGFloat { Dimensions.Spacing.doubleOffset }
    
    static var tripleOffset: CGFloat { Dimensions.Spacing.tripleOffset }
    
    static var quadripleOffset: CGFloat { Dimensions.Spacing.quadripleOffset }
}

extension ConstraintInsetTarget where Self == CGFloat {
    
    static var offset: CGFloat { Dimensions.Spacing.offset }
    
    static var doubleOffset: CGFloat { Dimensions.Spacing.doubleOffset }
    
    static var quadripleOffset: CGFloat { Dimensions.Spacing.quadripleOffset }
}

extension CALayer {
    
    func roundedCorners() {
        cornerRadius = Dimensions.Radius.corner
    }
    
    func roundedCornersSmall() {
        cornerRadius = Dimensions.Radius.smallCorner
    }
    
    func roundedCornersButton() {
        cornerRadius = Dimensions.Radius.button
    }
}

extension CGSize {
    
    static var button: CGSize { Dimensions.Size.button }
    
    static var thumbnail: CGSize { Dimensions.Size.thumbnail }
    
    static var smallThumbnail: CGSize { Dimensions.Size.smallThumbnail }
}

extension TimeInterval {
    
    static var small: Double { Dimensions.AnimationTime.small }
    
    static var normal: Double { Dimensions.AnimationTime.normal }
}

extension RunLoop.SchedulerTimeType.Stride {
    
    static let debounce: RunLoop.SchedulerTimeType.Stride = 0.01
}
