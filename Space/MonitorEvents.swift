import SwiftUI

struct EventMonitorView: NSViewRepresentable {
    var mask: NSEvent.EventTypeMask
    var handle: (NSEvent, CGPoint) -> NSEvent?
    
    class NSViewType: NSView {
        var mask: NSEvent.EventTypeMask = .init()
        var handle: (NSEvent, CGPoint) -> NSEvent? = { event, _ in event }
        
        var monitor: Any?
        func updateMonitor() {
            if let monitor {
                NSEvent.removeMonitor(monitor)
                self.monitor = nil
            }
            if let window {
                monitor = NSEvent.addLocalMonitorForEvents(matching: mask) { [self] event in
                    guard event.window == window else { return event }
                    let point = self.convert(event.locationInWindow, from: nil)
                    guard self.bounds.contains(point) else { return event }
                    return handle(event, point)
                }
            }
        }
        
        override func viewDidMoveToWindow() {
            updateMonitor()
        }
        
        override func hitTest(_ point: NSPoint) -> NSView? {
            nil
        }
        
        override var isFlipped: Bool {
            true
        }
    }
    
    func makeNSView(context: Context) -> NSViewType {
        .init(frame: .zero)
    }
    
    func updateNSView(_ view: NSViewType, context: Context) {
        view.mask = mask
        view.handle = handle
        view.updateMonitor()
    }
}

extension View {
    func monitorEvents(mask: NSEvent.EventTypeMask, handle: @escaping (NSEvent, CGPoint) -> NSEvent?) -> some View {
        overlay(EventMonitorView(mask: mask, handle: handle))
    }
}
