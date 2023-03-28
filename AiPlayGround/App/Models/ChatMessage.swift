//
//  ChatMessage.swift
//  AiPlayGround
//
//  Created by Amirhossein Razlighi on 27/03/2023.
//

import Foundation

struct ChatMessage: Equatable {
    let id: String
    let content: String
    let dateCreated: Date
    let sender: MessageSender
}

extension ChatMessage {
    static let sampleMessages = [
        ChatMessage(id: UUID().uuidString, content: "This is a message from me!", dateCreated: Date(), sender: .User),
        ChatMessage(id: UUID().uuidString, content: "This is a message from you!", dateCreated: Date(), sender: .ChatBot),
        ChatMessage(id: UUID().uuidString, content: "This is a message from you!", dateCreated: Date(), sender: .ChatBot),
        ChatMessage(id: UUID().uuidString, content: "This is a message from me!", dateCreated: Date(), sender: .User),
    ]
}
