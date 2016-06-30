//
//  MessageBus.swift
//  MessageBus
//
//  Created by Martin Klöppner on 30.06.16.
//  Copyright © 2016 Martin Klöppner. All rights reserved.
//

import Foundation

public protocol MessageBus {

    func observe<E>(_ eventType: E.Type, actionHandler: @escaping ((E) -> Void)) where E : Event;

    func post(_ event : Event);
    
}
