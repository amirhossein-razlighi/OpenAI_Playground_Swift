//
//  ChatService.swift
//  AiPlayGround
//
//  Created by Amirhossein Razlighi on 27/03/2023.
//

import Foundation

class ChatService {
    let chatURL = URL(string: "https://api.openai.com/v1/chat/completions")!
    var messages: [OpenAIChatMessage] = []
    
    func sendMessage (message: String, completion: @escaping (String?) -> Void) {
        let latestMessage = OpenAIChatMessage(role: "user", content: message)
        messages.append(latestMessage)
        
        let session = URLSession.shared
        var req = URLRequest(url: chatURL)
        
        req.httpMethod = "POST"
        req.setValue("Bearer \(Constants.openAIAPIKey)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let chatBody = OpenAIChatBody(model: "gpt-3.5-turbo", messages: messages)
        let jsonData = try! JSONEncoder().encode(chatBody)
        req.httpBody = jsonData
        
        let task = session.dataTask(with: req) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            if let response = response as? HTTPURLResponse {
                print("Status code: \(response.statusCode)")
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let choices = json?["choices"] as? [[String: Any]], let messageDict = choices.first?["message"] as? [String: Any], let role = messageDict["role"] as? String, let content = messageDict["content"] as? String, role == "assistant" {
                let assistantMessage = OpenAIChatMessage(role: "system", content: content)
                    self.messages.append(assistantMessage)
                    completion(content)
                } else {
                    completion(nil)
                }
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        task.resume()
    }
}

struct OpenAIChatBody: Encodable {
    let model: String
    let messages: [OpenAIChatMessage]
}

struct OpenAIChatMessage: Encodable {
    let role: String
    let content: String
}
