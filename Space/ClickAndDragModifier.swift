//
//  ClickAndDragModifier.swift
//  Space
//
//  Created by Stef Kors on 09/10/2024.
//

import SwiftUI

struct ClickAndDragModifier: ViewModifier {


    enum DragState {
        case inactive
        case pressing
        case dragging(translation: CGSize)

        var translation: CGSize {
            switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(let translation):
                return translation
            }
        }

        var isActive: Bool {
            switch self {
            case .inactive:
                return false
            case .pressing, .dragging:
                return true
            }
        }

        var isDragging: Bool {
            switch self {
            case .inactive, .pressing:
                return false
            case .dragging:
                return true
            }
        }
    }

    @GestureState private var dragState = DragState.inactive
    @State private var viewState = CGSize.zero
    @State private var windows: [UIElement] = []



    func body(content: Content) -> some View {
        let minimumLongPressDuration = 0.3
        let longPressDrag = LongPressGesture(minimumDuration: minimumLongPressDuration)
            .sequenced(before: DragGesture())
            .updating($dragState) {
                value,
                state,
                transaction in
                switch value {
                    // Long press begins.
                case .first(true):
                    state = .pressing
                    // Long press confirmed, dragging may begin.
                case .second(true, let drag):
                    state = .dragging(translation: drag?.translation ?? .zero)



                default:
                    state = .inactive
                }
            }
            .onEnded { value in
                guard case .second(true, let drag?) = value else { return }
                self.viewState.width += drag.translation.width
                self.viewState.height += drag.translation.height

                Task {
                    for window in windows {
                        let role = try? window.role()
                        try? window.setAttribute(.enhancedUserInterface, value: false)
                        guard role == .window else { continue }
                        if let position: NSPoint = try? window.attribute(.position) {
                            let translation = drag.translation
                            try? window.setAttribute(
                                .position,
                                value: position.offset(
                                    x: translation.width,
                                    y: translation.height
                                )
                            )

//                            if let id = try? window.pid(), let connection = SLSMainConnectionID.unsafelyUnwrapped {
//                                CGSSetWindowTransform(Int32(connection), id, CGAffineTransform(scaleX: 1, y: 200))
//                            }

                        }
                    }
                }
            }

        content
            .offset(
                x: viewState.width + dragState.translation.width,
                y: viewState.height + dragState.translation.height
            )
            .animation(.linear(duration: minimumLongPressDuration), body: { view in
                view
                    .shadow(color: dragState.isDragging ? .accentColor : .clear, radius: dragState.isActive ? 8 : 0)
            })
            .gesture(longPressDrag)
            .task(priority: .userInitiated) {
                self.windows = Application.all().compactMap { app in
                    return try? app.windows()
                }.flatten()
            }
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(ClickAndDragModifier())
}
