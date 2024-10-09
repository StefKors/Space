//
//  CanvasItemView.swift
//  Space
//
//  Created by Stef Kors on 24/03/2024.
//

import SwiftUI
import QuickLook

struct CanvasItemView: View {
    let item: Item

    @State private var size: CGSize = CGSize(width: 400, height: 400)

    var shape: some Shape {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
    }

    @State private var previewUrl: URL?

    var body: some View {
        QLThumbnail(url: item.url, size: $size, representationTypes: [.lowQualityThumbnail])
            .allowsHitTesting(false)
//        QLThumbnail(url: item.url, size: $size, scale: 2.0, representationTypes: .all)
            .frame(width: size.width, height: size.height)
            .padding()
            .background(.ultraThinMaterial, in: shape)
            .draggableView(item: item)
        //        VStack(alignment: .center) {
        //            QLThumbnail(url: item.url, resolution: size, scale: 2.0, representationTypes: .all, resizable: false)
        ////            QuickLookCanvasView(url: item.url, size: $size)
        //                .allowsHitTesting(false)
        //                .id(item.url)
        //
        ////                .frame(width: size.width, height: size.height, alignment: .bottom)
        //
        //            HStack {
        //                Image(systemName: "square.grid.4x3.fill")
        //                Text(item.url.lastPathComponent)
        //                    .lineLimit(1)
        //                Spacer()
        //                Button {
        //                    previewUrl = item.url
        //                } label: {
        //                    Text("Preview")
        //                        .foregroundStyle(.tint)
        //                }
        //            }#imageLiteral(resourceName: "Screenshot 2024-05-29 at 09.51.48.png")
        //        }
        //        .padding()
        //        .foregroundStyle(Color(nsColor: .windowBackgroundColor))
        //        .background(.foreground, in: shape)


        //        .focusable(true)
        //        .focusSection()
        //        .onDrag {
        //            return NSItemProvider(contentsOf: item.url) ?? NSItemProvider()
        //        }
        //        .frame(width: size.width)
        //        .draggableView(item: item)


        //        .quickLookPreview($previewUrl)
    }

}



#Preview {
    CanvasItemView(item: .preview)
}

