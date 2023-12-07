//
//  ChatView.swift
//  chatgpt
//
//  Created by Burhan AFŞAR on 9.11.2023.
//

import SwiftUI

struct ChatView: View {
    @Binding var messages: [Message]
    
    var body: some View {
        VStack{
            ScrollViewReader{ scrollViewProxy in
                
                ScrollView{
                    VStack{
                        ForEach(Array(messages.enumerated()), id: \.element){ index, message in
                            ChatText(message: message).id(index)
                        }
                    }
                }.onChange(of: messages.count) { newValue in
                    withAnimation{
                        scrollViewProxy.scrollTo(messages.count - 1)
                    }
                    
                }
                
            }
        }
    }
}

#Preview {
    ChatView(messages: .constant([Message(role: .user, content: "merhaba")]))
}
