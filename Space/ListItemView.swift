//
//  ListItemView.swift
//  Space
//
//  Created by Stef Kors on 24/03/2024.
//

import SwiftUI
import SwiftData

struct ListItemView: View {
    @Environment(\.modelContext) private var modelContext
    let item: Item

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(item.timestamp.formatted(date: .abbreviated, time: .shortened))
                .foregroundStyle(.secondary)
            HStack {
                Text("x: \(Int(item.position.x))")
                Divider()
                Text("y: \(Int(item.position.x))")
            }
            .monospaced()
        }
        .contextMenu {
            Button {
                withAnimation {
                    modelContext.delete(item)
                }
            } label: {
                Text("Remove")
            }
            .keyboardShortcut(.delete)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ListItemView(item: .preview)
        .modelContainer(.sharedModelContainer)
}
