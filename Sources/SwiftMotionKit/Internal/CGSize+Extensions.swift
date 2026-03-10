//
//  CGSize+Extensions.swift
//  SwiftMotionKit
//
//  Created by Amrita Arun on 3/9/26.
//

import CoreGraphics

extension CGSize {
    static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(
            width: lhs.width + rhs.width,
            height: lhs.height + rhs.height
        )
    }
}
