//
//  LayersView.swift
//  Space
//
//  Created by Stef Kors on 24/03/2024.
//

import SwiftUI
import SwiftData

struct LayersView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    @State private var files: [URL] = []

    private let path = URL(fileURLWithPath: "/Users/stefkors/Downloads/TestImages", isDirectory: true)

    var body: some View {
        List {
            ForEach(items) { item in
                ListItemView(item: item)
            }
            .onDelete(perform: deleteItems)
        }
        .toolbar(content: {
            ToolbarItem {
                Button("Refresh Content") {
                    getAllInFolder()
                }
            }
            ToolbarItem(placement: .destructiveAction) {
                Button("Delete Content", systemImage: "trash", role: .destructive) {
                    deleteAll()
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(.red)
            }
        })
        .navigationTitle(path.lastPathComponent)
        .navigationDocument(path)
        .padding(6)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.background)
                .shadow(radius: 2, y: 1)
        }
        .padding(.leading, 20)
        .padding(.top, 20)
        .padding(.bottom, 20)
        .frame(width: 240)
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }

    private func deleteAll() {
        withAnimation {
            for item in items {
                modelContext.delete(item)
            }
        }
    }

    private func getAllInFolder() {
        let fm = FileManager.default
        modelContext.autosaveEnabled = false
        items.forEach { item in
            modelContext.delete(item)
        }
        do {
            let items = try fm.contentsOfDirectory(at: path, includingPropertiesForKeys: [], options: .skipsHiddenFiles)

            for item in items {
                print("Found \(item)")

                withAnimation {
                    let newItem = Item(url: item)
                    modelContext.insert(newItem)
                }
            }
            try modelContext.save()
            modelContext.autosaveEnabled = true
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
    }
}

#Preview {
    LayersView()
        .modelContainer(.sharedModelContainer)
}
