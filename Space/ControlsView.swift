//
//  ControlsView.swift
//  Space
//
//  Created by Stef Kors on 24/03/2024.
//

import SwiftUI
import SwiftData

struct ControlsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        HStack {
            Text("items: \(Int(items.count))")
        }
        .padding(6)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.background)
                .shadow(radius: 6)
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    ControlsView()
        .modelContainer(.sharedModelContainer)
}
