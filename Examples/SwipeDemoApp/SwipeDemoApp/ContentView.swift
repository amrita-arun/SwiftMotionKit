//
//  ContentView.swift
//  SwipeDemoApp
//
//  Created by Amrita Arun on 3/9/26.
//

import SwiftUI
import SwiftMotionKit

struct DemoCard: Identifiable {
    let id = UUID()
    let color: Color
}

struct ContentView: View {

    @State private var recyclingMode: RecyclingMode = .none

    let cards = [
        DemoCard(color: .pink),
        DemoCard(color: .blue),
        DemoCard(color: .green),
        DemoCard(color: .orange),
        DemoCard(color: .purple)
    ]

    var body: some View {
        VStack {

            Picker("Mode", selection: $recyclingMode) {
                Text("Finite").tag(RecyclingMode.none)
                Text("Infinite").tag(RecyclingMode.infinite)
            }
            .pickerStyle(.segmented)
            .padding()

            SwipeCardStack(
                items: cards,
                recyclingMode: recyclingMode,
                stackStyle: .randomized(
                    rotationRange: -5...2,
                    offsetRange: 10...14
                )
            ) { card in
                RoundedRectangle(cornerRadius: 32)
                    .fill(card.color)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 80)
                    .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
            }

        }
    }
}

#Preview {
    ContentView()
}
