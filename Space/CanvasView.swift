//
//  CanvasView.swift
//  Space
//
//  Created by Stef Kors on 24/03/2024.
//

import SwiftUI
import Carbon

public extension Array where Element: Collection {
    func flatten() -> [Element.Element] {
        return reduce([], +)
    }
}

extension NSPoint {
    func offset(x: CGFloat = 0, y: CGFloat = 0) -> NSPoint {
        NSPoint(x: self.x + x, y: self.y + y)
    }
}

struct CanvasView: View {
    static let size: CGSize = CGSize(width: 10000, height: 10000)
    
    var body: some View {
        ScrollView([.horizontal, .vertical], content: {
            Rectangle()
                .fill(.windowBackground)
                .overlay(alignment: .center, content: {
                    CanvasContent()
                        .frame(width: Self.size.width, height: Self.size.height)
                })
                .frame(width: Self.size.width, height: Self.size.height)
                .modifier(ClickAndDragModifier())
        })
        .defaultScrollAnchor(.center)
    }
}

#Preview {
    CanvasView()
}
