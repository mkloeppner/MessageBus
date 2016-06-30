//
//  MessageBusTests.swift
//  MessageBusTests
//
//  Created by Martin Klöppner on 30.06.16.
//  Copyright © 2016 Martin Klöppner. All rights reserved.
//

import XCTest
@testable import MessageBus

class SimpleMessageBusTests: XCTestCase {
    
    fileprivate let messageBus : MessageBus = SimpleMessageBus()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testReceiveEventIfTypeMatches() {
        var receivedEvent : Event?
        
        // Given a observer is registered
        messageBus.observe(Event.self) { (e) in
            receivedEvent = e
        }
        
        // And a event is being fired 
        // And the type matches the observer type
        let event = Event()
        messageBus.post(event)
        
        // Then expect
        XCTAssertNotNil(receivedEvent)
        
    }
    
    func testNotReceiveEventIfObserverTypeNotMatchesAndNotInherited() {
        var receivedEvent : Event?
        
        // Given a observer is registered
        messageBus.observe(FirstLevelEvent.self) { (e) in
            receivedEvent = e
        }
        
        // And a event is being fired
        // And the type matches the observer type
        let event = AnotherEvent()
        messageBus.post(event)
        
        XCTAssertNil(receivedEvent)
    }
    
    func testReceiveEventIfObserverTypeIsParent() {
        
        var receivedEvent : Event?
        
        messageBus.observe(Event.self) { (e : Event) in
            receivedEvent = e
        }
        
        let event = FirstLevelEvent()
        messageBus.post(event)
        
        // Then expect
        XCTAssertNotNil(receivedEvent)
        
    }
    
    func testReceiveEventIfObserverTypeIsParentOfParent() {
        
        var receivedEvent : Event?
        
        messageBus.observe(Event.self) { (e : Event) in
            receivedEvent = e
        }
        
        let event = SecondLevelEvent()
        messageBus.post(event)
        
        // Then expect
        XCTAssertNotNil(receivedEvent)
        
    }
    
    func testReceiveEventSustainsOrderOfRegistration() {
        
        var receivedEvents : [TestEvent] = []
        
        messageBus.observe(Event.self) { (e) in
            let testEvent = TestEvent()
            testEvent.receivedOrder = 0
            receivedEvents.append(testEvent)
        }
        
        messageBus.observe(Event.self) { (e) in
            let testEvent = TestEvent()
            testEvent.receivedOrder = 1
            receivedEvents.append(testEvent)
        }
        
        let event = Event()
        messageBus.post(event)
        
        // Then expect
        XCTAssertEqual(2, receivedEvents.count)
        for i in 0...(receivedEvents.count - 1) {
            XCTAssertEqual(receivedEvents[i].receivedOrder, i)
        }
        
    }
    
    func testReceiveEventSustainsOrderOfInheritance() {
        var receivedEvents : [TestEvent] = []
        
        messageBus.observe(Event.self) { (e) in
            let testEvent = TestEvent()
            testEvent.receivedOrder = 0
            receivedEvents.append(testEvent)
        }
        
        messageBus.observe(TestEvent.self) { (e) in
            let testEvent = TestEvent()
            testEvent.receivedOrder = 1
            receivedEvents.append(testEvent)
        }
        
        messageBus.observe(FirstLevelEvent.self) { (e) in
            let testEvent = TestEvent()
            testEvent.receivedOrder = 2
            receivedEvents.append(testEvent)
        }
        
        messageBus.observe(SecondLevelEvent.self) { (e) in
            let testEvent = TestEvent()
            testEvent.receivedOrder = 3
            receivedEvents.append(testEvent)
        }
        
        let event = SecondLevelEvent()
        messageBus.post(event)
        
        // Then expect
        XCTAssertEqual(4, receivedEvents.count)
        for i in 0...(receivedEvents.count - 1) {
            XCTAssertEqual(receivedEvents[i].receivedOrder, i)
        }
    }
    
    func testReceiveEventSustainsOrderOfRegistrationInInheritanceHirarchy() {
        
        var receivedEvents : [TestEvent] = []
        
        messageBus.observe(Event.self) { (e) in
            let testEvent = TestEvent()
            testEvent.receivedOrder = 0
            receivedEvents.append(testEvent)
        }
        
        messageBus.observe(Event.self) { (e) in
            let testEvent = TestEvent()
            testEvent.receivedOrder = 1
            receivedEvents.append(testEvent)
        }
        
        messageBus.observe(TestEvent.self) { (e) in
            let testEvent = TestEvent()
            testEvent.receivedOrder = 2
            receivedEvents.append(testEvent)
        }
        
        messageBus.observe(FirstLevelEvent.self) { (e) in
            let testEvent = TestEvent()
            testEvent.receivedOrder = 3
            receivedEvents.append(testEvent)
        }
        
        messageBus.observe(FirstLevelEvent.self) { (e) in
            let testEvent = TestEvent()
            testEvent.receivedOrder = 4
            receivedEvents.append(testEvent)
        }
        
        messageBus.observe(FirstLevelEvent.self) { (e) in
            let testEvent = TestEvent()
            testEvent.receivedOrder = 5
            receivedEvents.append(testEvent)
        }
        
        messageBus.observe(SecondLevelEvent.self) { (e) in
            let testEvent = TestEvent()
            testEvent.receivedOrder = 6
            receivedEvents.append(testEvent)
        }
        
        let event = SecondLevelEvent()
        messageBus.post(event)
        
        // Then expect
        XCTAssertEqual(7, receivedEvents.count)
        for i in 0...(receivedEvents.count - 1) {
            XCTAssertEqual(receivedEvents[i].receivedOrder, i)
        }
    
    }
    
    
}
