//
//  FirstlevelEvent.swift
//  MessageBus
//
//  Created by Martin Klöppner on 01.07.16.
//  Copyright © 2016 Martin Klöppner. All rights reserved.
//

import Foundation
@testable import MessageBus

class TestEvent : Event {
    var receivedOrder : Int?
}

class FirstLevelEvent : TestEvent {
    
}

class SecondLevelEvent: FirstLevelEvent {
    
}

class ThirdLevelEvent: SecondLevelEvent {
    
}

class AnotherEvent: TestEvent {
    
}
