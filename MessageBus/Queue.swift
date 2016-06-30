class QueueItem<T> {
    let value: T!
    var next: QueueItem?
    
    init(_ newvalue: T?) {
        self.value = newvalue
    }
}

open class Queue<T> {
    
    public typealias Element = T
    
    var front: QueueItem<Element>
    var back: QueueItem<Element>
    
    public init () {
        // Insert dummy item. Will disappear when the first item is added.
        back = QueueItem(nil)
        front = back
    }
    
    /// Add a new item to the back of the queue.
    open func enqueue (_ value: Element) {
        back.next = QueueItem(value)
        back = back.next!
    }
    
    /// Return and remove the item at the front of the queue.
    open func dequeue () -> Element? {
        if let newhead = front.next {
            front = newhead
            return newhead.value
        } else {
            return nil
        }
    }
    
    open func isEmpty() -> Bool {
        return front === back
    }
}
