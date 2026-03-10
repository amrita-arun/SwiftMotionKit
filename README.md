![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS%2015%2B-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

# SwiftMotionKit

> Physics-informed swipe interactions for SwiftUI.

SwiftMotionKit provides reusable, gesture-aware swipe components designed to make SwiftUI apps feel tactile, expressive, and production-ready.

---

## Features

- Velocity-based swipe dismissal  
- Distance-based swipe thresholds  
- Smooth spring snap-back  
- Configurable rotation intensity  
- Stack depth layout (vertical stacking)  
- Built-in haptic feedback (rate-limited)  
- Fully SwiftUI-native  
- Swift Package Manager compatible

---

## How Swipe Works

A card dismisses when either:

* The horizontal drag exceeds the configured distance threshold

* The predicted end translation exceeds the velocity threshold


## Installation

Add SwiftMotionKit via Swift Package Manager: 

```https://github.com/amrita-arun/SwiftMotionKit```

Then import in your Swift file:

```swift
import SwiftMotionKit
```

---

## Quick Start

```swift
import SwiftUI
import SwiftMotionKit

struct DemoCard: Identifiable {
    let id = UUID()
    let color: Color
}

struct ContentView: View {
    let cards = [
        DemoCard(color: .pink),
        DemoCard(color: .blue),
        DemoCard(color: .green)
    ]

    var body: some View {
        SwipeCardStack(items: cards) { card in
            RoundedRectangle(cornerRadius: 24)
                .fill(card.color)
                .padding(24)
        }
    }
}
```

By default:
- Cards dismiss when dragged beyond 25% of the screen width.
- Fast flicks also dismiss via velocity detection.
- Cards snap back smoothly if below threshold.
- Subtle haptic feedback enhances interaction.

![swipeCardStackResize](https://github.com/user-attachments/assets/719377b4-8e70-4309-a54f-fc0e5561141b)


    
## Configuration 

You can customize the stack using the initializer:

```swift
SwipeCardStack(
    items: cards,
    visibleCardCount: 3,
    swipeThreshold: .percentage(0.25),
    rotationMultiplier: 12,
    releasePreset: .snappy,
    snapBackPreset: .soft,
    velocityThreshold: 500,
    onSwipe: { item, direction in ... }
) { card in
    CardView(card: card)
}
```

### swipeThreshold
Controls the minimum drag distance required for dismissal.

```swift
// 25% of container width
swipeThreshold: .percentage(0.25)

// or absolute points
swipeThreshold: .distance(150)
```

### velocityThreshold
```swift
velocityThreshold: 500
```
- Lower = easier to dismiss by flick
- Higher = requires stronger flick

### rotationMultiplier

Controls rotation while dragging.
```swift
rotationMultiplier: 12
```

### Motion presets (releasePreset, snapBackPreset)

```swift
.releasePreset: .snappy
.snapBackPreset: .soft
// or custom:
.custom(response: 0.6, dampingFraction: 0.85)
```

### visibleCardCount

How many cards to draw at once.
```swift
visibleCardCount: 3
```

## onSwipe callback
```swift
SwipeCardStack(
  items: cards,
  onSwipe: { item, direction in
      print("Swiped \(direction)")
  }
) { card in
  CardView(card: card)
}
```
Use for:
- Removing the item from your model
- Sending analytics
- Triggering side effects / navigation

How dismissal works

A card dismisses when either:
    1.    Horizontal drag distance exceeds swipeThreshold
OR
    2.    The predicted end translation (from the gesture) exceeds velocityThreshold

This makes both slow drags and fast flicks feel natural.

## Haptic feedback

SwiftMotionKit integrates tasteful haptics:
- Selection haptic when the drag crosses the threshold (fires once per gesture)
- Success haptic when the card is dismissed

Haptics are rate-limited to avoid spam.

Note: Simulator does not produce vibration — test on a real device.

## When to use SwipeCardStack

Ideal for:
- Recommendation flows (swipe to like/pass)
- Matching experiences
- Product selection
- Visual browsing and exploratory UIs

Not ideal for:
- Infinite scroll feeds
- Precision data entry forms
- High-density lists where users need exact taps

## Example: Full customization
```swift
SwipeCardStack(
    items: cards,
    visibleCardCount: 2,
    swipeThreshold: .percentage(0.20),
    rotationMultiplier: 18,
    releasePreset: .soft,
    snapBackPreset: .heavy,
    velocityThreshold: 600,
    onSwipe: { item, dir in
        // update model
    }
) { card in
    YourCardView(card: card)
        .frame(width: 320, height: 480)
}
```

## Edge cases & notes
- When the stack is exhausted, visibleItems becomes empty — manage repopulation or undo in your app logic.
- Undo is intentionally left to the integrator (reinsert into your source array).
- Haptics are no-ops on non-UIKit platforms.
- Avoid placing the stack inside a scrolling container unless you handle gesture priorities.

## Example App

An interactive demo is included in `/Examples/SwipeDemoApp`.

Run the workspace:
SwiftMotionKit.xcworkspace

## License

MIT
