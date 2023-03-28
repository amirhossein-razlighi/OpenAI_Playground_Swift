//
//  ChatView.swift
//  AiPlayGround
//
//  Created by Amirhossein Razlighi on 27/03/2023.
//

import SwiftUI

struct ChatView: View {
    @State private var chatMessages: [ChatMessage] = []
    @State private var userPrompt: String = ""
    @State private var isLoading: Bool = false
    
    private let chatService = ChatService()

    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(chatMessages, id: \.id) {message in
                        TextBubble(message: message, showBubble: message == chatMessages.last)
                    }
                }
            }
            
            HStack {
                TextField("Enter Your Prompt", text: $userPrompt)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(13)
                
                Button(action: sendMessage) {
                    if !isLoading {
                        Text("Send!")
                            .foregroundColor(.white)
                            .padding()
                            .background(userPrompt.isEmpty ? .black.opacity(0.2) : .black)
                            .cornerRadius(13)
                    } else {
                        ProgressView()
                            .padding()
                    }
                }
                .disabled(userPrompt.isEmpty)
            }
        }
        .padding()
    }
    
    func sendMessage() {
        isLoading = true
        if userPrompt.isEmpty {
            isLoading = false
            return
        }
        
        let userMessage = ChatMessage(id: UUID().uuidString, content: userPrompt, dateCreated: Date(), sender: .User)
        chatMessages.append(userMessage)
        
        chatService.sendMessage(message: userPrompt) {assistantMessage in
            guard let assistantMessage = assistantMessage else {
                isLoading = false
                return
            }
            
            isLoading = false
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
