//
//  Transmitters.swift
//  ChainOfResp
//
//  Created by Amitai Blickstein on 3/23/18.
//  Copyright © 2018 Amitai Blickstein. All rights reserved.
//

import Foundation


class LocalTransmitter {
    func send(message: Message) {
        print("Message to: \(message.to) sent locally")
    }
}

class RemoteTransmitter {
    func send(message: Message) {
        print("Message to: \(message.to) sent remotely")
    }
}

class PriorityTransmitter {
    func send(message: Message) {
        print("Message to: \(message.to) sent as priority")
    }
}
