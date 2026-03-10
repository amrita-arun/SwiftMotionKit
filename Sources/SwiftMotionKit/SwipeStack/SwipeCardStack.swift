//
//  SwipeCardStack.swift
//  SwiftMotionKit
//
//  Created by Amrita Arun on 3/9/26.
//

import SwiftUI

@available(macOS 10.15, *)
public struct SwipeCardStack<Item: Identifiable, Content: View>: View {

    // MARK: - Public Configuration

    private let items: [Item]
    private let visibleCardCount: Int
    private let swipeThreshold: SwipeThreshold
    private let allowedDirections: Set<SwipeDirection>
    private let rotationMultiplier: CGFloat
    private let releasePreset: MotionPreset
    private let snapBackPreset: MotionPreset
    private let onSwipe: ((Item, SwipeDirection) -> Void)?
    private let content: (Item) -> Content

    // MARK: - Internal State

    @State private var currentIndex: Int = 0

    // MARK: - Initializer

    public init(
        items: [Item],
        visibleCardCount: Int = 3,
        swipeThreshold: SwipeThreshold = .percentage(0.25),
        allowedDirections: Set<SwipeDirection> = [.left, .right],
        rotationMultiplier: CGFloat = 12,
        releasePreset: MotionPreset = .snappy,
        snapBackPreset: MotionPreset = .soft,
        onSwipe: ((Item, SwipeDirection) -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.visibleCardCount = visibleCardCount
        self.swipeThreshold = swipeThreshold
        self.allowedDirections = allowedDirections
        self.rotationMultiplier = rotationMultiplier
        self.releasePreset = releasePreset
        self.snapBackPreset = snapBackPreset
        self.onSwipe = onSwipe
        self.content = content
    }

    // MARK: - Body

    public var body: some View {
        ZStack {
            ForEach(visibleItems) { item in
                content(item)
            }
        }
    }

    // MARK: - Helpers

    private var visibleItems: ArraySlice<Item> {
        items[currentIndex..<min(currentIndex + visibleCardCount, items.count)]
    }
}
