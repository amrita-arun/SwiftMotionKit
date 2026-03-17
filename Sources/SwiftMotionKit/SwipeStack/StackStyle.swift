//
//  StackStyle.swift
//  SwiftMotionKit
//
//  Created by Amrita Arun on 3/17/26.
//

import CoreGraphics

public enum StackStyle {
    case none
    case vertical(offset: CGFloat = 12)
    case scaleAndOffset(scaleStep: CGFloat = 0.03, offsetStep: CGFloat = 12)
    case rotated(angleStep: Double = 3, offsetStep: CGFloat = 12)
    case randomized(
        rotationRange: ClosedRange<Double>,
        offsetRange: ClosedRange<CGFloat>
    )
}

