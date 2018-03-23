//
//  main.swift
//  ChainOfResp
//
//  Created by Amitai Blickstein on 3/23/18.
//  Copyright © 2018 Amitai Blickstein. All rights reserved.
//

import Foundation

let messages = [
    Message(from: "bob@example.com", to: "joe@example.com", subject: "Free for lunch?"),
    Message(from: "joe@example.com", to: "alice@acme", subject: "New Contracts"),
    Message(from: "pete@example.com", to: "all@example.com", subject: "Priority: All-Hands Meeting")
]

let localT = LocalTransmitter()
let remoteT = RemoteTransmitter()
let priorityT = PriorityTransmitter()

if let chain = Transmitter.createChain(localOnly: true) {
    for msg in messages {
        let handled = chain.send(message: msg)
        print("Message sent: \(handled)\n")
    }
}
