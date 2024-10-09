//
//  ZoomableView.swift
//  Space
//
//  Created by Stef Kors on 24/03/2024.
//

import SwiftUI

extension EnvironmentValues {
    var canvasZoomLevel: CGFloat {
        get { self[CanvasZoomLevelKey.self] }
        set { self[CanvasZoomLevelKey.self] = newValue }
    }
}

private struct CanvasZoomLevelKey: EnvironmentKey {
    // 1
    static let defaultValue: CGFloat = 0.5

}

struct ZoomableViewModifier: ViewModifier {
    @FocusState private var focused: Bool
    @GestureState var currentZoom: CGFloat = 0.0
    //    @G private var currentZoom = 0.0
    @State private var totalZoom: CGFloat = 0.5

    private let zoomStep: CGFloat = 0.25
    private let minZoom: CGFloat = 0.25
    private let maxZoom: CGFloat = 2

    var zoomSum: CGFloat {
        (currentZoom + totalZoom).clamped(minZoom, maxZoom)
    }

    func body(content: Content) -> some View {
        content
            .environment(\.canvasZoomLevel, zoomSum)
            .gesture(
                MagnifyGesture()
                    .updating($currentZoom) { value, state, transaction in
                        state = value.magnification - 1
                    }
                    .onEnded({ value in
                        totalZoom = (totalZoom + (value.magnification - 1)).clamped(minZoom, maxZoom)
                    })
            )
            .accessibilityZoomAction { action in
                if action.direction == .zoomIn {
                    zoomIn(zoomStep)
                } else {
                    zoomOut(zoomStep)
                }
            }
            .overlay(alignment: .bottomTrailing, content: {
                HStack {
                    Button("+") {
                        zoomIn(zoomStep)
                    }
                    .disabled(zoomSum == maxZoom)
                    Text("\(Int(totalZoom*100).description)%")
                        .contentTransition(.numericText())
                    Button("-") {
                        zoomOut(zoomStep)
                    }
                    .disabled(zoomSum == minZoom)
                }
                .padding(6)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.thickMaterial)
                        .shadow(radius: 2, y: 1)
                }
                .padding(20)
            })
            .monitorEvents(mask: .keyDown) { event, point in
                if event.exclusivelyContains(.command) {
                    if event.characters == "=" {
                        zoomIn(zoomStep)
                    } else if event.characters == "-" {
                        zoomOut(zoomStep)
                    } else if event.characters == "0" {
                        zoomReset()
                    }
                }
                return event
            }
            .foregroundStyle(.secondary)

    }

    func zoomIn(_ amount: CGFloat) {
        let newZoom: CGFloat = totalZoom + amount
        withAnimation(.snappy(duration: 0.2)) {
            self.totalZoom = newZoom.clamped(minZoom, maxZoom)
        }
    }

    func zoomOut(_ amount: CGFloat) {
        let newZoom: CGFloat = totalZoom - amount
        withAnimation(.snappy(duration: 0.2)) {
            self.totalZoom = newZoom.clamped(minZoom, maxZoom)
        }
    }

    func zoomReset() {
        withAnimation(.bouncy(duration: 0.2)) {
            self.totalZoom = 1.0
        }
    }
}

#Preview {
    Text("Hello, world!")
        .modifier(ZoomableViewModifier())
}

extension View {
    func zoomableView() -> some View {
        modifier(ZoomableViewModifier())
    }
}
