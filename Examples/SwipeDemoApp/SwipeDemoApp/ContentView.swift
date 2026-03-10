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

    let cards = [
        DemoCard(color: .pink),
        DemoCard(color: .blue),
        DemoCard(color: .green),
        DemoCard(color: .orange),
        DemoCard(color: .purple)
    ]

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            SwipeCardStack(items: cards) { card in
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
