# SwiftMotionKit

Physics-informed motion & interaction primitives for SwiftUI.

SwiftMotionKit provides reusable, gesture-aware components designed to make SwiftUI apps feel tactile, expressive, and production-ready.

## Features

* Velocity-based swipe dismissal

* Configurable swipe thresholds

* Smooth spring-based snap-back

* Stacked card depth layout

* Built-in haptic feedback

* Fully SwiftUI-native

* SPM-ready

## Installation

Add via Swift Package Manager:

https://github.com/amrita-arun/SwiftMotionKit

Then:

```
import SwiftMotionKit
Quick Start
SwipeCardStack(items: cards) { card in
    RoundedRectangle(cornerRadius: 24)
        .fill(card.color)
        .padding(24)
}
```

## Configuration

SwipeCardStack(
    items: cards,
    swipeThreshold: .percentage(0.25),
    rotationMultiplier: 12,
    releasePreset: .snappy,
    snapBackPreset: .soft,
    velocityThreshold: 500
) { card in
    CardView(card: card)
}

## How Swipe Works

A card dismisses when either:

* The horizontal drag exceeds the configured distance threshold

* The predicted end translation exceeds the velocity threshold

## Haptics

SwiftMotionKit provides built-in haptic feedback:

* Light selection haptic when crossing threshold

* Success notification on dismissal

Haptics are rate-limited to prevent vibration spam.

## Example App

An interactive demo is included in `/Examples/SwipeDemoApp`.

Run the workspace:
SwiftMotionKit.xcworkspace

## License

MIT
