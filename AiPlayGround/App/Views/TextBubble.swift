//
//  TextBubble.swift
//  AiPlayGround
//
//  Created by Amirhossein Razlighi on 28/03/2023.
//

import SwiftUI

struct TextBubble: View {
    let message: ChatMessage
    let showBubble: Bool
    
    var body: some View {
        HStack {
            if message.sender == .User {
                Spacer()
            }
            
            Text(message.content)
                .foregroundColor(message.sender == .User ? .white : .black)
                .padding()
                .background(message.sender == .User ? .blue : .gray.opacity(0.1))
            .cornerRadius(17)
            .overlay(alignment: message.sender == .User ? .bottomTrailing : .bottomLeading) {
                if showBubble {
                    Image(systemName: "arrowtriangle.down.fill")
                        .font(.title2)
                        .rotationEffect(.degrees(message.sender == .User ? -45 : 45))
                        .offset(x: message.sender == .User ? 20 : -22, y: 24)
                        .foregroundColor(message.sender == .User ? .blue : .gray.opacity(0.1))
                        .padding()
                }
            }
            
            if message.sender == .ChatBot {
                Spacer()
            }
        }
    }
}

struct TextBubble_Previews: PreviewProvider {
    static var previews: some View {
        TextBubble(message: ChatMessage(id: UUID().uuidString, content: "Hi  There!", dateCreated: Date(), sender: .User), showBubble: false)
            .padding()
    }
}
