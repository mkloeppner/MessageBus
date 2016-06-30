//
//  SimpleMessageBus.swift
//  MessageBus
//
//  Created by Martin Klöppner on 30.06.16.
//  Copyright © 2016 Martin Klöppner. All rights reserved.
//

import Foundation

open class SimpleMessageBus : MessageBus {
    
    internal typealias EventType = Event.Type;
    
    fileprivate var dispatching : Bool = false;
    
    fileprivate var eventObserver = [String: [Any]]();
    
    fileprivate var dispatchers = Queue<Any>();
    
    open func observe<E>(_ eventType: E.Type, actionHandler: @escaping ((E) -> Void)) where E : Event {
        let anyHandler = { ( e : Any) in
            actionHandler(e as! E)
        }
        if var eventListeners = eventObserver[String(describing: eventType)] {
            eventListeners.append(anyHandler);
            eventObserver[String(describing: eventType)] = eventListeners;
        } else {
            var eventListeners = [Any]();
            eventListeners.append(anyHandler);
            eventObserver[String(describing: eventType)] = eventListeners;
        }
    }
    
    open func post<T : Event>(_ event : T) {
        var mirror : Mirror? = Mirror(reflecting: event.self)
        var dispatcherChain : [EventDispatcher<T>] = [] as! [EventDispatcher<T>] // Preserves the order of the callbacks regarding the inheritance
        while mirror != nil {
            if let eventListeners = eventObserver[String(describing: mirror!.subjectType)] {
                var chain : [EventDispatcher<T>] = [] as! [EventDispatcher<T>] // Preserves the order of the callbacks as they have beeing registered
                for handler in eventListeners {
                    let dispatcher = EventDispatcher(
                        eventHandler: handler,
                        event: event)
                    chain.append(dispatcher)
                }
                dispatcherChain.insert(contentsOf: chain, at: 0) // First start with all events (ordered by their registration) from superclass.
            }
            mirror = mirror?.superclassMirror
        }
        for dispatcher in dispatcherChain {
            self.dispatchers.enqueue(dispatcher)
        }
        dispatch(T.self)
    }
    
    fileprivate func dispatch<T: Event>(_ type: T.Type) {
        if (self.dispatching) {
            return;
        }
        dispatching = true;
        defer {
            dispatching = false;
        }
        
        while !self.dispatchers.isEmpty() {
            if let eventDispatcher = self.dispatchers.dequeue() as? EventDispatcher<T> {
                eventDispatcher.invoke()
            }
        }
    }
    
}

internal class EventDispatcher<E : Event> {
    
    fileprivate let eventHandler : Any;
    fileprivate let event : E;
    
    internal init(eventHandler: Any, event: E) {
        self.eventHandler = eventHandler;
        self.event = event;
    }
    
    internal func invoke() {
        (self.eventHandler as! (Any) -> (Void))(self.event)
    }
    
}
