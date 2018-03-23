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

for msg in messages {
    if msg.subject.lowercased().hasPrefix("priority") {
        priorityT.send(message: msg)
    } else if let index = msg.from.index(of: "@") {
        let suffix = msg.from[index..<msg.from.endIndex]
        if msg.to.hasSuffix(String(suffix)) {
            localT.send(message: msg)
        } else {
            remoteT.send(message: msg)
        }
    }
}
