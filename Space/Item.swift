//
//  Item.swift
//  Space
//
//  Created by Stef Kors on 22/12/2023.
//

import Foundation
import SwiftData

@Model
final class Item: Identifiable {
    var id: UUID = UUID()
    var timestamp: Date = Date.now
    @Attribute(.unique) var url: URL

    private var x: CGFloat = 0
    private var y: CGFloat = 0

    var position: CGPoint {
        get {
            return CGPoint(x: x, y: y)
        }
        set {
            self.x = newValue.x
            self.y = newValue.y
        }
    }

    init(url: URL, position: CGPoint = CanvasView.size.midPoint, timestamp: Date = Date.now) {
        self.url = url
        self.timestamp = timestamp
        self.position = position
    }
}

extension Item {
    static let preview = Item(url: URL(fileURLWithPath: ""), position: CGPoint(x: 2500, y: 2500))
}
