//
//  CanvasView.swift
//  Space
//
//  Created by Stef Kors on 24/03/2024.
//

import SwiftUI

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
        })
        .defaultScrollAnchor(.center)
    }
}

#Preview {
    CanvasView()
}
