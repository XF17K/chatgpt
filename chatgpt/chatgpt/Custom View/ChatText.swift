//
//  ChatText.swift
//  chatgpt
//
//  Created by Burhan AFŞAR on 6.11.2023.
//

import SwiftUI
import MarkdownUI
import Splash


struct ChatText: View {
    let message: Message
    @Environment(\.colorScheme) private var colorScheme
    
    private var theme: Splash.Theme{
        switch self.colorScheme{
        case .dark:
            return .wwdc17(withFont: .init(size: 16))
        default:
            return .sunset(withFont: .init(size: 16))
        }
    }
    
    var body: some View {
        HStack{
            if message.role == .user{
                Spacer()
                    //.frame(width: 100)
            }
//            Text(message.content)
//                .padding()
//                .foregroundStyle(message.role == .user ? .white : .black)
//                .background(message.role == .user ? .blue : .white)
//                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            if message.role == .user{
                Text(message.content)
                                .padding()
                                .foregroundStyle(.white)
                                .background(.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
            }else{
                Markdown(message.content)
                    .padding()
                    .foregroundStyle(.black)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .markdownTheme(.gitHub2)
            }
            
            if message.role != .user{
                Spacer()
                    //.frame(width: 100)
            }
        }//.padding(.vertical, 8)
            .padding(.horizontal, 8)
    }
}


#Preview {
    ChatText(message: Message(role: .user, content: "Merhaba"))
}
