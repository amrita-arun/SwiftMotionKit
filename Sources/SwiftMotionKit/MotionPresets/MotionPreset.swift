//
//  MotionPreset.swift
//  SwiftMotionKit
//
//  Created by Amrita Arun on 3/9/26.
//

import SwiftUI

public enum MotionPreset {
    case soft
    case snappy
    case heavy
    case custom(response: Double, dampingFraction: Double)

    @available(macOS 10.15, *)
    var animation: Animation {
        switch self {
        case .soft:
            return .interactiveSpring(response: 0.5, dampingFraction: 0.85, blendDuration: 0.2)
        case .snappy:
            return .interactiveSpring(response: 0.35, dampingFraction: 0.75, blendDuration: 0.1)
        case .heavy:
            return .interactiveSpring(response: 0.8, dampingFraction: 0.9, blendDuration: 0.2)
        case let .custom(response, dampingFraction):
            return .interactiveSpring(response: response, dampingFraction: dampingFraction, blendDuration: 0.2)
        }
    }
}
