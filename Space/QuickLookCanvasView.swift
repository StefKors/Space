//
//  QuickLookCanvasView.swift
//  Space
//
//  Created by Stef Kors on 26/02/2024.
// source: https://github.com/CodeEditApp/CodeEdit/blob/679ead2008684c6a5b37c83f6276a4a98f5e1509/CodeEdit/Features/CodeFile/Other/OtherFileView.swift#L31

import SwiftUI
import QuickLookUI


struct QuickLookCanvasView: NSViewRepresentable {

    let url: URL

    @Binding var size: CGSize

    func makeNSView(context: Context) -> QLPreviewView {
        let qlPreviewView = QLPreviewView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height), style: .compact)!
        
        qlPreviewView.previewItem = url as QLPreviewItem
        qlPreviewView.autostarts = true
        return qlPreviewView
    }

    /// Update preview file when file changed
    func updateNSView(_ nsView: QLPreviewView, context: Context) {

        nsView.translatesAutoresizingMaskIntoConstraints = true
        nsView.subviews[0].autoresizesSubviews = true
        nsView.autoresizesSubviews = true

        DispatchQueue.main.async {
//            print(nsView.previewItem)

            self.size = nsView.frame.size
        }
//        guard let currentPreviewItem = nsView.previewItem else {
//            return
//        }
//
//        if self.url != currentPreviewItem.previewItemURL {
//            nsView.previewItem = self.url as QLPreviewItem
//        }
//        print(nsView.previewItem.previewItemURL.previewItemFrame)
    }
}



//
//#Preview {
//    QuickLookCanvasView()
//}

