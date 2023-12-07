//
//  UserDefaultsModel.swift
//  chatgpt
//
//  Created by Burhan AFŞAR on 9.11.2023.
//

import Foundation

struct ProfileSettings: Codable{
    let model: Model
    var maxTokens: Int
    var temperature: Double
}

struct SavedChat: Codable, Identifiable{
    var id = UUID()
    let title: String
    let model: Model
    let date: Date
    var messages: [Message]
    var usage: Usage
}
