//
//  HapticsManager.swift
//  SwiftMotionKit
//
//  Created by Amrita Arun on 3/10/26.
//


//
// HapticsManager.swift
// SwiftMotionKit
//
// Simple, safe haptics helper with rate limiting.
// Works only on platforms that can import UIKit (iOS, tvOS).
//

import Foundation

#if canImport(UIKit)
import UIKit
#endif

public final class HapticsManager {
    public static let shared = HapticsManager()

    // Minimum interval between identical haptics (seconds)
    private let defaultMinInterval: TimeInterval = 0.12

    // store last fired times keyed by name
    private var lastFired: [String: TimeInterval] = [:]
    private let queue = DispatchQueue(label: "com.swiftmotionkit.haptics", qos: .userInteractive)

    private init() {}

    private func shouldFire(key: String, minInterval: TimeInterval) -> Bool {
        let now = Date().timeIntervalSince1970
        var should = false
        queue.sync {
            let last = lastFired[key] ?? 0
            if now - last >= minInterval {
                lastFired[key] = now
                should = true
            } else {
                should = false
            }
        }
        return should
    }

    // MARK: - Public helpers

    /// Light selection haptic (short subtle tap)
    public func selection(minInterval: TimeInterval? = nil) {
        #if canImport(UIKit)
        let key = "selection"
        let minI = minInterval ?? defaultMinInterval
        guard shouldFire(key: key, minInterval: minI) else { return }
        let gen = UISelectionFeedbackGenerator()
        gen.prepare()
        gen.selectionChanged()
        #endif
    }

    /// Impact haptic (light/medium/heavy)
    public func impact(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium, minInterval: TimeInterval? = nil) {
        #if canImport(UIKit)
        let key = "impact.\(style)"
        let minI = minInterval ?? defaultMinInterval
        guard shouldFire(key: key, minInterval: minI) else { return }
        let gen = UIImpactFeedbackGenerator(style: style)
        gen.prepare()
        gen.impactOccurred()
        #endif
    }

    /// Notification haptic (success/warning/error)
    public func notification(_ type: UINotificationFeedbackGenerator.FeedbackType = .success, minInterval: TimeInterval? = nil) {
        #if canImport(UIKit)
        let key = "notification.\(type)"
        let minI = minInterval ?? defaultMinInterval
        guard shouldFire(key: key, minInterval: minI) else { return }
        let gen = UINotificationFeedbackGenerator()
        gen.prepare()
        gen.notificationOccurred(type)
        #endif
    }

    /// Reset rate limiting (useful for tests)
    public func reset() {
        queue.sync {
            lastFired.removeAll()
        }
    }
}
