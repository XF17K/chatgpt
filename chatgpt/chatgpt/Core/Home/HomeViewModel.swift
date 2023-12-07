//
//  HomeViewModel.swift
//  chatgpt
//
//  Created by Burhan AFŞAR on 2.11.2023.
//

import Foundation

class HomeViewModel: ObservableObject{
    @Published var selectedTab = 0
    
    @Published var messages: [[Message]] = [[],[],[]] //2D Array: Tabs 0,1,2
    @Published var usages: [Usage] = [Usage(completionTokens: 0, promptTokens: 0, totalTokens: 0), Usage(completionTokens: 0, promptTokens: 0, totalTokens: 0), Usage(completionTokens: 0, promptTokens: 0, totalTokens: 0)]
    @Published var totalPrice: [Double] = [0,0,0]
    
    //@Published var selectedMaxToken: Int = 128
    //@Published var selectedTemperature: Double = 0.7
    
    func sendMessage(message: String){
        let message = [Message(role: .user, content: message)]
        self.messages[selectedTab].append(message.first!)
        let profileSettings = UserDefaultsManager.shared.getProfileSettings(index: selectedTab)
        let body = ChatCompletionRequest(model: profileSettings.model, messages: messages[selectedTab], temperature: profileSettings.temperature, maxTokens: profileSettings.maxTokens)
        
        OpenAIService.shared.fetch(url: Path.chat.getPath()!, body: body){ (result: Result<ChatCompletionResponse, Error>) in
            switch result{
            case .success(let response):
                guard let message = response.choices?.first?.message else{
                    return
                }
                DispatchQueue.main.async{
                    self.messages[self.selectedTab].append(message)
                    self.usages[self.selectedTab].totalTokens += response.usage?.totalTokens ?? 0
                    self.usages[self.selectedTab].promptTokens += response.usage?.promptTokens ?? 0
                    self.usages[self.selectedTab].completionTokens += response.usage?.completionTokens ?? 0
                    self.calculateTotalPrice()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func calculateTotalPrice(){
        var inputFactor: Double = 0
        var outputFactor: Double = 0
        
        switch selectedTab{
        case 0:
            inputFactor = 1 / 1000000
            outputFactor = 1 / 2000000
        case 1:
            inputFactor = 1 / 300000
            outputFactor = 1 / 600000
        case 2:
            inputFactor = 1 / 100000
            outputFactor = 1 / 200000
        default:
            print()
        }
        
        totalPrice[selectedTab] += Double(usages[selectedTab].promptTokens) * inputFactor
        totalPrice[selectedTab] += Double(usages[selectedTab].completionTokens) * outputFactor
        
        
    }
    
    func clearChat(){
        messages[selectedTab] = []
        usages[selectedTab] = Usage(completionTokens: 0, promptTokens: 0, totalTokens: 0)
        totalPrice[selectedTab] = 0
    }
}
