//
//  Random.swift
//  SwiftMotionKit
//
//  Created by Amrita Arun on 3/17/26.
//

import Foundation

func pseudoRandom(from id: AnyHashable) -> Double {
    var hasher = Hasher()
    hasher.combine(id)
    let hash = hasher.finalize()
    return Double(abs(hash % 1000)) / 1000.0
}

func randomInRange(id: AnyHashable, min: Double, max: Double) -> Double {
    let base = pseudoRandom(from: id)
    return min + (max - min) * base
}
