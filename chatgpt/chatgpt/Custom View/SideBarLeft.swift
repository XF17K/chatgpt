//
//  SideBar.swift
//  chatgpt
//
//  Created by Burhan AFŞAR on 5.11.2023.
//

import SwiftUI
import Combine

struct SideBarLeft: View {
    @State var isOpen: Bool = true
    @State var showingAlert: Bool = false
    @State var apiKey: String = ""
    
    //UserDefaultsManager
    @ObservedObject var userDefaultsManager = UserDefaultsManager.shared
    @State var cancellables: Set<AnyCancellable> = []
    //
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        
        NavigationStack{
            if isOpen{
                VStack(alignment: .leading){
                    List(userDefaultsManager.savedChats){ item in
                        SideBarChat(chat: item)
                    }.listStyle(.sidebar)
                    
                    HStack{
                        Button{
                            viewModel.clearChat()
                        }label: {
                            Image(systemName: "plus.app")
                                .font(.title)
                        }.buttonStyle(PlainButtonStyle())
                        
                    }.padding()
                    
                }.frame(minWidth: 200, maxWidth: 300, maxHeight: .infinity, alignment: .leading)
                
            } else{
                VStack{
                    
                }.frame(maxHeight: .infinity)
            }
        }.toolbar{
            ToolbarItem(placement: .navigation) {
                Button{
                    toogle()
                }label: {
                    Image(systemName: "sidebar.left")
                }
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button{
                    showingAlert = true
                }label: {
                    Image(systemName: "key.horizontal.fill")
                }.alert("API KEY", isPresented: $showingAlert){
                    TextField("Enter an OpenAI's API KEY", text: $apiKey)
                    Button{
                        UserDefaultsManager.shared.setApiKey(apiKey: apiKey)
                    }label: {
                        Text("OK")
                    }
                    Button("Cancel", role: .cancel){showingAlert = false}
                    
                }
            }
            
            
            
        }.onAppear{
            UserDefaultsManager.shared.loadChat()
            
            userDefaultsManager.$savedChats.sink { received in
                //savedChats = received
            }.store(in: &cancellables)
            
            //UserDefaultsManager.shared.clearChat()
        }
    }
    
    func toogle(){
        withAnimation{
            isOpen.toggle()
        }
    }
}

#Preview {
    SideBarLeft()
}
