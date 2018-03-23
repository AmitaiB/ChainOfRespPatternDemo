//
//  Transmitters.swift
//  ChainOfResp
//
//  Created by Amitai Blickstein on 3/23/18.
//  Copyright © 2018 Amitai Blickstein. All rights reserved.
//

import Foundation

class Transmitter {
    var nextLink: Transmitter?
    
    required init() {}
    
    func send(message: Message) {
        if let next = nextLink {
            next.send(message: message)
        } else {
            print("End of chain reached. Message not sent.")
        }
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
    override func send(message: Message) {
        if Transmitter.matchEmailSuffix(with: message) {
            print("Message to: \(message.to) sent locally")
        } else {
            super.send(message: message)
        }
    }
}

class RemoteTransmitter: Transmitter {
    override func send(message: Message) {
        if !Transmitter.matchEmailSuffix(with: message) {
            print("Message to: \(message.to) sent remotely")
        } else {
            super.send(message: message)
        }
    }
}

class PriorityTransmitter: Transmitter {
    override func send(message: Message) {
        if message.subject.lowercased().hasPrefix("priority") {
            print("Message to: \(message.to) sent as priority")
        } else {
            super.send(message: message)
        }
    }
}
