//
//  ChatView.swift
//  AiPlayGround
//
//  Created by Amirhossein Razlighi on 27/03/2023.
//

import SwiftUI

struct ChatView: View {
    @State private var chatMessages: [ChatMessage] = ChatMessage.sampleMessages
    @State private var userPrompt: String = ""
    private let chatService = ChatService()

    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(chatMessages, id: \.id) {message in
                        TextBubble(message: message)
                    }
                }
            }
            
            HStack {
                TextField("Enter Your Prompt", text: $userPrompt)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(13)
                
                Button(action: sendMessage) {
                    Text("Send!")
                        .foregroundColor(.white)
                        .padding()
                        .background(.black)
                        .cornerRadius(13)
                }
            }
        }
        .padding()
    }
    
    func sendMessage() {
        if userPrompt.isEmpty {
            return
        }
        
        let userMessage = ChatMessage(id: UUID().uuidString, content: userPrompt, dateCreated: Date(), sender: .User)
        chatMessages.append(userMessage)
        
        chatService.sendMessage(message: userPrompt) {assistantMessage in
            guard let assistantMessage = assistantMessage else {
                return
            }
            
            let message = ChatMessage(id: UUID().uuidString, content: assistantMessage, dateCreated: Date(), sender: .ChatBot)
            chatMessages.append(message)
        }
        userPrompt = ""
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
