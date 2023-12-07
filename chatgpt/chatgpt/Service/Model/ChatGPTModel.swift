//
//  Model.swift
//  chatgpt
//
//  Created by Burhan AFŞAR on 6.11.2023.
//

import Foundation

//Comlpletion: 1 text?
//ChatCompletion: chat, multi text

//REQUEST - SENDING
struct ChatCompletionRequest: Encodable{
    let model: Model
    let messages: [Message]
    let temperature: Double //0.7
    let maxTokens: Int
    
    enum CodingKeys: String, CodingKey{
        case model, messages, temperature
        case maxTokens = "max_tokens"
    }
}

//RESPONSE
struct ChatCompletionResponse: Decodable{
    let id: String?
    let object: ChatObject?
    let created: Int? //timeStamp
    let model: Model?
    let choices: [Choice]?
    let usage: Usage?
}


enum ChatObject: String, Codable{
    case completion = "chat.completion"
    case chunk = "chat.completion.chunk"
}

enum Model: String, Codable{
    case gpt3_5_turbo = "gpt-3.5-turbo-1106" //gpt-3.5-turbo-0613
    case gpt4 = "gpt-4-0613" //update gpt-4-0613
    case gpt4_turbo = "gpt-4-1106-preview"
}
//
struct Message: Codable, Hashable{
    let role: RoleEnum
    let content: String
}

enum RoleEnum: String, Codable{
    case system
    case user
    case assistant
}

struct Choice: Codable{
    let finishReason: String
    let index: Int
    let message: Message
    
    enum CodingKeys: String, CodingKey{
        case finishReason = "finish_reason"
        case index, message
    }
}

struct Usage: Codable{
    var completionTokens, promptTokens, totalTokens: Int
    
    enum CodingKeys: String, CodingKey{
        case completionTokens = "completion_tokens"
        case promptTokens = "prompt_tokens"
        case totalTokens = "total_tokens"
    }
}

enum FinishReasonEnum{
    case stop
    case length
    case functionCall
    case contentFilter
    case null
    
    enum CodingKeys: String, CodingKey{
        case stop, length
        case fuctionCall = "function_call"
        case contentFilter = "content_filter"
        case null
    }
}
