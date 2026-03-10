//
//  SwipeThreshold.swift
//  SwiftMotionKit
//
//  Created by Amrita Arun on 3/9/26.
//

import CoreGraphics

public enum SwipeThreshold {
    case distance(CGFloat)
    case percentage(CGFloat)

    func value(for width: CGFloat) -> CGFloat {
        switch self {
        case let .distance(distance):
            return distance
        case let .percentage(percent):
            return width * percent
        }
    }
}
