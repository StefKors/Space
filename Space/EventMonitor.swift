import AppKit

extension NSEvent {
        func exclusivelyContains(_ flag: ModifierFlags) -> Bool {
            return self.modifierFlags.intersection(.deviceIndependentFlagsMask) == flag
        }
}

struct EventMonitor: AsyncSequence {
    typealias Element = NSEvent
    
    enum Scope {
        case local
        case global
    }
    var scope: Scope = .local
    var mask: NSEvent.EventTypeMask
    
    class AsyncIterator: AsyncIteratorProtocol {
        var monitor: Any
        var iterator: AsyncStream<NSEvent>.AsyncIterator
        init(monitor: Any, iterator: AsyncStream<NSEvent>.AsyncIterator) {
            self.monitor = monitor
            self.iterator = iterator
        }
        
        func next() async -> NSEvent? {
            await iterator.next()
        }
        
        deinit {
            NSEvent.removeMonitor(monitor)
        }
    }
    
    
    func makeAsyncIterator() -> AsyncIterator {
        let (stream, continuation) = AsyncStream.makeStream(of: NSEvent.self)
        let monitor = switch scope {
        case .local: NSEvent.addLocalMonitorForEvents(matching: mask) { event in continuation.yield(event); return event }
        case .global: NSEvent.addGlobalMonitorForEvents(matching: mask) { event in continuation.yield(event) }
        }
        guard let monitor else { preconditionFailure() }
        return AsyncIterator(monitor: monitor, iterator: stream.makeAsyncIterator())
    }
}
