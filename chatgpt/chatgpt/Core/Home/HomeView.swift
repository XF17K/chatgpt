//
//  HomeView.swift
//  chatgpt
//
//  Created by Burhan AFŞAR on 2.11.2023.
//

import SwiftUI

struct HomeView: View {
    //@ObservedObject private var viewModel: HomeViewModel = HomeViewModel()
    @EnvironmentObject var viewModel: HomeViewModel
    
    private var isSideBarOpen: Bool = true
    @State private var text: String = ""
 
    var body: some View {
        HStack{
            SideBarLeft()
            Divider()
            VStack{
                
                TabView(selection: $viewModel.selectedTab){
                    ChatView(messages: $viewModel.messages[0]).tabItem { Text("ChatGPT 3.5 Turbo") }.tag(0)
                    ChatView(messages: $viewModel.messages[1]).tabItem { Text("ChatGPT 4") }.tag(1)
                    ChatView(messages: $viewModel.messages[2]).tabItem { Text("ChatGPT 4 Turbo") }.tag(2)
                }.onAppear{
                    
                }
    
                Spacer()
                HStack{
                    TextField("Enter....", text: $text).onSubmit {
                            if !text.isEmpty && text.count > 3{
                            viewModel.sendMessage(message: text)
                            text = ""
                        }
                    }
                        .frame(height: 30)
                        .textFieldStyle(.plain)
                        .padding(.horizontal)
                        .background(.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                    
                    Button{
                        if !text.isEmpty && text.count > 3{
                            viewModel.sendMessage(message: text)
                            text = ""
                        }
                    }label: {
                        Text("Send")
                            .frame(height: 30)
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .background(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            
                    }.buttonStyle(.plain)
                }
                
            }.padding()
            Divider()
            SideBarRight()
        }.onAppear{
            //UserDefaultsManager.shared.clearChat()
        }
    }
}

#Preview {
    HomeView()
}
