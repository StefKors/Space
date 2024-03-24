//
//  CanvasContent.swift
//  Space
//
//  Created by Stef Kors on 24/03/2024.
//

import SwiftUI
import SwiftData

struct CanvasContent: View {
    @Query private var items: [Item]
    @Environment(\.canvasZoomLevel) var canvasZoomLevel

    var body: some View {
        ZStack {
            if items.count > 1 {
                //                ForEach(items[0..<min(items.count, 30)]) { item in
                ForEach(items) { item in
                    CanvasItemView(item: item)
                        .id(item.url)
                }
            }
        }
        .scaleEffect(canvasZoomLevel)
    }
}

#Preview {
    CanvasContent()
        .modelContainer(.preview)
}
