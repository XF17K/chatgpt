//
//  UserDefaultsManager.swift
//  chatgpt
//
//  Created by Burhan AFŞAR on 9.11.2023.
//

import Foundation

class UserDefaultsManager: ObservableObject{
    static let shared: UserDefaultsManager = UserDefaultsManager()
    private init (){}
    
    @Published var profilesSettings: [ProfileSettings] = []
    @Published var savedChats: [SavedChat] = []
    
    func updateProfileSettings(maxTokens: Int? = nil, temperature: Double? = nil, index: Int){
        if maxTokens != nil{
            profilesSettings[index].maxTokens = maxTokens!
        }
        if temperature != nil{
            profilesSettings[index].temperature = temperature!
        }
        saveProfileSettings()
    }
    
    func getProfileSettings(index: Int) -> ProfileSettings{
        return profilesSettings[index]
    }
    
    func saveProfileSettings(){
        if let encoded = try? JSONEncoder().encode(profilesSettings){
            UserDefaults.standard.set(encoded, forKey: "ProfilesSettings")
        }
    }
    
    func loadProfileSettings(){
        if UserDefaults.standard.object(forKey: "ProfilesSettings") != nil{
            let decoded = try! JSONDecoder().decode([ProfileSettings].self, from: UserDefaults.standard.data(forKey: "ProfilesSettings")!)
            profilesSettings = decoded
        }else{
            createDefaultSettings()
        }
        print(profilesSettings)
    }
    
    func createDefaultSettings(){
        //profilesSettings[0] = ProfileSettings(model: .gpt3_5_turbo, maxTokens: 128, temperature: 0.7)
        //profilesSettings[1] = ProfileSettings(model: .gpt4, maxTokens: 128, temperature: 0.7)
        //profilesSettings[2] = ProfileSettings(model: .gpt4_turbo, maxTokens: 128, temperature: 0.7)
        profilesSettings.append(ProfileSettings(model: .gpt3_5_turbo, maxTokens: 128, temperature: 0.7))
        profilesSettings.append(ProfileSettings(model: .gpt4, maxTokens: 128, temperature: 0.7))
        profilesSettings.append(ProfileSettings(model: .gpt4_turbo, maxTokens: 128, temperature: 0.7))
        
        if let encoded = try? JSONEncoder().encode(profilesSettings){
            UserDefaults.standard.set(encoded, forKey: "ProfilesSettings")
        }
    }
    
    // SAVE CHAT
    
    func saveChat(){
        if let encoded = try? JSONEncoder().encode(savedChats){
            UserDefaults.standard.set(encoded, forKey: "SavedChats")
        }
    }
    
    func loadChat(){
        if UserDefaults.standard.object(forKey: "SavedChats") != nil{
            print("Save Bulundu")
            let decoded = try! JSONDecoder().decode([SavedChat].self, from: UserDefaults.standard.data(forKey: "SavedChats")!)
            savedChats = decoded
        }else{
            print("Boş Save Oluşturuldu")
            saveChat()
            //
        }
    }
    
    func addChat(chat: SavedChat){
        savedChats.append(chat)
        saveChat()
    }
    
    func clearChat(){
        savedChats = []
        saveChat()
    }
    
    func setApiKey(apiKey: String){
        UserDefaults.standard.set(apiKey, forKey: "apiKey")
        let url = URL(string: apiKey)
        OpenAIHelper.shared.apiKey = url
    }
    
    func loadApiKey() -> String{
        return UserDefaults.standard.string(forKey: "apiKey") ?? ""
    }
}
