//
//  SideBarRight.swift
//  chatgpt
//
//  Created by Burhan AFŞAR on 8.11.2023.
//

import SwiftUI
import Combine

struct SideBarRight: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    
    @State var isOpen: Bool = true
    
    @State private var showingSaveAlert: Bool = false
    @State private var chatTitle: String = ""
    @State private var maxToken: Int = 128
    @State private var temperature: Double = 0.7
    @State private var totalPrice: Double = 0.0
    @State private var totalToken: Int = 0
    
    @State var cancellables: Set<AnyCancellable> = []
    
    private let maxTokenArray: [Int] = [
        128,
        256,
        512,
        1024,
        2048,
        5096,
    ]
    
    private let temperatureArray: [Double] = [
        0.1,
        0.2,
        0.3,
        0.4,
        0.5,
        0.6,
        0.7,
        0.8,
        0.9,
        1.0
    ]
    
    var body: some View {
        VStack{
            if isOpen{
                
                
                VStack(alignment: .leading){
                    Text("Settings")
                        .font(.title)
                    
                    Picker("Max Tokens:", selection: $maxToken){
                        ForEach(maxTokenArray, id: \.self){ token in
                            Text("\(token)")
                        }
                    }.onAppear{
                        maxToken = userDefaultsManager.profilesSettings[viewModel.selectedTab].maxTokens
                     //default
                    }.onChange(of: maxToken){ oldValue, newValue in
                            UserDefaultsManager.shared.updateProfileSettings(maxTokens: newValue, index: viewModel.selectedTab)
                        }
                        .frame(maxWidth: 150)
                    
                    Picker("Temperature:", selection: $temperature){
                        ForEach(temperatureArray, id: \.self){ value in
                            Text(String(format: "%.1f", value))
                        }
                    }.frame(maxWidth: 150)
                        .onAppear{
                            //self.selectedTemperature = temperatureArray[6]
                            temperature = userDefaultsManager.profilesSettings[viewModel.selectedTab].temperature
                        }
                        .onChange(of: temperature){ oldValue, newValue in
                            UserDefaultsManager.shared.updateProfileSettings(temperature: newValue, index: viewModel.selectedTab)
                        }
                    
                    
                    
                    
                    
                    Spacer()
                    Text("Total Tokens: \(totalToken)")
                    Text("Total Price: \(String(format: "%.6f", totalPrice)) $")
                    Button{
                        showingSaveAlert = true
                        //print("Kayıt yapıldı")
                        //UserDefaultsManager.shared.addChat(chat: SavedChat(title: "1", model: .gpt3_5_turbo, date: Date.now, messages: viewModel.messages[selectedTab]))
                        
                    }label: {
                        Text("Save Chat")
                            .frame(height: 30)
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }.buttonStyle(.plain)
                        .alert("Chat Title", isPresented: $showingSaveAlert){
                            TextField("Give a title to chat", text: $chatTitle)
                            Button{
                                UserDefaultsManager.shared.addChat(chat: SavedChat(title: chatTitle, model: userDefaultsManager.profilesSettings[viewModel.selectedTab].model, date: Date.now, messages: viewModel.messages[viewModel.selectedTab], usage: viewModel.usages[viewModel.selectedTab]))
                            }label: {
                                Text("OK")
                            }
                            Button("Cancel", role: .cancel){showingSaveAlert = false}
                            
                        }
                }.frame(maxHeight: .infinity, alignment: .trailing)
                    .padding(.vertical)
                    .padding(.trailing)
            }else{
                VStack{
                    
                }.frame(maxHeight: .infinity)
            }
        }.toolbar{
            ToolbarItem(placement: .primaryAction) {
                Button{
                    toogle()
                }label: {
                    Image(systemName: "sidebar.right")
                }
            }
        }
        .onAppear{
            UserDefaultsManager.shared.loadProfileSettings()
            
            viewModel.$selectedTab.sink { received in
                maxToken = userDefaultsManager.profilesSettings[received].maxTokens
                temperature = userDefaultsManager.profilesSettings[received].temperature
            }.store(in: &cancellables)
            
            viewModel.$totalPrice.sink { received in
                totalPrice = received[viewModel.selectedTab]
            }.store(in: &cancellables)
            
            viewModel.$usages.sink { received in
                totalToken = received[viewModel.selectedTab].totalTokens
            }.store(in: &cancellables)
            
            //UserDefaultsManager.shared.loadChat()
        }
    }
    func toogle(){
        withAnimation{
            isOpen.toggle()
        }
    }
}

#Preview {
    SideBarRight()
}
