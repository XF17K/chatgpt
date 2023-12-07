//
//  SideBarChat.swift
//  chatgpt
//
//  Created by Burhan AFŞAR on 8.11.2023.
//

import SwiftUI

struct SideBarChat: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    let chat: SavedChat
    @State var showingAlert: Bool = false
    
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text(chat.title)
                        .font(.title)
                    Text(chat.date.formatted(.dateTime.day().month().year()))
                        .font(.subheadline)
                        .foregroundStyle(.blue)
                    Text("Tokens: \(chat.usage.totalTokens)")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                Spacer()
                Text(chat.model.rawValue)
                    .font(.subheadline)
                    .bold()
                    .padding()
                    .background(chat.model == Model.gpt3_5_turbo ? .green : .pink)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }.padding()
        }.frame(maxWidth: .infinity)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            //.padding()
            .onTapGesture {
                showingAlert = true
            }.alert("Do you want to load the chat?", isPresented: $showingAlert){
                
                Button{
                    var selectedTab: Int
                    switch chat.model{
                    case .gpt3_5_turbo:
                        selectedTab = 0
                    case .gpt4:
                        selectedTab = 1
                    case .gpt4_turbo:
                        selectedTab = 2
                    }
                    viewModel.selectedTab = selectedTab
                    viewModel.messages[selectedTab] = chat.messages
                    viewModel.usages[selectedTab] = chat.usage
                    viewModel.totalPrice[selectedTab] = 0
                    viewModel.calculateTotalPrice()
                }label: {
                    Text("OK")
                }
                Button("Cancel", role: .cancel){showingAlert = false}}
    }
}

#Preview {
    SideBarChat(chat: SavedChat(title: "", model: .gpt3_5_turbo, date: Date.now, messages: [], usage: Usage(completionTokens: 0, promptTokens: 0, totalTokens: 0)))
}
