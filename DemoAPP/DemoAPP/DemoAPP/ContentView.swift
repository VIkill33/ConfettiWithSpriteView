//
//  ContentView.swift
//  DemoAPP
//
//  Created by Vikill Blacks on 2024/2/29.
//

import SwiftUI
import ConfettiWithSpriteKit

struct ContentView: View {
    
    @State private var startConfetti = false
    
    var body: some View {
        ZStack {
            Button("Start/Stop") {
                startConfetti.toggle()
            }
            .confetti(start: $startConfetti)
        }
    }
}

#Preview {
    ContentView()
}
