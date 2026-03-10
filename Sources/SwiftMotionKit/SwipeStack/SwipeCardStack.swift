//
//  SwipeCardStack.swift
//  SwiftMotionKit
//
/// A velocity-aware swipeable card stack component.
///
/// `SwipeCardStack` allows users to drag and dismiss items horizontally.
/// Dismissal occurs when either:
/// - The drag distance exceeds `swipeThreshold`, or
/// - The predicted end translation exceeds `velocityThreshold`.
///
/// - Parameters:
///   - items: The collection of identifiable items to display.
///   - visibleCardCount: Number of cards rendered in the stack.
///   - swipeThreshold: Distance required before dismissal.
///   - rotationMultiplier: Controls rotation intensity during drag.
///   - releasePreset: Spring preset used when dismissing.
///   - snapBackPreset: Spring preset used when snapping back.
///   - velocityThreshold: Predicted translation threshold for flick dismissal.
///   - onSwipe: Optional callback triggered when a card is dismissed.
///   - content: View builder that renders each card.
//

import SwiftUI

@available(macOS 10.15, *)
public struct SwipeCardStack<Item: Identifiable, Content: View>: View {

    // MARK: - Public API
    private let items: [Item]
    private let visibleCardCount: Int
    private let swipeThreshold: SwipeThreshold
    private let rotationMultiplier: CGFloat
    private let releasePreset: MotionPreset
    private let snapBackPreset: MotionPreset
    private let velocityThreshold: CGFloat // predicted translation threshold
    private let onSwipe: ((Item, SwipeDirection) -> Void)?
    private let content: (Item) -> Content

    // MARK: - State
    @State private var currentIndex: Int = 0

    // simpler explicit drag state (reliable)
    @State private var drag: CGSize = .zero
    @State private var isDragging: Bool = false

    // Haptics: ensure threshold haptic fires once per gesture
    @State private var hasFiredThresholdHaptic: Bool = false

    // MARK: - Init
    public init(
        items: [Item],
        visibleCardCount: Int = 3,
        swipeThreshold: SwipeThreshold = .percentage(0.25),
        rotationMultiplier: CGFloat = 12,
        releasePreset: MotionPreset = .snappy,
        snapBackPreset: MotionPreset = .soft,
        velocityThreshold: CGFloat = 500,
        onSwipe: ((Item, SwipeDirection) -> Void)? = nil,
        @ViewBuilder content: @escaping (Item) -> Content
    ) {
        self.items = items
        self.visibleCardCount = visibleCardCount
        self.swipeThreshold = swipeThreshold
        self.rotationMultiplier = rotationMultiplier
        self.releasePreset = releasePreset
        self.snapBackPreset = snapBackPreset
        self.velocityThreshold = velocityThreshold
        self.onSwipe = onSwipe
        self.content = content
    }

    // MARK: - Body
    public var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            ZStack {
                let slice = visibleItems
                if slice.isEmpty {
                    EmptyView()
                } else {
                    let itemsToShow = Array(slice)
                    // index 0 = top, index 1 = next behind, etc.
                    ForEach(itemsToShow.indices, id: \.self) { index in
                        let item = itemsToShow[index]
                        let isTop = index == 0
                        let depthIndex = index // 0 = top
                        // visual transforms: vertical stacking (no scaling) for cleaner feel
                        content(item)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .offset(y: CGFloat(depthIndex) * 12)
                            .zIndex(Double(itemsToShow.count - index))
                            .rotationEffect(
                                .degrees(
                                    isTop
                                    ? Double((drag.width / width) * rotationMultiplier)
                                    : 0
                                )
                            )
                            .offset(isTop ? drag : .zero)
                            .contentShape(Rectangle())
                            .gesture(topCardGestureIfNeeded(isTop: isTop, item: item, width: width))
                            .allowsHitTesting(isTop)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    // MARK: - Gesture wiring
    private func topCardGestureIfNeeded(isTop: Bool, item: Item, width: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 1.0, coordinateSpace: .local)
            .onChanged { value in
                guard isTop else { return }
                if !isDragging {
                    // gesture began
                    isDragging = true
                    hasFiredThresholdHaptic = false
                }
                // gentle dampening for premium feel
                drag = CGSize(width: value.translation.width * 0.95, height: value.translation.height * 0.95)

                // compute progress toward threshold and fire light haptic when crossing
                let threshold = swipeThreshold.value(for: width)
                let progress = min(abs(drag.width) / max(1.0, threshold), 1.0)
                if progress >= 1.0 && !hasFiredThresholdHaptic {
                    hasFiredThresholdHaptic = true
                    // Light selection haptic to indicate threshold reached
                    HapticsManager.shared.selection()
                }
            }
            .onEnded { value in
                guard isTop else { return }
                isDragging = false

                let predicted = value.predictedEndTranslation
                handleDragEnd(translation: value.translation, predictedEndTranslation: predicted, item: item, width: width)
            }
    }

    // MARK: - End handling (velocity-aware)
    private func handleDragEnd(translation: CGSize, predictedEndTranslation: CGSize, item: Item, width: CGFloat) {
        let threshold = swipeThreshold.value(for: width)
        let horizontal = translation.width
        let predictedHorizontal = predictedEndTranslation.width

        // Dismiss if either: translation passes distance threshold OR predicted translation passes velocity threshold
        if abs(horizontal) > threshold || abs(predictedHorizontal) > velocityThreshold {
            let direction: SwipeDirection = (horizontal + predictedHorizontal) > 0 ? .right : .left

            // success haptic on dismissal (notification success)
            HapticsManager.shared.notification(.success)

            performSwipe(direction: direction, item: item, width: width, predictedTranslation: predictedHorizontal)
        } else {
            // snap back to center
            withAnimation(snapBackPreset.animation) {
                drag = .zero
            }
        }

        // reset threshold flag for safety (next gesture)
        hasFiredThresholdHaptic = false
    }

    // MARK: - Throw & Advance
    private func performSwipe(direction: SwipeDirection, item: Item, width: CGFloat, predictedTranslation: CGFloat) {
        // Use predictedTranslation to scale throw distance for flicks
        // Ensure at least a base throw so slow but long drags still exit fully
        let baseThrow = width * 1.2
        let extraFromPredicted = min(abs(predictedTranslation), width * 2) // clamp
        let throwXMagnitude = baseThrow + extraFromPredicted * 0.6
        let throwX = (direction == .right ? 1 : -1) * throwXMagnitude

        withAnimation(releasePreset.animation) {
            drag = CGSize(width: throwX, height: 0)
        }

        // After animation, advance the stack and reset state
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.36) {
            // advance index (guard for bounds)
            if currentIndex < items.count - 1 {
                currentIndex += 1
            } else {
                // mark consumed (empty slice)
                currentIndex = items.count
            }
            // reset
            drag = .zero
            hasFiredThresholdHaptic = false
            onSwipe?(item, direction)
        }
    }

    // MARK: - Helpers
    private var visibleItems: ArraySlice<Item> {
        guard currentIndex < items.count else { return [] }
        let end = min(currentIndex + visibleCardCount, items.count)
        return items[currentIndex..<end]
    }
}

