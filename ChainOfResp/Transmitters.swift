//
//  Transmitters.swift
//  ChainOfResp
//
//  Created by Amitai Blickstein on 3/23/18.
//  Copyright © 2018 Amitai Blickstein. All rights reserved.
//

import Foundation

class BoolWrapper: ExpressibleByBooleanLiteral {
    var value: Bool
    
    required init(booleanLiteral value: BooleanLiteralType) {
        self.value = value
    }
}

/// Abstract base class for `Transmitter` objects.
class Transmitter {
    var nextLink: Transmitter?
    
    required init() {}
    
    func send(message: Message, handled: BoolWrapper = false) -> Bool {
        if let next = nextLink {
            return next.send(message: message, handled: handled)
        } else if !handled.value {
            print("End of chain reached. Message not sent.")
            return false
        }
        return handled.value
    }
    
    fileprivate class func matchEmailSuffix(with message: Message) -> Bool {
        if let atIndex = message.from.index(of: "@") {
            return message.to.hasSuffix(String(message.from[atIndex..<message.from.endIndex]))
        }
        return false
    }
    
    class func createChain(localOnly: Bool) -> Transmitter? {
        let transmitterClasses: [Transmitter.Type] = localOnly ?
            [ PriorityTransmitter.self, LocalTransmitter.self ] :
            [ PriorityTransmitter.self, LocalTransmitter.self, RemoteTransmitter.self ]
        
        var link: Transmitter?
        
        for tClass in transmitterClasses.reversed() {
            let existingLink = link
            link = tClass.init()
            link?.nextLink = existingLink
        }
        
        return link
    }
}


class LocalTransmitter: Transmitter {
    override func send(message: Message, handled: BoolWrapper) -> Bool {
        if !handled.value && Transmitter.matchEmailSuffix(with: message) {
            print("Message to: \(message.to) sent locally")
            handled.value = true
        }
        return super.send(message: message, handled: handled)
    }
}

class RemoteTransmitter: Transmitter {
    override func send(message: Message, handled: BoolWrapper) -> Bool {
        if !handled.value && !Transmitter.matchEmailSuffix(with: message) {
            print("Message to: \(message.to) sent remotely")
            handled.value = true
        }
        return super.send(message: message, handled: handled)
    }
}

class PriorityTransmitter: Transmitter {
    var totalMessages = 0
    var handledMessages = 0
    
    override func send(message: Message, handled: BoolWrapper) -> Bool {
        totalMessages += 1
        if !handled.value && message.subject.lowercased().hasPrefix("priority") {
            handledMessages += 1
            print("Message to: \(message.to) sent as priority")
            print("Stats: Handled \(handledMessages) of \(totalMessages)")
            handled.value = true
        }
        return super.send(message: message, handled: handled)
    }
}
