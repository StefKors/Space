//
//  ContentView.swift
//  Space
//
//  Created by Stef Kors on 22/12/2023.
//

import SwiftUI
import SwiftData



struct ControlsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        HStack {
            Text("items: \(Int(items.count))")
            Button("Create Rectangle", systemImage: "rectangle.badge.plus") {
                withAnimation {
                    let newItem = Item()
                    modelContext.insert(newItem)
                }
            }
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
}

struct LayersView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {

        List {
            ForEach(items) { item in
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
            .onDelete(perform: deleteItems)
        }
        .padding(6)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(.background)
                .shadow(radius: 6)
        }
        //
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
}



struct DraggableViewModifier: ViewModifier {
    @Bindable var item: Item

    @State private var isDragging: Bool = false
    @GestureState private var dragOffset = CGSize.zero

//    var location: CGSize {
//        CGSize(width: item.position.x + dragOffset.width, height: item.position.y + dragOffset.height)
//    }

    var location: CGPoint {
        CGPoint(x: item.position.x + dragOffset.width, y: item.position.y + dragOffset.height)
    }

    var dragGesture: some Gesture{
        DragGesture()
            .updating($dragOffset, body: { (value, state, transaction) in
                state = value.translation

            })
            .onChanged { value in
                if isDragging != true {
                    self.isDragging = true
                    updateCursor(.closedHand)
                }
            }
            .onEnded({ (value) in
                var pos = self.item.position
                pos.x += value.translation.width
                pos.y += value.translation.height
                self.item.position = pos
                self.isDragging = false
                updateCursor(.openHand)
            })
    }

    func body(content: Content) -> some View {
        content
            .position(location)
            .gesture(dragGesture)
            .shadow(radius: isDragging ? 12 : 4, y: isDragging ? 6 : 3)
            .animation(.easeInOut, value: isDragging)
            .onHover { hoverState in
                var cursor: NSCursor = .openHand
//                if 
//                updateCursor(.openHand)

            }
    }

    func updateCursor(_ cursor: NSCursor) {
        DispatchQueue.main.async {
            if self.isDragging {
                // Looks like ugly hack, but otherwise cursor gets reset to standard arrow.
                // See https://stackoverflow.com/a/62984079/7964697 for details.
                NSApp.windows.forEach { $0.disableCursorRects() }

                // swiftlint:disable:next force_unwrapping
                NSCursor.openHand.push()
                //                        NSCursor(image: NSImage(named: "ZoomPlus")!, hotSpot: NSPoint(x: 9, y: 9)).push() // Cannot be nil.
            } else {
                NSCursor.pop()
                NSApp.windows.forEach { $0.enableCursorRects() }
            }
        }
    }
}

extension View {
    func draggableView(item: Item) -> some View {
        modifier(DraggableViewModifier(item: item))
    }
}

extension CGSize {
    var midPoint: CGPoint {
        CGPoint(x: self.width/2, y: self.height/2)
    }
}

struct CanvasItemView: View {
    let item: Item
    var body: some View {
        RoundedRectangle(cornerRadius: 25.0)
            .fill(.blue)
            .frame(width: 200, height: 200, alignment: .center)
            .draggableView(item: item)
    }
}

#Preview {
    CanvasItemView(item: .preview)
}

struct CanvasView: View {
    static let size: CGSize = CGSize(width: 10000, height: 10000)

    @Query private var items: [Item]

    var body: some View {
        ScrollView([.horizontal, .vertical], content: {
            Rectangle()
                .fill(.windowBackground)
                .frame(width: Self.size.width, height: Self.size.height)
                .overlay(content: {
                    ZStack {
                        ForEach(items) { item in
                            CanvasItemView(item: item)
                        }
                    }
                })
        })
        .defaultScrollAnchor(.center)
    }
}

#Preview {
    CanvasView()
}


struct ContentView: View {
    var body: some View {
        ZStack {
            CanvasView()
                .overlay(alignment: .topLeading, content: {
                    LayersView()
                })
                .overlay(alignment: .bottom, content: {
                    ControlsView()
                })
        }
    }

    //    private func addItem() {
    //        withAnimation {
    //            let newItem = Item(timestamp: Date())
    //            modelContext.insert(newItem)
    //        }
    //    }
    //
    //    private func deleteItems(offsets: IndexSet) {
    //        withAnimation {
    //            for index in offsets {
    //                modelContext.delete(items[index])
    //            }
    //        }
    //    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
