//
//  QuickLook+SwiftUI.swift
//  QLThumbnail
//
//  Created by Edon Valdman on 6/22/23.
//

import SwiftUI
import QuickLook
import QuickLookThumbnailing

//https://developer.apple.com/documentation/quicklookthumbnailing/creating-quick-look-thumbnails-to-preview-files-in-your-app

struct QLThumbnail: View {
    /// The URL of the file for which you want to create a thumbnail.
    var url: URL

    /// The desired size of the thumbnails.
    ///
    /// This is the actual size of the thumbnail image.
    @Binding var size: CGSize

    

    /// The pixel density of the display on the intended device.
    ///
    /// This property represents the scale factor, or pixel density, of the device’s display as described in [Image Size and Resolution](https://developer.apple.com/design/human-interface-guidelines/images). For example, the value for a device with a `@2x` display is `2.0`.
    ///
    /// You can pass the initializer a screen scale that isn’t the current device’s screen scale. For example, you can create thumbnails for different scales, upload them to a server, and download them later on devices with a different screen scale.
    var scale: CGFloat

    /// The thumbnail sizes that you provide for a thumbnail request.
    ///
    /// The representation types provide access to icon, low-quality, and high-quality thumbnails so you can request and show a lower-quality thumbnail quickly while computing a higher-quality thumbnail in the background.
    var representationTypes: QLThumbnailGenerator.Request.RepresentationTypes

    private let referenceSize = CGSize(width: 400, height: 400)
    @State private var thumbnail: QLThumbnailRepresentation? = nil
    @State private var previewItem: URL? = nil

    @ViewBuilder
    var body: some View {
        Group {
            if let image, let thumbnail {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                    .help("File: \(self.url.lastPathComponent), type: \(thumbnail.type)")
            } else {
                ProgressView()
            }
        }
        .task {
            do {
                for try await thumb in QLThumbnailGenerator.shared.generateRepresentations(for: request) {
                    thumbnail = thumb
                    size = thumb.contentRect.size
                }
            } catch {
                print("Error creating thumbnails:", error as NSError)
            }
        }
    }

    private var image: Image? {
#if canImport(UIKit)
        guard let uiImage = thumbnail?.uiImage else { return nil }
        return Image(uiImage: uiImage)
#else
        guard let nsImage = thumbnail?.nsImage else { return nil }
        return Image(nsImage: nsImage)
#endif
    }

    private var request: QLThumbnailGenerator.Request {
        QLThumbnailGenerator.Request(fileAt: url,
                                     size: referenceSize,
                                     scale: scale,
                                     representationTypes: representationTypes)
    }
}

extension QLThumbnailGenerator {
    func generateRepresentations(for request: Request) -> AsyncThrowingStream<QLThumbnailRepresentation, Error> {
        AsyncThrowingStream(QLThumbnailRepresentation.self) { continuation in
            self.generateRepresentations(for: request) { thumbnail, type, error in
                if let thumbnail {
                    continuation.yield(thumbnail)
                } else {
                    continuation.finish(throwing: error)
                }

                switch type {
                case .thumbnail:
                    continuation.finish()
                case .icon:
                    fallthrough
                case .lowQualityThumbnail:
                    fallthrough
                @unknown default:
                    break
                }
            }
        }
    }
}
