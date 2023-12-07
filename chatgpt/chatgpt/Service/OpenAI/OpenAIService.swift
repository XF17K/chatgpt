//
//  NetworkManager.swift
//  chatgpt
//
//  Created by Burhan AFŞAR on 6.11.2023.
//

import Foundation
import Alamofire

class OpenAIService{
    static let shared: OpenAIService = OpenAIService()
    
    private init(){}
    
    func fetch(url: URL,body: ChatCompletionRequest ,completion: @escaping (Result<ChatCompletionResponse, Error>) -> Void){
        //let body = ChatCompletionRequest(model: Model.gpt3_5_turbo, messages: messages, temperature: 0.7, maxTokens: 512)
        print("model: \(body.model) maxToken: \(body.maxTokens) temperature: \(body.temperature)")
        
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(OpenAIHelper.shared.apiKey!)"
        ]
        
        DispatchQueue.main.async{
            AF.request(url.absoluteString, method: .post, parameters: body, encoder: .json, headers: headers).responseDecodable(of: ChatCompletionResponse.self) { response in
                switch response.result{
                case .success(let result):
                    completion(.success(result))
                case .failure(let error):
                    print("JSON Parse error")
                    completion(.failure(error))
                }
            }
        }
    }
}
