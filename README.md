MessageBus
================
![](http://img.shields.io/cocoapods/v/MessageBus.svg?style=flat) ![](http://img.shields.io/cocoapods/l/MessageBus.svg?style=flat) ![](http://img.shields.io/cocoapods/p/MessageBus.svg?style=flat)
![](https://travis-ci.org/mkloeppner/MessageBus.svg?branch=master)

MessageBus is a small and simple library written in swift for the simple use of broadcasting and receiving events.

## Usage

### Creation

A MessageBus can be created as an object. Other then NSNotificationCenter in OSX you can have as many instances as you want.   

```swift
let messageBus : MessageBus = SimpleMessageBus()
```

### Register events

MessageBus clients can register to observe events from the message bus.

Note that MessageBus infers the type of e from the observation class type Event.self.

```swift
messageBus.observe(Event.self) { (e) in
}

// e preserves the type of MyCustomEvent
messageBus.observe(MyCustomEvent.self) { (e) in

}
```

### Post events

MessageBus is being intended to be used accross services in a broader application.

As any event pattern this services can send events such as the following sample.

```swift
let event = MyCustomEvent()
messageBus.post(event)
```

### Subsequent events

MessageBus safely handles subsequentially posted events when it comes to order.

Note the following issue:

```swift
messageBus.observe(Purchase.self) { (purchaseEvent) in
  let trackEvent = TrackEvent(purchaseEvent)
  messageBus.post(trackEvent)
}
```

MessageBus defers the execution of the posting for the trackEvent right immediatly after the Purchase Event observation block has been exited its context, but still sustains the event order.
 

