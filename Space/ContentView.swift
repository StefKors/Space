//
//  ContentView.swift
//  Space
//
//  Created by Stef Kors on 22/12/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        ZStack {
            CanvasView()
                .overlay(alignment: .topLeading, content: {
                    LayersView()
                })
                .zoomableView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
