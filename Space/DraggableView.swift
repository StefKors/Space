//
//  DraggableView.swift
//  Space
//
//  Created by Stef Kors on 24/03/2024.
//

import SwiftUI

struct DraggableViewModifier: ViewModifier {
    @Bindable var item: Item

    @State private var isHovering: Bool = false
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
                self.rotation = .random(in: -4..<4)
                updateCursor(.openHand)
            })
    }
    @State private var rotation: CGFloat = .random(in: -4..<4)

    func body(content: Content) -> some View {
        content
        //            .allowsHitTesting(false)
        //            .background {
        //                Rectangle()
        //                    .fill(.ultraThinMaterial)
        ////                    .stroke(.blue, lineWidth: isHovering ? 2 : 0)
        //            }

        //            .onHover { hoverState in
        //                withAnimation(.snappy) {
        //                    isHovering = hoverState
        //                }
        //            }
            .shadow(
                color: Color(nsColor: NSColor.shadowColor).opacity(isHovering ? 0.2 : 0.1),
                radius: isDragging ? 12 : 4,
                y: 3
                //                y: isDragging ? 6 : 3
            )
            .offset(y: isDragging ? -10 : 0)
        //            .rotationEffect(isDragging ? .degrees(rotation) : .degrees(0))
            .padding(10)
            .compositingGroup()
        //            .overlay(content: {
        //                VStack {
        //                    Text(Int(dragOffset.width).description) + Text("  ") + Text(Int(dragOffset.height).description)
        //                    Text(Int(item.position.x).description) + Text("  ") + Text(Int(item.position.y).description)
        //                }
        //                .background(.white)
        //            })
        //            .drawingGroup()
        //            .frame(width: 200, height: 200, alignment: .center)
            .position(location)
            .gesture(dragGesture)
            .animation(.snappy, value: isDragging)
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
