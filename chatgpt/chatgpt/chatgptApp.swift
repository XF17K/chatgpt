//
//  chatgptApp.swift
//  chatgpt
//
//  Created by Burhan AFŞAR on 2.11.2023.
//

import SwiftUI

@main
struct chatgptApp: App {
    @State private var alert = false
    var body: some Scene {
        WindowGroup {
            
            let viewModel = HomeViewModel()
            
            HomeView()
                .frame(minWidth: 800, minHeight: 500)
                .navigationTitle("ChatGPT")
                .environmentObject(viewModel)
                
        }
    }
}
