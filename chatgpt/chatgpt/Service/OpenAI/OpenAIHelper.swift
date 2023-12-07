//
//  NetworkHelper.swift
//  chatgpt
//
//  Created by Burhan AFŞAR on 6.11.2023.
//

import Foundation

struct OpenAIHelper{
    static var shared: OpenAIHelper = OpenAIHelper()
    private init(){
        apiKey = URL(string: UserDefaultsManager.shared.loadApiKey())
        print(apiKey)
    }
    
    let baseURL = URL(string: "https://api.openai.com/v1")
    var apiKey = URL(string: "")
}

enum Path: String{
    case chat = "/chat/completions"
    
    func getPath() -> URL?{
        let fullURL = OpenAIHelper.shared.baseURL?.appendingPathComponent(self.rawValue)
        return fullURL ?? nil
    }
}
